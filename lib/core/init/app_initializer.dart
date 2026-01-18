import 'package:flutter/widgets.dart';
import 'package:flutx_core/flutx_core.dart';

import '../services/hive_storage_service.dart';
import '../di/service_locator.dart';

class AppInitializer {
  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Limit total image cache
    PaintingBinding.instance.imageCache.maximumSize = 100; // 100 images
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20; // 100 MB

    // Allow all orientations at app start
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    await HiveStorageService.init();
    try {
    await setupServiceLocator();
      DPrint.log("Service Locator Setup Completed");
    } catch (err) {
      DPrint.log("Error in Service Locator Setup: $err");
    }


    // SocketClient().connect();
    // Wait for connection
    // SocketClient().onReady;
  }
}
