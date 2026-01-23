import 'package:flutter/material.dart';
import 'package:flutter_almightyflippa/features/playlist/models/server_request_model.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '/core/constants/app_colors.dart';
import 'package:get/get.dart';

import '../controllers/video_play_controller.dart';

class VideoPlayScreen extends StatefulWidget {
  final int streamId;
  final ServerType type;
  const VideoPlayScreen({
    super.key,
    required this.streamId,
    required this.type,
  });

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  final controller = Get.put(VideoPlayController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeVideo(type: widget.type, streamId: widget.streamId);
    });
  }

  @override
  void dispose() {
    // Controller is disposed by GetX when screen is closed if we used Get.put
    // But since we want to be sure it cleans up, the controller's onClose handles it.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.red),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player Header
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      color: Colors.black,

                      child: controller.isVideoInitialized.value
                          ? Video(controller: controller.videoController)
                          : const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.red,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: BackButton(color: Colors.white),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        // TODO: Settings
                      },
                    ),
                  ),
                ],
              ),

              // Title and Info
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.subTitle,
                        style: const TextStyle(
                          color: AppColors.primaryGray,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.description,
                        style: const TextStyle(
                          color: AppColors.primaryGray,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          // Toggle expand description if needed
                        },
                        child: const Text(
                          'See More',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                      Center(
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                            ),
                            const Text(
                              "Favourite",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
