import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_storage_service.dart';
import '../../auth/models/user_response_model.dart';
import '../../auth/screens/login_screen.dart';
import '../repo/profile_repo.dart';

class ProfileController extends GetxController {
  final ProfileRepo _profileRepo;
  final AuthStorageService _authStorageService;

  ProfileController(this._profileRepo, this._authStorageService);

  final Rxn<UserModel> userProfile = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    isLoading.value = true;
    _profileRepo.getProfile().listen(
      (result) {
        result.fold(
          (failure) {
            DPrint.error("Error fetching profile: ${failure.message}");
          },
          (success) {
            userProfile.value = success.data;
          },
        );
        // Only set loading to false after we get some data (cache or remote)
        // or if we want it to stay loading until remote finishes, keep it true.
        // Usually, if we have cache, we want loading to be false.
        if (userProfile.value != null || result.isLeft()) {
          isLoading.value = false;
        }
      },
      onDone: () => isLoading.value = false,
      onError: (e) {
        DPrint.error("Stream error: $e");
        isLoading.value = false;
      },
    );
  }

  Future<void> logout() async {
    await _authStorageService.clearAuthData();
    Get.offAll(() => const LoginScreen());
  }
}
