import 'package:flutter/material.dart';
import 'package:flutter_almightyflippa/core/common/widgets/app_scaffold.dart';
import 'package:flutter_almightyflippa/core/common/widgets/button_widgets.dart';
import 'package:flutter_almightyflippa/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.put(AuthController());

    return AppScaffold(
      body: Center(
        child: PrimaryButton(
          onApiPressed: () => authCtrl.login(),
          text: "Login",
        ),
      ),
    );
  }
}
