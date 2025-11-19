
part of 'pelicula.dart';


Pelicula _$PeliculaFromJson(Map<String, dynamic> json) => Pelicula(
  id: json['ID'] as String,
  titleEN: json['titleEN'] as String,
  poster: json['poster'] as String,
  posterBackup: json['posterBackup'] as String,
  synopsis: json['synopsis'] as String,
  quality: json['quality'] as String,
  duration: json['duration'] as String,
  releaseDate: json['releaseDate'],
  releaseDate2: json['releaseDate2'] as String,
  rating: (json['rating'] as num).toDouble(),
  language: json['language'] as String,
  subtitleLanguages: json['subtitleLanguages'] as String,
  relationsSeries: (json['relationsSeries'] as List<dynamic>)
      .map((e) => RelationSerie.fromJson(e as Map<String, dynamic>))
      .toList(),
  movieURL: json['movieURL'] as String,
  movieHash: json['movieHash'] as String?,
  category: json['category'] as String?,
);

Map<String, dynamic> _$PeliculaToJson(Pelicula instance) => <String, dynamic>{
  'ID': instance.id,
  'titleEN': instance.titleEN,
  'poster': instance.poster,
  'posterBackup': instance.posterBackup,
  'synopsis': instance.synopsis,
  'quality': instance.quality,
  'duration': instance.duration,
  'releaseDate': instance.releaseDate,
  'releaseDate2': instance.releaseDate2,
  'rating': instance.rating,
  'language': instance.language,
  'subtitleLanguages': instance.subtitleLanguages,
  'relationsSeries': instance.relationsSeries,
  'movieURL': instance.movieURL,
  'movieHash': instance.movieHash,
  'category': instance.category,
};
