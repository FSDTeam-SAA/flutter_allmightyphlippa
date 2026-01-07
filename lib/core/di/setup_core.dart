import 'package:get/get.dart';

import '../api/api_client.dart';
import '../services/auth_storage_service.dart';

void setupCore() {
  Get.lazyPut(() => ApiClient(), fenix: true);
  Get.lazyPut(() => AuthStorageService());
}
