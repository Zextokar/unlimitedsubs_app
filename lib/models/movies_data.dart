import 'package:json_annotation/json_annotation.dart';
import 'pelicula.dart';

part 'movies_data.g.dart';

@JsonSerializable(explicitToJson: true)
class MoviesData {
  final List<Pelicula> movieCrossover;
  final List<Pelicula> movieWinterSerie;

  MoviesData({
    required this.movieCrossover,
    required this.movieWinterSerie,
  });

  factory MoviesData.fromJson(Map<String, dynamic> json) => _$MoviesDataFromJson(json);
  Map<String, dynamic> toJson() => _$MoviesDataToJson(this);
}
