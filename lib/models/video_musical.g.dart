
part of 'video_musical.dart';


RelationSerie _$RelationSerieFromJson(Map<String, dynamic> json) =>
    RelationSerie(relationSerieID: json['relationSerieID'] as String);

Map<String, dynamic> _$RelationSerieToJson(RelationSerie instance) =>
    <String, dynamic>{'relationSerieID': instance.relationSerieID};

VideoMusical _$VideoMusicalFromJson(Map<String, dynamic> json) => VideoMusical(
  id: json['id'] as String,
  title: json['title'] as String,
  coverImage: json['coverImage'] as String,
  coverImageBackup: json['coverImageBackup'] as String,
  releaseDate: json['releaseDate'] as String,
  duration: json['duration'] as String,
  relationsSeries: (json['relationsSeries'] as List<dynamic>)
      .map((e) => RelationSerie.fromJson(e as Map<String, dynamic>))
      .toList(),
  urlVideo: json['urlVideo'] as String,
  urlHash: json['urlHash'] as String?,
);

Map<String, dynamic> _$VideoMusicalToJson(VideoMusical instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'coverImage': instance.coverImage,
      'coverImageBackup': instance.coverImageBackup,
      'releaseDate': instance.releaseDate,
      'duration': instance.duration,
      'relationsSeries': instance.relationsSeries,
      'urlVideo': instance.urlVideo,
      'urlHash': instance.urlHash,
    };
