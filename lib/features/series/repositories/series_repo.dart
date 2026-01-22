import 'package:flutter_almightyflippa/core/api/network_result.dart';
import 'package:flutter_almightyflippa/features/series/models/series_response_model.dart';
import 'package:flutter_almightyflippa/features/series/models/single_series_response_model.dart';

abstract class SeriesRepo {
  NetworkResult<List<SeriesResponesModel>> getSeries({
    required int page,
    required int limit,
  });

  NetworkResult<SingleSeriesResponseModel> getSeriesDetails({
    required int streamId,
  });
}
