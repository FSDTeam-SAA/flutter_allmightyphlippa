import '/core/api/network_result.dart';
import '/features/auth/models/login_request_model.dart';

abstract class AuthRepo {
  NetworkResult<void> login(LoginRequestModel request);
}
