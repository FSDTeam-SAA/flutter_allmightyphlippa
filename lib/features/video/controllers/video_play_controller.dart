import 'package:flutter/material.dart';
import 'package:flutter_almightyflippa/features/playlist/models/server_request_model.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'dart:async';
import '../../movie/controllers/movie_controller.dart';
import '../../series/controllers/series_controller.dart';
import '../../series/models/single_series_response_model.dart';
import '../../../core/services/auth_storage_service.dart';
import '../repositories/video_status_repo.dart';
import '../models/video_status_request_model.dart';

class VideoPlayController extends GetxController {
  MovieController get movieCtrl => Get.find<MovieController>();
  SeriesController get seriesCtrl => Get.find<SeriesController>();
  VideoStatusRepo get videoStatusRepo => Get.find<VideoStatusRepo>();

  late final Player player;
  late final VideoController videoController;

  final isVideoInitialized = false.obs;
  final currentType = Rxn<ServerType>();
  final isLoading = false.obs;

  // Track the current episode for series
  final currentEpisode = Rxn<Episode>();
  final isLoved = false.obs;

  StreamSubscription? _positionSubscription;
  Duration _lastUpdatePosition = Duration.zero;
  final _updateInterval = const Duration(seconds: 10);
  String? _currentVideoId;
  String? _currentVideoType;

  @override
  void onInit() {
    super.onInit();
    player = Player();
    videoController = VideoController(player);
  }

  String get title {
    if (currentType.value == ServerType.movies) {
      return movieCtrl.movie.value?.streamData.info.name ?? '';
    } else if (currentType.value == ServerType.series) {
      if (currentEpisode.value != null) {
        return currentEpisode.value!.title ??
            'Episode ${currentEpisode.value!.episodeNum}';
      }
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
      if (currentEpisode.value != null) {
        return 'S${currentEpisode.value!.season} E${currentEpisode.value!.episodeNum} | ${currentEpisode.value!.info?.duration ?? ''}';
      }
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
    _positionSubscription?.cancel();
    _syncVideoStatus(); // Sync one last time
    player.dispose();
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
    currentEpisode.value = null;

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
      _currentVideoId = streamId.toString();
      _currentVideoType = 'movie';
      await _initializePlayer(movie.playUrl);
    }
  }

  Future<void> _loadSeries(int streamId) async {
    // Fetch details
    await seriesCtrl.getSeriesDetails(streamId: streamId);

    final series = seriesCtrl.singleSeries.value;
    if (series != null) {
      // Find the first available episode
      final episodesMap = series.data?.episodes;
      if (episodesMap != null && episodesMap.isNotEmpty) {
        final firstSeasonKey = episodesMap.keys.first;
        final firstSeasonEpisodes = episodesMap[firstSeasonKey];
        if (firstSeasonEpisodes != null && firstSeasonEpisodes.isNotEmpty) {
          playEpisode(firstSeasonEpisodes.first);
        }
      }
    }
  }

  Future<void> playEpisode(Episode episode) async {
    currentEpisode.value = episode;
    isVideoInitialized.value = false;

    try {
      final storage = AuthStorageService();
      final playlistData = await storage.getPlaylistData();
      final urlObject = Uri.parse(playlistData.url);
      final host = urlObject.host;
      final port = urlObject.port == 0 ? 80 : urlObject.port;
      final fileExt = episode.containerExtension ?? 'mkv';

      // Reconstruct play URL for the specific episode
      // http://${host}:${port}/series/${username}/${password}/${episodeId}.${fileExt}
      // Reconstruct play URL for the specific episode
      // http://${host}:${port}/series/${username}/${password}/${episodeId}.${fileExt}
      final playUrl =
          'http://$host:$port/series/${playlistData.username}/${playlistData.password}/${episode.id}.$fileExt';

      _currentVideoId = episode.id.toString();
      _currentVideoType = 'series';
      await _initializePlayer(playUrl);
    } catch (e) {
      debugPrint('Error playing episode: $e');
      Get.snackbar('Error', 'Failed to play episode');
    }
  }

  Future<void> _initializePlayer(String videoUrl) async {
    try {
      // 1. Fetch resume position if we have video info
      Duration startPosition = Duration.zero;
      if (_currentVideoId != null) {
        final result = await videoStatusRepo.getVideoStatus(_currentVideoId!);
        if (result.isRight()) {
          final statusSuccess = result.getOrElse(() => throw Exception());
          final status = statusSuccess.data;

          isLoved.value = status.isLoved;

          if (!status.isCompleted && status.currentTime > 0) {
            startPosition = Duration(seconds: status.currentTime.toInt());
          }
        }
      }

      // 2. Open Player
      await player.open(Media(videoUrl), play: false);
      if (startPosition > Duration.zero) {
        await player.seek(startPosition);
      }
      await player.play();

      isVideoInitialized.value = true;
      _startPositionListener();
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      Get.snackbar('Error', 'Failed to load video');
    }
  }

  Future<void> toggleFavorite() async {
    if (_currentVideoId == null || _currentVideoType == null) return;

    final result = await videoStatusRepo.updateVideoStatus(
      UpdateVideoStatusRequest(
        title: title,
        videoId: _currentVideoId!,
        videoType: _currentVideoType!,
        isLoved: !isLoved.value,
      ),
    );
    if (result.isRight()) {
      isLoved.value = !isLoved.value;
    }
  }

  void _startPositionListener() {
    _positionSubscription?.cancel();
    _positionSubscription = player.stream.position.listen((position) {
      if ((position - _lastUpdatePosition).abs() > _updateInterval) {
        _syncVideoStatus();
        _lastUpdatePosition = position;
      }
    });
  }

  Future<void> _syncVideoStatus() async {
    if (_currentVideoId == null || _currentVideoType == null) return;

    final position = player.state.position;
    final duration = player.state.duration;

    if (duration == Duration.zero) return;

    await videoStatusRepo.updateVideoStatus(
      UpdateVideoStatusRequest(
        title: title,
        videoId: _currentVideoId!,
        videoType: _currentVideoType!,
        currentTime: position.inSeconds.toDouble(),
        duration: duration.inSeconds.toDouble(),
        seasonNumber: currentEpisode.value?.season,
        episodeNumber: currentEpisode.value?.episodeNum,
        thumbnail: _getThumbnail(),
      ),
    );
  }

  String? _getThumbnail() {
    if (_currentVideoType == 'movie') {
      return movieCtrl.movie.value?.streamData.info.movieImage;
    } else if (_currentVideoType == 'series') {
      return seriesCtrl.singleSeries.value?.data?.info?.cover;
    }
    return null;
  }
}
