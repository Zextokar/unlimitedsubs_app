import 'package:json_annotation/json_annotation.dart';
import 'video_musical.dart'; // Re-usamos RelationSerie

part 'especial_one_cap.g.dart';

@JsonSerializable()
class EspecialOneCap {
  @JsonKey(name: 'ID')
  final String id;
  final String poster;
  final String? posterBackup; // Es nulo en algunos casos
  final String titleEN;
  final String synopsis;
  final String quality;
  final String duration;
  final String releaseDate;
  final String releaseDate2;
  final double rating;
  final String language;
  final String subtitleLanguages;
  final List<RelationSerie> relationsSeries;
  final String movieURL;
  final String? movieHash; // Puede ser nulo
  final String? category; // Para HBDVD

  EspecialOneCap({
    required this.id,
    required this.poster,
    this.posterBackup,
    required this.titleEN,
    required this.synopsis,
    required this.quality,
    required this.duration,
    required this.releaseDate,
    required this.releaseDate2,
    required this.rating,
    required this.language,
    required this.subtitleLanguages,
    required this.relationsSeries,
    required this.movieURL,
    this.movieHash,
    this.category,
  });

  factory EspecialOneCap.fromJson(Map<String, dynamic> json) => _$EspecialOneCapFromJson(json);
  Map<String, dynamic> toJson() => _$EspecialOneCapToJson(this);
}
