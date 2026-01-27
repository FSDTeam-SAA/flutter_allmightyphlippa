import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../video/models/watch_history_model.dart';
import '../../video/repositories/video_status_repo.dart';

class HistoryController extends GetxController {
  final _videoStatusRepo = Get.find<VideoStatusRepo>();

  final history = <WatchHistoryModel>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final hasMore = true.obs;
  int _currentPage = 1;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    getHistory();
  }

  Future<void> getHistory({bool isLoadMore = false}) async {
    if (isLoading.value || isMoreLoading.value) return;
    if (isLoadMore && !hasMore.value) return;

    if (isLoadMore) {
      isMoreLoading.value = true;
    } else {
      isLoading.value = true;
      _currentPage = 1;
      hasMore.value = true;
    }

    final result = await _videoStatusRepo.getWatchHistory(
      page: _currentPage,
      limit: _limit,
    );

    result.fold(
      (fail) {
        // Handle error if needed
      },
      (success) {
        final data = success.data;
        if (data.length < _limit) {
          hasMore.value = false;
        }

        if (isLoadMore) {
          history.addAll(data);
        } else {
          history.assignAll(data);
        }
        _currentPage++;
      },
    );

    if (isLoadMore) {
      isMoreLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }

  Map<String, List<WatchHistoryModel>> get groupedHistory {
    final grouped = <String, List<WatchHistoryModel>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var item in history) {
      if (item.lastWatchedAt == null) continue;

      final date = item.lastWatchedAt!;
      final dateOnly = DateTime(date.year, date.month, date.day);
      String key;

      if (dateOnly == today) {
        key = 'Today';
      } else if (dateOnly == yesterday) {
        key = 'Yesterday';
      } else {
        key = DateFormat('d MMM').format(date);
      }

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(item);
    }
    return grouped;
  }
}
