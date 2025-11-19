
part of 'episodio.dart';


Episodio _$EpisodioFromJson(Map<String, dynamic> json) => Episodio(
  episodeID: json['episodeID'] as String,
  episodeTitle: json['episodeTitle'] as String,
  episodeNumber: (json['episodeNumber'] as num).toInt(),
  episodeDuration: json['episodeDuration'] as String?,
  episodePreview: json['episodePreview'] as String?,
  episodePreviewBackup: json['episodePreviewBackup'] as String?,
  episodeURL: json['episodeURL'] as String?,
  episodeHash: json['episodeHash'] as String?,
  releaseDate: json['releaseDate'] as String?,
);

Map<String, dynamic> _$EpisodioToJson(Episodio instance) => <String, dynamic>{
  'episodeID': instance.episodeID,
  'episodeTitle': instance.episodeTitle,
  'episodeNumber': instance.episodeNumber,
  'episodeDuration': instance.episodeDuration,
  'episodePreview': instance.episodePreview,
  'episodePreviewBackup': instance.episodePreviewBackup,
  'episodeURL': instance.episodeURL,
  'episodeHash': instance.episodeHash,
  'releaseDate': instance.releaseDate,
};
