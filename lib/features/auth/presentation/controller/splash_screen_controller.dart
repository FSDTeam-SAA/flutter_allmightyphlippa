import 'package:get/get.dart';
import '../screens/welcome_screen.dart';


class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 1));
    Get.offAll(() => const WelcomeScreen());
  }
}
