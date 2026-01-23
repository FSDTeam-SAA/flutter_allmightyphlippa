import '../../../core/api/network_stream.dart';
import '../../auth/models/user_response_model.dart';

abstract class ProfileRepo {
  NetworkStream<UserModel> getProfile();
}
