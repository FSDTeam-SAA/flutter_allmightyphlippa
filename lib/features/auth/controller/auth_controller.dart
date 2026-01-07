import 'package:flutter_almightyflippa/features/auth/models/login_request_model.dart';
import 'package:flutx_core/flutx_core.dart';

import '/features/auth/repo/auth_repo.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final _authRepo = Get.find<AuthRepo>();

  Future<void> login() async {
    final request = LoginRequestModel(
      email: "noyonbdc787@mgil.com",
      password: '123456',
    );
    final result = await _authRepo.login(request);

    result.fold(
      (fail) {
        DPrint.log("Login Fail : ${fail.message}");
      },
      (success) {
        DPrint.log("Login success : ${success.message}");
      },
    );
  }
}
