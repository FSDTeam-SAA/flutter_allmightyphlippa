// import 'package:flutter/material.dart';
// import 'package:flutx_core/core/theme/gap.dart';
// import 'package:flutx_core/core/validation/validators.dart';
// import 'package:get/get.dart';

// import '../../../../core/common/widgets/app_scaffold.dart';
// import '../../../../core/constants/app_colors.dart';

// import 'otp_verification_to_complete_register.dart';
// import 'login_screen.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});

//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FocusNode _emailFocus = FocusNode();
//   final TextEditingController _emailController = TextEditingController();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _emailFocus.dispose();
//     super.dispose();
//   }

//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     if (mounted) FocusScope.of(context).unfocus();
//     if (mounted) FocusScope.of(context).unfocus();
//     Get.to(() => OtpVerificationToCompleteRegister(email: _emailController.text));
//   }

//   @override
//     Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: AppScaffold(
//         backgroundColor: AppColors.scaffoldBackground, // Dark background
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 20),
//                     IconButton(
//                       icon: Icon(Icons.arrow_back_ios, color: AppColors.white, size: 20),
//                       onPressed: () => Get.back(),
//                     ),
//                     SizedBox(height: 60),
                    
//                     Text(
//                       'Forgot Password',
//                       style: TextStyle(
//                         fontSize: 24, 
//                         fontWeight: FontWeight.w700, 
//                         color: AppColors.white
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     Text(
//                       'Enter your email to receive the verification code',
//                       style: TextStyle(
//                         fontSize: 14, 
//                         fontWeight: FontWeight.w400, 
//                         color: AppColors.secondaryText,
//                         height: 1.5,
//                       ),
//                     ),
                    
//                     SizedBox(height: 40),
                    
//                     TextFormField(
//                       controller: _emailController,
//                       focusNode: _emailFocus,
//                       keyboardType: TextInputType.emailAddress,
//                       textInputAction: TextInputAction.done,
//                       style: TextStyle(fontSize: 16, color: AppColors.white),
//                       cursorColor: AppColors.white,
//                       decoration: InputDecoration(
//                         hintText: "Email",
//                         hintStyle: TextStyle(color: AppColors.hintText),
//                         filled: true,
//                         fillColor: Colors.transparent,
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: AppColors.inputBorder),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: AppColors.white),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: AppColors.error),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(color: AppColors.error),
//                         ),
//                       ),
//                       validator: Validators.email,
//                       onFieldSubmitted: (_) => _submit(),
//                       autofillHints: const [AutofillHints.email],
//                     ),
                    
//                     Gap.h16,
//                     SizedBox(height: 16),
                    
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: _submit,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primaryButtonColor,
//                           foregroundColor: AppColors.primaryButtonText,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: Text(
//                           "Submit",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
                    
//                     SizedBox(height: 40),
//                     Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Remembered password? ", style: TextStyle(color: AppColors.secondaryText, fontSize: 14)),
//                           GestureDetector(
//                             onTap: () => Get.to(() => LoginScreen()),
//                             child: Text('Sign in', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 14)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
