import 'package:flutter/material.dart';
import 'package:flutter_almightyflippa/core/common/widgets/app_scaffold.dart';
import 'package:flutter_almightyflippa/core/common/widgets/button_widgets.dart';
import 'package:flutter_almightyflippa/core/constants/assest_const.dart'
    hide Icons;
import 'package:flutter_almightyflippa/features/auth/controller/auth_controller.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

// Assuming these exist based on context
import '../../../core/common/widgets/app_logo.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/input_decoration_extensions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.put(AuthController());

    return AppScaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap(h: 60),
                      AppLogo(height: 80, images: AssetsConstants.images.logo),
                      Gap.h40,
                      Text(
                        "Login To Your Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      Gap.h12,

                      TextFormField(
                        controller: authCtrl.emailController,
                        focusNode: authCtrl.emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryWhite,
                        ),
                        decoration: context.primaryInputDecoration.copyWith(
                          hintText: "Email",
                        ),
                        // validator: Validators.email,
                        onFieldSubmitted: (_) => FocusScope.of(
                          context,
                        ).requestFocus(authCtrl.passwordFocus),
                        autofillHints: const [AutofillHints.email],
                      ),
                      Gap.h24,

                      "Password".text16w400().align(Alignment.topLeft),
                      Gap(h: 8),
                      Obx(
                        () => TextFormField(
                          controller: authCtrl.passwordController,
                          focusNode: authCtrl.passwordFocus,
                          obscureText: authCtrl.obscurePassword.value,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(color: AppColors.primaryBlack),
                          decoration: context.primaryInputDecoration.copyWith(
                            hintText: "Enter your Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                authCtrl.obscurePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.primaryGray,
                              ),
                              onPressed: () => authCtrl.toggleObscurePassword(),
                            ),
                          ),
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) => authCtrl.login(),
                        ),
                      ),
                      Gap.h12,

                      Obx(
                        () => authCtrl.loginErrorMessage.value.isNotEmpty
                            ? Center(
                                child: Text(
                                  authCtrl.loginErrorMessage.value,
                                  style: TextStyle(color: AppColors.red),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),

                      Gap.h12,

                      Gap.h24,

                      Row(
                        children: [
                          Obx(
                            () => Checkbox(
                              value: authCtrl.rememberMe.value,
                              activeColor: Colors.white,
                              checkColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: WidgetStateBorderSide.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return BorderSide(
                                    color: Color(0xFF1753FF),
                                    width: 2,
                                  );
                                }
                                return BorderSide(
                                  color: Color(0xFF1753FF),
                                  width: 1,
                                );
                              }),
                              onChanged: (_) => authCtrl.toggleRememberMe(),
                            ),
                          ),
                          Text("Remember me", style: TextStyle(fontSize: 14)),
                          Spacer(),
                          // TextButton(
                          //   onPressed: () {
                          //     Get.to(
                          //       () => ForgotPasswordScreen(
                          //         email: authCtrl.emailController.text,
                          //       ),
                          //     );
                          //   },
                          //   child: Text('Forgot password?'),
                          // ),
                        ],
                      ),
                      Gap.h24,

                      SecondaryButton(
                        onApiPressed: () => authCtrl.signInWithGoogle(),
                        iconLeft: Image.asset(
                          'assets/images/google.png',
                          height: 24,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.g_mobiledata),
                        ),
                        text: 'Continue with Google',
                        backgroundColor: Colors.white,
                      ),
                      Gap.h24,
                      SecondaryButton(
                        // onApiPressed: () {
                        //   // TODO: Apple Sign In
                        // },
                        iconLeft: Image.asset(
                          'assets/images/apple.png',
                          height: 24,
                          width: 24,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.apple),
                        ),
                        text: 'Continue with Apple',
                        backgroundColor: Colors.white,
                      ),
                      Gap.h40,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
