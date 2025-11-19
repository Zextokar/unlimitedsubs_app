import 'package:json_annotation/json_annotation.dart';

part 'video_musical.g.dart';

@JsonSerializable()
class RelationSerie {
  final String relationSerieID;
  RelationSerie({required this.relationSerieID});
  factory RelationSerie.fromJson(Map<String, dynamic> json) => _$RelationSerieFromJson(json);
  Map<String, dynamic> toJson() => _$RelationSerieToJson(this);
}

@JsonSerializable()
class VideoMusical {
  final String id;
  final String title;
  final String coverImage;
  final String coverImageBackup;
  final String releaseDate;
  final String duration;
  final List<RelationSerie> relationsSeries;
  final String urlVideo;
  final String? urlHash; // Puede ser nulo

  VideoMusical({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.coverImageBackup,
    required this.releaseDate,
    required this.duration,
    required this.relationsSeries,
    required this.urlVideo,
    this.urlHash,
  });

  factory VideoMusical.fromJson(Map<String, dynamic> json) => _$VideoMusicalFromJson(json);
  Map<String, dynamic> toJson() => _$VideoMusicalToJson(this);
}
