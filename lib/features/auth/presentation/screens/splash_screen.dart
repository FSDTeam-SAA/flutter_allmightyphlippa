import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_screen_controller.dart';
import '../../../../core/common/constants/app_images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Center(
        child: Image.asset(
          AppImages.logo,
          width: 120, // Adjust size as needed
          height: 120,
        ),
      ),
    );
  }
}
