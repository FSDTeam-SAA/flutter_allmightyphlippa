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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeVideo(type: widget.type, streamId: widget.streamId);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (controller.currentType.value == ServerType.movies) {
        controller.movieCtrl.getMovies(isLoadMore: true);
      } else if (controller.currentType.value == ServerType.series) {
        controller.seriesCtrl.getSeries(isLoadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Explicitly delete the controller to ensure player is disposed and video stops.
    Get.delete<VideoPlayController>();
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

          // Access reactive data here to ensure this Obx rebuilds when lists change
          final movies = controller.movieCtrl.movies;
          final series = controller.seriesCtrl.series;
          final singleSeries = controller.seriesCtrl.singleSeries.value;

          return Column(
            children: [
              // Fixed Video Player
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                      child: controller.isVideoInitialized.value
                          ? Video(controller: controller.videoController)
                          : const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.red,
                              ),
                            ),
                    ),
                    const Positioned(
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
              ),

              // Scrollable Content
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
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
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    Text(
                                      "Favourite",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Related List or Episodes
                    if (controller.currentType.value == ServerType.movies)
                      _buildMovieList(context, movies)
                    else if (controller.currentType.value ==
                        ServerType.series) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'Episodes',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.primaryWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      _buildEpisodeList(context, singleSeries),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 16.0,
                          ),
                          child: Text(
                            'Other Series',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: AppColors.primaryWhite,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      _buildSeriesList(context, series),
                    ],

                    // Loading Indicator for Pagination
                    SliverToBoxAdapter(
                      child: Obx(() {
                        final isMoreLoading =
                            controller.currentType.value == ServerType.movies
                            ? controller.movieCtrl.isMoreLoading.value
                            : controller.seriesCtrl.isMoreLoading.value;
                        if (isMoreLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.red,
                              ),
                            ),
                          );
                        }
                        return const SizedBox(height: 20);
                      }),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMovieList(BuildContext context, List<dynamic> movies) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final movie = movies[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              controller.initializeVideo(
                type: ServerType.movies,
                streamId: movie.streamId,
              );
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.containerBgColor,
                    borderRadius: BorderRadius.circular(8),
                    image: movie.streamIcon.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(movie.streamIcon),
                            fit: BoxFit.cover,
                            onError: (_, __) {},
                          )
                        : null,
                  ),
                  child: movie.streamIcon.isEmpty
                      ? const Icon(Icons.movie, color: AppColors.iconColor)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.name,
                        style: const TextStyle(
                          color: AppColors.primaryWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Movie | ${movie.added}',
                        style: const TextStyle(
                          color: AppColors.primaryGray,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }, childCount: movies.length),
    );
  }

  Widget _buildSeriesList(BuildContext context, List<dynamic> series) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = series[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              controller.initializeVideo(
                type: ServerType.series,
                streamId: item.seriesId!,
              );
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.containerBgColor,
                    borderRadius: BorderRadius.circular(8),
                    image: item.cover.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(item.cover),
                            fit: BoxFit.cover,
                            onError: (_, __) {},
                          )
                        : null,
                  ),
                  child: item.cover.isEmpty
                      ? const Icon(Icons.movie, color: AppColors.iconColor)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? "",
                        style: const TextStyle(
                          color: AppColors.primaryWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Series',
                        style: TextStyle(
                          color: AppColors.primaryGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }, childCount: series.length),
    );
  }

  Widget _buildEpisodeList(BuildContext context, dynamic singleSeries) {
    final episodesMap = singleSeries?.data?.episodes;
    if (episodesMap == null || episodesMap.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No episodes found",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final List<dynamic> allEpisodes = [];
    episodesMap.forEach((season, episodes) {
      allEpisodes.addAll(episodes);
    });

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final episode = allEpisodes[index];
        final isPlaying = controller.currentEpisode.value?.id == episode.id;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              controller.playEpisode(episode);
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isPlaying
                    ? AppColors.red.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isPlaying
                    ? Border.all(color: AppColors.red.withOpacity(0.5))
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.containerBgColor,
                      borderRadius: BorderRadius.circular(8),
                      image:
                          episode.info?.movieImage != null &&
                              episode.info!.movieImage!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(episode.info!.movieImage!),
                              fit: BoxFit.cover,
                              onError: (_, __) {},
                            )
                          : null,
                    ),
                    child:
                        episode.info?.movieImage == null ||
                            episode.info!.movieImage!.isEmpty
                        ? const Icon(
                            Icons.play_circle_outline,
                            color: AppColors.iconColor,
                          )
                        : isPlaying
                        ? const Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          episode.title ?? "Episode ${episode.episodeNum}",
                          style: TextStyle(
                            color: isPlaying
                                ? AppColors.red
                                : AppColors.primaryWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'S${episode.season} E${episode.episodeNum} | ${episode.info?.duration ?? ""}',
                          style: const TextStyle(
                            color: AppColors.primaryGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isPlaying)
                    const Icon(Icons.equalizer, color: AppColors.red, size: 20),
                ],
              ),
            ),
          ),
        );
      }, childCount: allEpisodes.length),
    );
  }
}
