

class SingleSeriesResponseModel {
  SeriesDataContent? data;
  String? playUrl;

  SingleSeriesResponseModel({this.data, this.playUrl});

  SingleSeriesResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? SeriesDataContent.fromJson(json['data'])
        : null;
    playUrl = json['playUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['playUrl'] = this.playUrl;
    return data;
  }
}

class SeriesDataContent {
  List<Season>? seasons;
  SeriesInfo? info;
  Map<String, List<Episode>>? episodes;

  SeriesDataContent({this.seasons, this.info, this.episodes});

  SeriesDataContent.fromJson(Map<String, dynamic> json) {
    if (json['seasons'] != null) {
      seasons = <Season>[];
      json['seasons'].forEach((v) {
        seasons!.add(Season.fromJson(v));
      });
    }
    info = json['info'] != null ? SeriesInfo.fromJson(json['info']) : null;
    if (json['episodes'] != null) {
      episodes = {};
      json['episodes'].forEach((key, value) {
        if (value != null) {
          episodes![key] = <Episode>[];
          value.forEach((v) {
            episodes![key]!.add(Episode.fromJson(v));
          });
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.seasons != null) {
      data['seasons'] = this.seasons!.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    if (this.episodes != null) {
      final Map<String, dynamic> episodesMap = {};
      this.episodes!.forEach((key, value) {
        episodesMap[key] = value.map((v) => v.toJson()).toList();
      });
      data['episodes'] = episodesMap;
    }
    return data;
  }
}

class Season {
  String? name;
  String? episodeCount;
  String? overview;
  String? airDate;
  String? cover;
  String? coverTmdb;
  int? seasonNumber;
  String? coverBig;
  String? releaseDate;
  String? duration;

  Season({
    this.name,
    this.episodeCount,
    this.overview,
    this.airDate,
    this.cover,
    this.coverTmdb,
    this.seasonNumber,
    this.coverBig,
    this.releaseDate,
    this.duration,
  });

  Season.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    episodeCount = json['episode_count'];
    overview = json['overview'];
    airDate = json['air_date'];
    cover = json['cover'];
    coverTmdb = json['cover_tmdb'];
    seasonNumber = json['season_number'];
    coverBig = json['cover_big'];
    releaseDate = json['releaseDate'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['episode_count'] = this.episodeCount;
    data['overview'] = this.overview;
    data['air_date'] = this.airDate;
    data['cover'] = this.cover;
    data['cover_tmdb'] = this.coverTmdb;
    data['season_number'] = this.seasonNumber;
    data['cover_big'] = this.coverBig;
    data['releaseDate'] = this.releaseDate;
    data['duration'] = this.duration;
    return data;
  }
}

class SeriesInfo {
  String? name;
  String? cover;
  String? plot;
  String? cast;
  String? director;
  String? genre;
  String? releaseDate;
  String? lastModified;
  String? rating;
  String? rating5based;
  List<String>? backdropPath;
  String? tmdb;
  String? youtubeTrailer;
  String? episodeRunTime;
  String? categoryId;
  List<int>? categoryIds;

  SeriesInfo({
    this.name,
    this.cover,
    this.plot,
    this.cast,
    this.director,
    this.genre,
    this.releaseDate,
    this.lastModified,
    this.rating,
    this.rating5based,
    this.backdropPath,
    this.tmdb,
    this.youtubeTrailer,
    this.episodeRunTime,
    this.categoryId,
    this.categoryIds,
  });

  SeriesInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cover = json['cover'];
    plot = json['plot'];
    cast = json['cast'];
    director = json['director'];
    genre = json['genre'];
    releaseDate = json['releaseDate'] ?? json['release_date'];
    lastModified = json['last_modified'];
    rating = json['rating'];
    rating5based = json['rating_5based'];
    if (json['backdrop_path'] != null) {
      backdropPath = List<String>.from(json['backdrop_path']);
    }
    tmdb = json['tmdb'];
    youtubeTrailer = json['youtube_trailer'];
    episodeRunTime = json['episode_run_time'];
    categoryId = json['category_id'];
    if (json['category_ids'] != null) {
      categoryIds = List<int>.from(json['category_ids']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['cover'] = this.cover;
    data['plot'] = this.plot;
    data['cast'] = this.cast;
    data['director'] = this.director;
    data['genre'] = this.genre;
    data['releaseDate'] = this.releaseDate;
    data['last_modified'] = this.lastModified;
    data['rating'] = this.rating;
    data['rating_5based'] = this.rating5based;
    data['backdrop_path'] = this.backdropPath;
    data['tmdb'] = this.tmdb;
    data['youtube_trailer'] = this.youtubeTrailer;
    data['episode_run_time'] = this.episodeRunTime;
    data['category_id'] = this.categoryId;
    data['category_ids'] = this.categoryIds;
    return data;
  }
}

class Episode {
  String? id;
  int? episodeNum;
  String? title;
  String? containerExtension;
  EpisodeInfo? info;
  String? customSid;
  String? added;
  int? season;
  String? directSource;

  Episode({
    this.id,
    this.episodeNum,
    this.title,
    this.containerExtension,
    this.info,
    this.customSid,
    this.added,
    this.season,
    this.directSource,
  });

  Episode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    episodeNum = json['episode_num'];
    title = json['title'];
    containerExtension = json['container_extension'];
    info = json['info'] != null ? EpisodeInfo.fromJson(json['info']) : null;
    customSid = json['custom_sid'];
    added = json['added'];
    season = json['season'];
    directSource = json['direct_source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['episode_num'] = this.episodeNum;
    data['title'] = this.title;
    data['container_extension'] = this.containerExtension;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    data['custom_sid'] = this.customSid;
    data['added'] = this.added;
    data['season'] = this.season;
    data['direct_source'] = this.directSource;
    return data;
  }
}

class EpisodeInfo {
  String? airDate;
  String? crew;
  dynamic rating;
  int? id;
  String? movieImage;
  int? durationSecs;
  String? duration;
  VideoMetadata? video;
  AudioMetadata? audio;
  int? bitrate;

  EpisodeInfo({
    this.airDate,
    this.crew,
    this.rating,
    this.id,
    this.movieImage,
    this.durationSecs,
    this.duration,
    this.video,
    this.audio,
    this.bitrate,
  });

  EpisodeInfo.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    crew = json['crew'];
    rating = json['rating'];
    id = json['id'];
    movieImage = json['movie_image'];
    durationSecs = json['duration_secs'];
    duration = json['duration'];
    video = json['video'] != null
        ? VideoMetadata.fromJson(json['video'])
        : null;
    audio = json['audio'] != null
        ? AudioMetadata.fromJson(json['audio'])
        : null;
    bitrate = json['bitrate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['air_date'] = this.airDate;
    data['crew'] = this.crew;
    data['rating'] = this.rating;
    data['id'] = this.id;
    data['movie_image'] = this.movieImage;
    data['duration_secs'] = this.durationSecs;
    data['duration'] = this.duration;
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    if (this.audio != null) {
      data['audio'] = this.audio!.toJson();
    }
    data['bitrate'] = this.bitrate;
    return data;
  }
}

class VideoMetadata {
  int? index;
  String? codecName;
  String? codecLongName;
  String? profile;
  String? codecType;
  int? width;
  int? height;
  String? duration;
  String? bitRate;

  VideoMetadata({
    this.index,
    this.codecName,
    this.codecLongName,
    this.profile,
    this.codecType,
    this.width,
    this.height,
    this.duration,
    this.bitRate,
  });

  VideoMetadata.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    codecName = json['codec_name'];
    codecLongName = json['codec_long_name'];
    profile = json['profile'];
    codecType = json['codec_type'];
    width = json['width'];
    height = json['height'];
    if (json['tags'] != null) {
      duration = json['tags']['DURATION'];
      bitRate = json['tags']['BPS'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = this.index;
    data['codec_name'] = this.codecName;
    data['codec_long_name'] = this.codecLongName;
    data['profile'] = this.profile;
    data['codec_type'] = this.codecType;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class AudioMetadata {
  int? index;
  String? codecName;
  String? codecLongName;
  String? codecType;
  String? sampleFmt;
  String? sampleRate;
  int? channels;
  String? channelLayout;
  String? language;

  AudioMetadata({
    this.index,
    this.codecName,
    this.codecLongName,
    this.codecType,
    this.sampleFmt,
    this.sampleRate,
    this.channels,
    this.channelLayout,
    this.language,
  });

  AudioMetadata.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    codecName = json['codec_name'];
    codecLongName = json['codec_long_name'];
    codecType = json['codec_type'];
    sampleFmt = json['sample_fmt'];
    sampleRate = json['sample_rate'];
    channels = json['channels'];
    channelLayout = json['channel_layout'];
    if (json['tags'] != null) {
      language = json['tags']['language'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = this.index;
    data['codec_name'] = this.codecName;
    data['codec_long_name'] = this.codecLongName;
    data['codec_type'] = this.codecType;
    data['sample_fmt'] = this.sampleFmt;
    data['sample_rate'] = this.sampleRate;
    data['channels'] = this.channels;
    data['channel_layout'] = this.channelLayout;
    return data;
  }
}
