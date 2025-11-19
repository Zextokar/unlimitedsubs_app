
import 'package:json_annotation/json_annotation.dart';
import 'episodio.dart'; 

part 'serie.g.dart';

@JsonSerializable(explicitToJson: true) 
class Serie {
  @JsonKey(name: 'ID')
  final String id;
  final String titleEN;
  final String poster;
  final String posterBackup;
  final String synopsis;
  final String quality;
  final String duration;
  
  final dynamic releaseDate; // De 'String' a 'dynamic'

  final dynamic rating; 
  final dynamic totalEpisodes; 
  final String status;
  final String language;
  final String subtitleLanguages;
  final List<Episodio> episodes; 

  Serie({
    required this.id,
    required this.titleEN,
    required this.poster,
    required this.posterBackup,
    required this.synopsis,
    required this.quality,
    required this.duration,
    
    required this.releaseDate, // <-- El 'required' se mantiene, solo cambia el tipo arriba

    required this.rating,
    required this.totalEpisodes,
    required this.status,
    required this.language,
    required this.subtitleLanguages,
    required this.episodes,
  });

  factory Serie.fromJson(Map<String, dynamic> json) => _$SerieFromJson(json);
  Map<String, dynamic> toJson() => _$SerieToJson(this);
}
