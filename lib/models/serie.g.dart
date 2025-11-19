
part of 'serie.dart';


Serie _$SerieFromJson(Map<String, dynamic> json) => Serie(
  id: json['ID'] as String,
  titleEN: json['titleEN'] as String,
  poster: json['poster'] as String,
  posterBackup: json['posterBackup'] as String,
  synopsis: json['synopsis'] as String,
  quality: json['quality'] as String,
  duration: json['duration'] as String,
  releaseDate: json['releaseDate'],
  rating: json['rating'],
  totalEpisodes: json['totalEpisodes'],
  status: json['status'] as String,
  language: json['language'] as String,
  subtitleLanguages: json['subtitleLanguages'] as String,
  episodes: (json['episodes'] as List<dynamic>)
      .map((e) => Episodio.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SerieToJson(Serie instance) => <String, dynamic>{
  'ID': instance.id,
  'titleEN': instance.titleEN,
  'poster': instance.poster,
  'posterBackup': instance.posterBackup,
  'synopsis': instance.synopsis,
  'quality': instance.quality,
  'duration': instance.duration,
  'releaseDate': instance.releaseDate,
  'rating': instance.rating,
  'totalEpisodes': instance.totalEpisodes,
  'status': instance.status,
  'language': instance.language,
  'subtitleLanguages': instance.subtitleLanguages,
  'episodes': instance.episodes.map((e) => e.toJson()).toList(),
};
