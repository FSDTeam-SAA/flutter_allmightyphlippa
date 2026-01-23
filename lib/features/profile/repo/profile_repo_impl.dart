import '../../../core/api/api_client.dart';
import '../../../core/api/network_stream.dart';
import '../../../core/constants/api_constants.dart';
import '../../auth/models/user_response_model.dart';
import 'profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ApiClient apiClient;

  ProfileRepoImpl({required this.apiClient});

  @override
  NetworkStream<UserModel> getProfile() {
    return apiClient.getStream<UserModel>(
      endpoint: ApiConstants.user.profile,
      cacheDuration: const Duration(days: 30),
      fromJsonT: (json) => UserModel.fromJson(json),
    );
  }
}
