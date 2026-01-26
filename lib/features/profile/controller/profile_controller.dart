import 'package:flutter_almightyflippa/core/services/multiple_form_data_manager.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/api/network_stream.dart';
import '../../../core/services/auth_storage_service.dart';
import '../../auth/models/user_response_model.dart';
import '../../auth/screens/login_screen.dart';
import 'package:flutter_almightyflippa/features/video/models/watch_history_model.dart';
import 'package:flutter_almightyflippa/features/video/repositories/video_status_repo.dart';
import '../repo/profile_repo.dart';

class ProfileController extends GetxController {
  final _profileRepo = Get.find<ProfileRepo>();
  final _videoStatusRepo = Get.find<VideoStatusRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<UserModel> userProfile = Rxn<UserModel>();
  final RxList<WatchHistoryModel> watchHistory = <WatchHistoryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getWatchHistory();
  }

  Future<void> refreshProfile() async {
    getProfile(isRefresh: true);
    getWatchHistory();
  }

  Future<void> getWatchHistory() async {
    final result = await _videoStatusRepo.getWatchHistory();
    result.fold(
      (failure) => null,
      (success) => watchHistory.assignAll(success.data),
    );
  }

  Future<void> getProfile({bool isRefresh = false}) async {
    return _profileRepo
        .getProfile(forceRefresh: isRefresh)
        .bind(rx: userProfile, loading: isLoading);
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    XFile? avatar,
  }) async {
    final multipartData = MultiFormDataManager();

    multipartData.addTextData('name', name ?? '');
    multipartData.addTextData('email', email ?? '');
    if (avatar != null) {
      multipartData.addFile(key: 'avatar', file: avatar);
    }

    final requestdata = await multipartData.toFormDataAsync();
    try {
      await _profileRepo
          .updateProfile(formData: requestdata)
          .asStream()
          .bind(rx: userProfile, loading: isLoading);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await _authStorageService.clearAuthData();
    Get.offAll(() => const LoginScreen());
  }
}
