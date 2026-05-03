import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../profile/controller/profile_controller.dart';
import '../repositories/subscription_repo.dart';

class SubscriptionController extends GetxController {
  final _subscriptionRepo = Get.find<SubscriptionRepo>();
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  final products = <ProductDetails>[].obs;
  final isLoading = false.obs;
  final isStoreAvailable = false.obs;
  
  // Product IDs from App Store Connect
  static const String _monthlySubscriptionId = 'month_subscription';

  @override
  void onInit() {
    super.onInit();
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _listenToPurchaseUpdated,
      onDone: () => _subscription.cancel(),
      onError: (error) => debugPrint('Purchase Stream Error: $error'),
    );
    initStore();
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }

  Future<void> initStore() async {
    final bool available = await _inAppPurchase.isAvailable();
    isStoreAvailable.value = available;
    
    if (available) {
      await fetchProducts();
    }
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    try {
      const Set<String> _kIds = <String>{_monthlySubscriptionId};
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_kIds);
      
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
      }
      
      products.assignAll(response.productDetails);
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> subscribe(ProductDetails product) async {
    late PurchaseParam purchaseParam;

    if (Platform.isIOS) {
      // For Apple, we might need to handle transition from another subscription
      // but for now simple purchase
      purchaseParam = PurchaseParam(productDetails: product);
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } else if (Platform.isAndroid) {
      // Future Android implementation
      purchaseParam = PurchaseParam(productDetails: product);
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        isLoading.value = true;
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint('Purchase Error: ${purchaseDetails.error}');
          isLoading.value = false;
          Get.snackbar('Error', 'Purchase failed: ${purchaseDetails.error?.message}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                   purchaseDetails.status == PurchaseStatus.restored) {
          
          // Verify with backend
          bool verified = await _verifyPurchase(purchaseDetails);
          
          if (verified) {
            Get.snackbar('Success', 'Subscription active!');
            // Refresh profile to update UI with new subscription status
            Get.find<ProfileController>().refreshProfile();
          }
        }
        
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
        isLoading.value = false;
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // 1. Get receipt data
    String? receiptData;
    
    if (Platform.isIOS) {
      receiptData = purchaseDetails.verificationData.serverVerificationData;
    }
    
    if (receiptData == null) return false;

    // 2. Send to backend
    final result = await _subscriptionRepo.verifyApplePurchase(receiptData);
    
    return result.fold(
      (failure) {
        debugPrint('Backend Verification Failed: ${failure.message}');
        Get.snackbar('Verification Failed', failure.message);
        return false;
      },
      (success) {
        debugPrint('Backend Verification Success');
        return true;
      },
    );
  }

  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      debugPrint('Restore failed: $e');
    }
  }
}
