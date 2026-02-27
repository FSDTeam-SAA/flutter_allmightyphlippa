import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/live_video_play_controller.dart';
import 'package:floating/floating.dart';

class LiveVideoPlayScreen extends StatefulWidget {
  final int streamId;
  final String channelName;

  const LiveVideoPlayScreen({
    super.key,
    required this.streamId,
    required this.channelName,
  });

  @override
  State<LiveVideoPlayScreen> createState() => _LiveVideoPlayScreenState();
}

class _LiveVideoPlayScreenState extends State<LiveVideoPlayScreen>
    with WidgetsBindingObserver {
  final controller = Get.put(LiveVideoPlayController());

  late Floating pip;
  bool isPipAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pip = Floating();
    _checkPipAvailability();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeLiveVideo(streamId: widget.streamId);
    });
  }

  Future<void> _checkPipAvailability() async {
    isPipAvailable = await pip.isPipAvailable;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden &&
        isPipAvailable &&
        controller.isVideoInitialized.value) {
      pip.enable(const ImmediatePiP(aspectRatio: Rational.landscape()));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<LiveVideoPlayController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PiPSwitcher(
      childWhenDisabled: Scaffold(
        backgroundColor: AppColors.primaryBlack,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title: Text(
            widget.channelName,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.picture_in_picture_alt,
                color: Colors.white,
              ),
              onPressed: () {
                if (isPipAvailable) {
                  pip.enable(
                    const ImmediatePiP(aspectRatio: Rational.landscape()),
                  );
                } else {
                  Get.snackbar('Error', 'PiP is not available on this device');
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.red),
                  SizedBox(height: 16),
                  Text(
                    'Fetching Stream...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              );
            }

            if (controller.isVideoInitialized.value &&
                controller.chewieController != null) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: Chewie(controller: controller.chewieController!),
              );
            }

            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 48),
                SizedBox(height: 16),
                Text(
                  'Failed to load stream',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            );
          }),
        ),
      ),
      childWhenEnabled: Obx(() {
        return controller.isVideoInitialized.value &&
                controller.chewieController != null
            ? AspectRatio(
                aspectRatio: 16 / 9,
                child: Chewie(controller: controller.chewieController!),
              )
            : const Center(
                child: CircularProgressIndicator(color: AppColors.red),
              );
      }),
    );
  }
}
