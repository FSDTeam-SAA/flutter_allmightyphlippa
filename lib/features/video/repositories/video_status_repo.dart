import 'package:flutter_almightyflippa/core/api/network_result.dart';
import '../models/video_status_request_model.dart';
import '../models/video_status_model.dart';
import '../models/watch_history_model.dart';

abstract class VideoStatusRepo {
  NetworkResult<WatchHistoryModel> updateVideoStatus(
    UpdateVideoStatusRequest request,
  );

  NetworkResult<List<WatchHistoryModel>> getWatchHistory({
    int page = 1,
    int limit = 10,
  });
  NetworkResult<VideoStatusModel> getVideoStatus(String videoId);
  NetworkResult<List<WatchHistoryModel>> getFavorites({
    int page = 1,
    int limit = 10,
  });
}
