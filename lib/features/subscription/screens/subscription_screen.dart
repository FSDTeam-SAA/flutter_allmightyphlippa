import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../profile/controller/profile_controller.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionController());
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Subscription',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 60),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (controller.products.isEmpty) {
                return _buildEmptyState(controller);
              }

              return Column(
                children: controller.products.map((product) {
                  return _buildSubscriptionCard(
                    product,
                    controller,
                    profileController,
                  );
                }).toList(),
              );
            }),
            const Spacer(),
            _buildRestoreButton(controller),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(SubscriptionController controller) {
    return Column(
      children: [
        const Icon(Icons.error_outline, color: Colors.grey, size: 48),
        const SizedBox(height: 16),
        const Text(
          'No plans available right now',
          style: TextStyle(color: Colors.white),
        ),
        TextButton(
          onPressed: controller.fetchProducts,
          child: const Text(
            'Try Again',
            style: TextStyle(color: AppColors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard(
    dynamic product,
    SubscriptionController controller,
    ProfileController profileController,
  ) {
    final bool isActive =
        profileController.userProfile.value?.subscriptionStatus == 'active';

    return GestureDetector(
      onTap: isActive ? null : () => controller.subscribe(product),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        ),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: product.price, // Assuming this is "$2.99"
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' /month',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 16),
            _buildFeatureRow('Watch all you want.'),
            const SizedBox(height: 12),
            _buildFeatureRow('Full Quality for Video Watch'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildRestoreButton(SubscriptionController controller) {
    return TextButton(
      onPressed: controller.restorePurchases,
      child: Text(
        'Restore Purchases',
        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
      ),
    );
  }
}
