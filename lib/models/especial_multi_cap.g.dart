
part of 'especial_multi_cap.dart';


EspecialMultiCap _$EspecialMultiCapFromJson(Map<String, dynamic> json) =>
    EspecialMultiCap(
      id: json['ID'] as String,
      titleEN: json['titleEN'] as String,
      poster: json['poster'] as String,
      synopsis: json['synopsis'] as String,
      quality: json['quality'] as String,
      duration: json['duration'] as String,
      releaseDate: json['releaseDate'] as String,
      releaseDate2: json['releaseDate2'] as String,
      rating: (json['rating'] as num).toDouble(),
      language: json['language'] as String,
      subtitleLanguages: json['subtitleLanguages'] as String,
      relationsSeries: (json['relationsSeries'] as List<dynamic>)
          .map((e) => RelationSerie.fromJson(e as Map<String, dynamic>))
          .toList(),
      episodes: (json['episodes'] as List<dynamic>)
          .map((e) => EpisodioEspecial.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EspecialMultiCapToJson(
  EspecialMultiCap instance,
) => <String, dynamic>{
  'ID': instance.id,
  'titleEN': instance.titleEN,
  'poster': instance.poster,
  'synopsis': instance.synopsis,
  'quality': instance.quality,
  'duration': instance.duration,
  'releaseDate': instance.releaseDate,
  'releaseDate2': instance.releaseDate2,
  'rating': instance.rating,
  'language': instance.language,
  'subtitleLanguages': instance.subtitleLanguages,
  'relationsSeries': instance.relationsSeries.map((e) => e.toJson()).toList(),
  'episodes': instance.episodes.map((e) => e.toJson()).toList(),
};
