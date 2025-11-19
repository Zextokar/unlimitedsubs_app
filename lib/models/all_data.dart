import 'package:json_annotation/json_annotation.dart';
import 'serie.dart';
import 'video_musical.dart';
import 'movies_data.dart';
import 'specials_data.dart';
import 'libro.dart';

part 'all_data.g.dart';

@JsonSerializable(explicitToJson: true)
class AllData {
  @JsonKey(name: 'SuperSentai')
  final List<Serie> superSentai;
  @JsonKey(name: 'KamenRider')
  final List<Serie> kamenRider;
  @JsonKey(name: 'Ultraman')
  final List<Serie> ultraman;
  @JsonKey(name: 'GaroSeries')
  final List<Serie> garoSeries;
  @JsonKey(name: 'OffTopic')
  final List<Serie> offTopic;
  @JsonKey(name: 'Music')
  final List<VideoMusical> music;
  @JsonKey(name: 'Movies')
  final MoviesData movies;
  @JsonKey(name: 'Specials')
  final SpecialsData specials;
  @JsonKey(name: 'Libreria')
  final List<Libro> libreria;

  AllData({
    required this.superSentai,
    required this.kamenRider,
    required this.ultraman,
    required this.garoSeries,
    required this.offTopic,
    required this.music,
    required this.movies,
    required this.specials,
    required this.libreria,
  });

  factory AllData.fromJson(Map<String, dynamic> json) => _$AllDataFromJson(json);
  Map<String, dynamic> toJson() => _$AllDataToJson(this);
}
