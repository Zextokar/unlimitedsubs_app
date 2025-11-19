import 'package:json_annotation/json_annotation.dart';
import 'video_musical.dart'; // Re-usamos RelationSerie
import 'episodio_especial.dart';

part 'especial_multi_cap.g.dart';

@JsonSerializable(explicitToJson: true)
class EspecialMultiCap {
  @JsonKey(name: 'ID')
  final String id;
  final String titleEN;
  final String poster;
  final String synopsis;
  final String quality;
  final String duration;
  final String releaseDate;
  final String releaseDate2;
  final double rating;
  final String language;
  final String subtitleLanguages;
  final List<RelationSerie> relationsSeries;
  final List<EpisodioEspecial> episodes; // <-- Lista de episodios especiales

  EspecialMultiCap({
    required this.id,
    required this.titleEN,
    required this.poster,
    required this.synopsis,
    required this.quality,
    required this.duration,
    required this.releaseDate,
    required this.releaseDate2,
    required this.rating,
    required this.language,
    required this.subtitleLanguages,
    required this.relationsSeries,
    required this.episodes,
  });

  factory EspecialMultiCap.fromJson(Map<String, dynamic> json) => _$EspecialMultiCapFromJson(json);
  Map<String, dynamic> toJson() => _$EspecialMultiCapToJson(this);
}
