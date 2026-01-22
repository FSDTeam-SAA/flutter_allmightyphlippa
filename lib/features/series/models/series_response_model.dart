class SeriesResponesModel {
  final int? num;
  final String? name;
  final int? seriesId;
  final String cover;
  final String? plot;
  final String? cast; // raw comma-separated string
  final List<String>? castList; // parsed list for easier use
  final String? director; // raw comma-separated string
  final List<String>? directorList; // parsed list
  final String? genre; // raw string with / separators
  final List<String>? genreList; // parsed list
  final String?
  releaseDate; // prefers 'releaseDate', falls back to 'release_date', treats empty as null
  final int? lastModified; // unix timestamp as int
  final int? rating; // e.g., 6 or 7 (out of 10)
  final double? rating5Based; // e.g., 3.0 or 3.5
  final List<String>? backdropPath;
  final String? youtubeTrailer;
  final String? tmdb;
  final int? episodeRunTime; // in minutes
  final int? categoryId;
  final List<int>? categoryIds;

  SeriesResponesModel({
    this.num,
    this.name,
    this.seriesId,
    required this.cover,
    this.plot,
    this.cast,
    this.castList,
    this.director,
    this.directorList,
    this.genre,
    this.genreList,
    this.releaseDate,
    this.lastModified,
    this.rating,
    this.rating5Based,
    this.backdropPath,
    this.youtubeTrailer,
    this.tmdb,
    this.episodeRunTime,
    this.categoryId,
    this.categoryIds,
  });

  factory SeriesResponesModel.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse int (handles string, int, or null)
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    // Helper to safely parse double (handles string, int, double, or null)
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    // Raw strings
    final String? rawCast = json['cast'] as String?;
    final String? rawDirector = json['director'] as String?;
    final String? rawGenre = json['genre'] as String?;

    // Release date handling (both keys exist, treat empty string as null)
    String? rawReleaseDate =
        json['releaseDate'] as String? ?? json['release_date'] as String?;
    if (rawReleaseDate != null && rawReleaseDate.isEmpty) {
      rawReleaseDate = null;
    }

    return SeriesResponesModel(
      num: parseInt(json['num']),
      name: json['name'] as String?,
      seriesId: parseInt(json['series_id']),
      cover: json['cover'],
      plot: json['plot'] as String?,
      cast: rawCast,
      castList: rawCast?.split(', ').map((e) => e.trim()).toList(),
      director: rawDirector,
      directorList: rawDirector?.split(', ').map((e) => e.trim()).toList(),
      genre: rawGenre,
      genreList: rawGenre?.split(' / ').toList(),
      releaseDate: rawReleaseDate,
      lastModified: parseInt(json['last_modified']),
      rating: parseInt(json['rating']),
      rating5Based: parseDouble(json['rating_5based']),
      backdropPath: (json['backdrop_path'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      youtubeTrailer: json['youtube_trailer'] as String?,
      tmdb: json['tmdb'] as String?,
      episodeRunTime: parseInt(json['episode_run_time']),
      categoryId: parseInt(json['category_id']),
      categoryIds: (json['category_ids'] as List<dynamic>?)
          ?.map((e) => parseInt(e) ?? 0)
          .toList(),
    );
  }

  // Optional: toJson if needed
  Map<String, dynamic> toJson() {
    return {
      'num': num,
      'name': name,
      'series_id': seriesId,
      'cover': cover,
      'plot': plot,
      'cast': cast,
      'director': director,
      'genre': genre,
      'releaseDate': releaseDate,
      'last_modified': lastModified,
      'rating': rating,
      'rating_5based': rating5Based,
      'backdrop_path': backdropPath,
      'youtube_trailer': youtubeTrailer,
      'tmdb': tmdb,
      'episode_run_time': episodeRunTime,
      'category_id': categoryId,
      'category_ids': categoryIds,
    };
  }
}
