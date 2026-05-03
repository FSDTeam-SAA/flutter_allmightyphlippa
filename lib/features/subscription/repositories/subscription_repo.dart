import 'package:flutter_almightyflippa/core/constants/api_constants.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/network_result.dart';

class SubscriptionRepo {
  final ApiClient _apiClient = ApiClient();

  NetworkResult<Map<String, dynamic>> verifyApplePurchase(
    String receiptData,
  ) async {
    return await _apiClient.post(
      endpoint: ApiConstants.payment.verifyApplePurchase,
      data: {'receiptData': receiptData},
      fromJsonT: (json) => json,
    );
  }

  NetworkResult<Map<String, dynamic>> getSubscriptionStatus() async {
    return await _apiClient.get(
      endpoint: ApiConstants.payment.getMySubscription,
      fromJsonT: (json) => json,
    );
  }
}
