import 'package:get/get.dart';
import '../../../core/api/network_stream.dart';
import '../../../core/services/auth_storage_service.dart';
import '../../auth/models/user_response_model.dart';
import '../../auth/screens/login_screen.dart';
import '../repo/profile_repo.dart';

class ProfileController extends GetxController {
  final _profileRepo = Get.find<ProfileRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();


  final Rxn<UserModel> userProfile = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile({bool isRefresh = false}) async {
    return _profileRepo
        .getProfile(forceRefresh: isRefresh)
        .bind(rx: userProfile, loading: isLoading);
  }

  Future<void> logout() async {
    await _authStorageService.clearAuthData();
    Get.offAll(() => const LoginScreen());
  }
}
