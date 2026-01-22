import 'package:flutter_almightyflippa/features/series/models/series_response_model.dart';
import 'package:flutter_almightyflippa/features/series/repositories/series_repo.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';

import '../models/single_series_response_model.dart';

class SeriesController extends GetxController {
  final _seriesRepo = Get.find<SeriesRepo>();

  final series = <SeriesResponesModel>[].obs;
  final singleSeries = Rxn<SingleSeriesResponseModel>();

  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final hasMore = true.obs;
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void onInit() {
    super.onInit();
    getSeries();
  }

  Future<void> getSeries({bool isLoadMore = false}) async {
    if (isLoading.value || isMoreLoading.value) return;
    if (isLoadMore && !hasMore.value) return;

    if (isLoadMore) {
      isMoreLoading.value = true;
    } else {
      isLoading.value = true;
      _currentPage = 1;
      hasMore.value = true;
    }

    final response = await _seriesRepo.getSeries(
      page: _currentPage,
      limit: _limit,
    );

    response.fold(
      (fail) {
        DPrint.error('Error fetching movies: ${fail.message}');
      },
      (success) {
        final data = success.data;

        if (data.length < _limit) {
          hasMore.value = false;
        }
        if (isLoadMore) {
          series.addAll(data);
        } else {
          series.assignAll(data);
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

  Future<void> getSeriesDetails({required int streamId}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    final response = await _seriesRepo.getSeriesDetails(streamId: streamId);

    response.fold(
      (fail) {
        DPrint.error('Error fetching series details: ${fail.message}');
      },
      (success) {
        final data = success.data;
        singleSeries.value = data;
      },
    );

    isLoading.value = false;
  }
}
