
import 'package:json_annotation/json_annotation.dart';

part 'episodio_especial.g.dart';

@JsonSerializable()
class EpisodioEspecial {
  final String episodeSpecialID;
  final String episodeTitle;
  final int episodeNumber;
  
  final String? episodeDuration; // De 'String' a 'String?'
  final String? episodePreview;  // De 'String' a 'String?'

  final String? movieURL;
  final String? movieHash;
  final String releaseDate;

  EpisodioEspecial({
    required this.episodeSpecialID,
    required this.episodeTitle,
    required this.episodeNumber,
    
    this.episodeDuration, // Quitamos 'required'
    this.episodePreview,  // Quitamos 'required'

    this.movieURL,
    this.movieHash,
    required this.releaseDate,
  });

  factory EpisodioEspecial.fromJson(Map<String, dynamic> json) => _$EpisodioEspecialFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodioEspecialToJson(this);
}
