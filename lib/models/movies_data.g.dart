
part of 'movies_data.dart';


MoviesData _$MoviesDataFromJson(Map<String, dynamic> json) => MoviesData(
  movieCrossover: (json['movieCrossover'] as List<dynamic>)
      .map((e) => Pelicula.fromJson(e as Map<String, dynamic>))
      .toList(),
  movieWinterSerie: (json['movieWinterSerie'] as List<dynamic>)
      .map((e) => Pelicula.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MoviesDataToJson(
  MoviesData instance,
) => <String, dynamic>{
  'movieCrossover': instance.movieCrossover.map((e) => e.toJson()).toList(),
  'movieWinterSerie': instance.movieWinterSerie.map((e) => e.toJson()).toList(),
};
