import 'package:equatable/equatable.dart';

class UpdateVideoStatusRequest extends Equatable {
  final String title;
  final String videoId;
  final String videoType; // e.g. "movie", "tv", "anime"
  final double? currentTime; // seconds (nullable)
  final double? duration; // total seconds (nullable)
  final int? seasonNumber;
  final int? episodeNumber;
  final bool? isLoved; // null = don't change, true/false = set explicitly
  final String? thumbnail;

  const UpdateVideoStatusRequest({
    required this.title,
    required this.videoId,
    required this.videoType,
    this.currentTime,
    this.duration,
    this.seasonNumber,
    this.episodeNumber,
    this.isLoved,
    this.thumbnail,
  });

  // For JSON serialization (most popular packages: json_serializable, freezed)
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'videoId': videoId,
      'videoType': videoType,
      'lastWatchedAt': DateTime.now()
          .toIso8601String(), // optional – backend ignores it anyway
    };

    if (currentTime != null) {
      map['currentTime'] = currentTime;
    }
    if (duration != null) {
      map['duration'] = duration;
    }
    if (seasonNumber != null) {
      map['seasonNumber'] = seasonNumber;
    }
    if (episodeNumber != null) {
      map['episodeNumber'] = episodeNumber;
    }
    if (isLoved != null) {
      map['isLoved'] = isLoved;
    }
    if (thumbnail != null) {
      map['thumbnail'] = thumbnail;
    }

    return map;
  }

  @override
  List<Object?> get props => [
    title,
    videoId,
    videoType,
    currentTime,
    duration,
    seasonNumber,
    episodeNumber,
    isLoved,
    thumbnail,
  ];

  @override
  bool get stringify => true;
}
