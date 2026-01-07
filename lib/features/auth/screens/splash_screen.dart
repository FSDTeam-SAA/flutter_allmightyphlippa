import 'package:flutter/material.dart';
import '../../../core/constants/assest_const.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    // Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Center(
        child: Image.asset(
          AssetsConstants.images.logo,
          width: 120, // Adjust size as needed
          height: 120,
        ),
      ),
    );
  }
}
