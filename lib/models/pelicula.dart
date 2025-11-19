
import 'package:json_annotation/json_annotation.dart';
import 'video_musical.dart'; // Re-usamos la clase RelationSerie

part 'pelicula.g.dart';

@JsonSerializable()
class Pelicula {
  @JsonKey(name: 'ID')
  final String id;
  final String titleEN;
  final String poster;
  final String posterBackup;
  final String synopsis;
  final String quality;
  final String duration;
  
  final dynamic releaseDate; // De 'String' a 'dynamic'

  final String releaseDate2;
  final double rating;
  final String language;
  final String subtitleLanguages;
  final List<RelationSerie> relationsSeries;
  final String movieURL;
  final String? movieHash; 
  final String? category; 

  Pelicula({
    required this.id,
    required this.titleEN,
    required this.poster,
    required this.posterBackup,
    required this.synopsis,
    required this.quality,
    required this.duration,

    required this.releaseDate, // <-- El 'required' se mantiene

    required this.releaseDate2,
    required this.rating,
    required this.language,
    required this.subtitleLanguages,
    required this.relationsSeries,
    required this.movieURL,
    this.movieHash,
    this.category,
  });

  factory Pelicula.fromJson(Map<String, dynamic> json) => _$PeliculaFromJson(json);
  Map<String, dynamic> toJson() => _$PeliculaToJson(this);
}
