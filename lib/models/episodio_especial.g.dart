
part of 'episodio_especial.dart';


EpisodioEspecial _$EpisodioEspecialFromJson(Map<String, dynamic> json) =>
    EpisodioEspecial(
      episodeSpecialID: json['episodeSpecialID'] as String,
      episodeTitle: json['episodeTitle'] as String,
      episodeNumber: (json['episodeNumber'] as num).toInt(),
      episodeDuration: json['episodeDuration'] as String?,
      episodePreview: json['episodePreview'] as String?,
      movieURL: json['movieURL'] as String?,
      movieHash: json['movieHash'] as String?,
      releaseDate: json['releaseDate'] as String,
    );

Map<String, dynamic> _$EpisodioEspecialToJson(EpisodioEspecial instance) =>
    <String, dynamic>{
      'episodeSpecialID': instance.episodeSpecialID,
      'episodeTitle': instance.episodeTitle,
      'episodeNumber': instance.episodeNumber,
      'episodeDuration': instance.episodeDuration,
      'episodePreview': instance.episodePreview,
      'movieURL': instance.movieURL,
      'movieHash': instance.movieHash,
      'releaseDate': instance.releaseDate,
    };
