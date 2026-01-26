import 'package:flutter_almightyflippa/core/api/api_client.dart';
import 'package:flutter_almightyflippa/core/api/network_result.dart';
import 'package:flutter_almightyflippa/core/constants/api_constants.dart';
import 'package:flutter_almightyflippa/features/video/models/video_status_model.dart';
import 'package:flutter_almightyflippa/features/video/models/video_status_request_model.dart';
import 'package:flutter_almightyflippa/features/video/models/watch_history_model.dart';
import 'package:flutter_almightyflippa/features/video/repositories/video_status_repo.dart';

class VideoStatusRepoImpl implements VideoStatusRepo {
  final ApiClient _apiClient;

  VideoStatusRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<List<WatchHistoryModel>> getFavorites({
    int page = 1,
    int limit = 10,
  }) {
    return _apiClient.get(
      endpoint: ApiConstants.video.getFavorites,
      queryParameters: {'page': page, 'limit': limit},
      fromJsonT: (json) => (json['favorites'] as List)
          .map((e) => WatchHistoryModel.fromJson(e))
          .toList(),
    );
  }

  @override
  NetworkResult<VideoStatusModel> getVideoStatus(String videoId) {
    return _apiClient.get(
      endpoint: '${ApiConstants.video.getVideoStatus}/$videoId',
      fromJsonT: (json) => VideoStatusModel.fromJson(json),
    );
  }

  @override
  NetworkResult<List<WatchHistoryModel>> getWatchHistory({
    int page = 1,
    int limit = 10,
  }) {
    return _apiClient.get(
      endpoint: ApiConstants.video.getWatchHistory,
      queryParameters: {'page': page, 'limit': limit},
      fromJsonT: (json) => (json['history'] as List)
          .map((e) => WatchHistoryModel.fromJson(e))
          .toList(),
    );
  }

  @override
  NetworkResult<WatchHistoryModel> updateVideoStatus(
    UpdateVideoStatusRequest request,
  ) {
    return _apiClient.post(
      endpoint: ApiConstants.video.updateVideoStatus,
      data: request.toJson(),
      fromJsonT: (json) => WatchHistoryModel.fromJson(json),
      // Invalidate relevant caches
      invalidatePaths: [
        ApiConstants.video.getWatchHistory,
        ApiConstants.video.getFavorites,
        '${ApiConstants.video.getVideoStatus}/${request.videoId}',
      ],
    );
  }
}
