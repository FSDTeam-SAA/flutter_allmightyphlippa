import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/common/constants/app_images.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final double largeRadius = 56;
    final double mediumRadius = 48;
    final double smallRadius = 44;

    Widget avatar(String name, double radius) {
      return Column(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: AssetImage(AppImages.appLogoLandscape),
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      );
    }

    return AppScaffold(
      removePadding: false,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Who's Watching",
                style: TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 28),
        
            // Profiles area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top centered profile
                    avatar('Josh', largeRadius),
                    const SizedBox(height: 36),
        
                    // Row of three
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        avatar('Amelia', mediumRadius),
                        avatar('Jacob', mediumRadius),
                        avatar('Sandy', mediumRadius),
                      ],
                    ),
        
                    const SizedBox(height: 36),
        
                    // Bottom center profile
                    avatar('Mike', smallRadius),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
        
            // Next button
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                height: 64,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButtonColor,
                    foregroundColor: AppColors.primaryButtonText,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  ),
                  onPressed: () {
                    Get.offAll(() => const LoginScreen());
                  },
                  child: const Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
