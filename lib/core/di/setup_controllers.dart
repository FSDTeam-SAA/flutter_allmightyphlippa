import 'package:flutter_almightyflippa/core/utils/getx_helper.dart';
import 'package:flutter_almightyflippa/features/movie/controllers/movie_controller.dart';
import 'package:flutter_almightyflippa/features/series/controllers/series_controller.dart';
import 'package:get/get.dart';

Future<void> setupControllers() async {
  Get.getOrPutLazy(() => MovieController(), fenix: true);
  Get.getOrPutLazy(() => SeriesController(), fenix: true);
}
