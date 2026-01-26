class VideoStatusModel {
  final double currentTime;
  final double duration;
  final double progressPercentage;
  final bool isCompleted;
  final bool isLoved;
  final int? seasonNumber;
  final int? episodeNumber;

  VideoStatusModel({
    this.currentTime = 0,
    this.duration = 0,
    this.progressPercentage = 0,
    this.isCompleted = false,
    this.isLoved = false,
    this.seasonNumber,
    this.episodeNumber,
  });

  factory VideoStatusModel.fromJson(Map<String, dynamic> json) {
    return VideoStatusModel(
      currentTime: (json['currentTime'] as num?)?.toDouble() ?? 0,
      duration: (json['duration'] as num?)?.toDouble() ?? 0,
      progressPercentage: (json['progressPercentage'] as num?)?.toDouble() ?? 0,
      isCompleted: json['isCompleted'] ?? false,
      isLoved: json['isLoved'] ?? false,
      seasonNumber: json['seasonNumber'],
      episodeNumber: json['episodeNumber'],
    );
  }
}
