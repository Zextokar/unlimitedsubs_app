
import 'package:json_annotation/json_annotation.dart';

part 'episodio.g.dart';

@JsonSerializable()
class Episodio {
  final String episodeID;
  final String episodeTitle;
  final int episodeNumber;
  final String? episodeDuration; // <-- CAMBIO: Hecho opcional
  final String? episodePreview; // <-- CAMBIO: Hecho opcional
  final String? episodePreviewBackup; // <-- CAMBIO: Hecho opcional
  final String? episodeURL; 
  final String? episodeHash; 
  final String? releaseDate; // <-- CAMBIO: Hecho opcional

  Episodio({
    required this.episodeID,
    required this.episodeTitle,
    required this.episodeNumber,
    this.episodeDuration, // <-- CAMBIO: Quitamos 'required'
    this.episodePreview, // <-- CAMBIO: Quitamos 'required'
    this.episodePreviewBackup, // <-- CAMBIO: Quitamos 'required'
    this.episodeURL, 
    this.episodeHash,
    this.releaseDate, // <-- CAMBIO: Quitamos 'required'
  });

  factory Episodio.fromJson(Map<String, dynamic> json) => _$EpisodioFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodioToJson(this);
}
