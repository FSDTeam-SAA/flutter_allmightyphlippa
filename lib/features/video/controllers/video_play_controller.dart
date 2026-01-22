import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_almightyflippa/features/playlist/models/server_request_model.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../movie/controllers/movie_controller.dart';
import '../../series/controllers/series_controller.dart';

class VideoPlayController extends GetxController {
  MovieController get movieCtrl => Get.find<MovieController>();
  SeriesController get seriesCtrl => Get.find<SeriesController>();

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  final isVideoInitialized = false.obs;

  final currentType = Rxn<ServerType>();
  final isLoading = false.obs;

  String get title {
    if (currentType.value == ServerType.movies) {
      return movieCtrl.movie.value?.streamData.info.name ?? '';
    } else if (currentType.value == ServerType.series) {
      return seriesCtrl.singleSeries.value?.data?.info?.name ?? '';
    }
    return '';
  }

  String get subTitle {
    if (currentType.value == ServerType.movies) {
      final movie = movieCtrl.movie.value;
      if (movie == null) return '';
      return '${movie.streamData.movieData.added} | Movie | ${movie.streamData.info.duration}';
    } else if (currentType.value == ServerType.series) {
      final series = seriesCtrl.singleSeries.value;
      if (series == null) return '';
      // You might want to show Season/Episode info specifically here if available,
      // but for general series info:
      return '${series.data?.info?.releaseDate ?? ''} | Series | ${series.data?.info?.rating ?? ''}/10';
    }
    return '';
  }

  String get description {
    if (currentType.value == ServerType.movies) {
      final movie = movieCtrl.movie.value;
      if (movie == null) return '';
      return movie.streamData.info.description.isNotEmpty
          ? movie.streamData.info.description
          : (movie.streamData.info.plot.isNotEmpty
                ? movie.streamData.info.plot
                : 'No description available');
    } else if (currentType.value == ServerType.series) {
      final series = seriesCtrl.singleSeries.value;
      if (series == null) return '';
      return series.data?.info?.plot ?? 'No description available';
    }
    return '';
  }

  @override
  void onClose() {
    _disposeVideoControllers();
    super.onClose();
  }

  Future<void> initializeVideo({
    required ServerType type,
    required int streamId,
  }) async {
    // Reset previous state
    isVideoInitialized.value = false;
    isLoading.value = true;
    currentType.value = type;
    _disposeVideoControllers();

    try {
      if (type == ServerType.movies) {
        await _loadMovie(streamId);
      } else if (type == ServerType.series) {
        await _loadSeries(streamId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMovie(int streamId) async {
    // Fetch details
    await movieCtrl.getMovieDetails(streamId: streamId);

    // Initialize video if URL is available
    final movie = movieCtrl.movie.value;
    if (movie != null && movie.playUrl.isNotEmpty) {
      await _initializePlayer(movie.playUrl);
    }
  }

  Future<void> _loadSeries(int streamId) async {
    // Fetch details
    await seriesCtrl.getSeriesDetails(streamId: streamId);

    // Initialize video if URL is available
    final series = seriesCtrl.singleSeries.value;
    if (series != null && series.playUrl!.isNotEmpty) {
      await _initializePlayer(series.playUrl!);
    }
  }

  Future<void> _initializePlayer(String videoUrl) async {
    try {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );
      await videoPlayerController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: videoPlayerController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );

      isVideoInitialized.value = true;
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      Get.snackbar('Error', 'Failed to load video');
    }
  }

  void _disposeVideoControllers() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    videoPlayerController = null;
    chewieController = null;
  }
}
