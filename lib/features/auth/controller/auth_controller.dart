import 'package:flutter/material.dart';
import 'package:flutter_almightyflippa/features/auth/models/login_request_model.dart';
import 'package:flutx_core/flutx_core.dart';
import '/features/auth/repo/auth_repo.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // TextControllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // FocusNodes
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  // States
  final RxBool isLoading = false.obs;
  final RxString loginErrorMessage = "".obs;
  final RxBool obscurePassword = true.obs;
  final RxBool rememberMe = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }

  // Inject AuthRepo
  final _authRepo = Get.find<AuthRepo>();

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    if (isLoading.value) return;

    loginErrorMessage.value = "";
    isLoading.value = true;

    final request = LoginRequestModel(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    final result = await _authRepo.login(request);

    result.fold(
      (fail) {
        isLoading.value = false;
        loginErrorMessage.value = fail.message;
        DPrint.log("Login Fail : ${fail.message}");
      },
      (success) {
        isLoading.value = false;
        DPrint.log("Login success : ${success.message}");
        // Navigation or further logic on success
      },
    );
  }

  Future<void> signInWithGoogle() async {
    // TODO: Implement Google Sign In
    DPrint.log("Google Sign In clicked");
  }
}
