import 'package:get/get.dart';

import '../../../core/di/setup_controllers.dart';

class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    await setupControllers();
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
