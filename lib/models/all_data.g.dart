
part of 'all_data.dart';


AllData _$AllDataFromJson(Map<String, dynamic> json) => AllData(
  superSentai: (json['SuperSentai'] as List<dynamic>)
      .map((e) => Serie.fromJson(e as Map<String, dynamic>))
      .toList(),
  kamenRider: (json['KamenRider'] as List<dynamic>)
      .map((e) => Serie.fromJson(e as Map<String, dynamic>))
      .toList(),
  ultraman: (json['Ultraman'] as List<dynamic>)
      .map((e) => Serie.fromJson(e as Map<String, dynamic>))
      .toList(),
  garoSeries: (json['GaroSeries'] as List<dynamic>)
      .map((e) => Serie.fromJson(e as Map<String, dynamic>))
      .toList(),
  offTopic: (json['OffTopic'] as List<dynamic>)
      .map((e) => Serie.fromJson(e as Map<String, dynamic>))
      .toList(),
  music: (json['Music'] as List<dynamic>)
      .map((e) => VideoMusical.fromJson(e as Map<String, dynamic>))
      .toList(),
  movies: MoviesData.fromJson(json['Movies'] as Map<String, dynamic>),
  specials: SpecialsData.fromJson(json['Specials'] as Map<String, dynamic>),
  libreria: (json['Libreria'] as List<dynamic>)
      .map((e) => Libro.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AllDataToJson(AllData instance) => <String, dynamic>{
  'SuperSentai': instance.superSentai.map((e) => e.toJson()).toList(),
  'KamenRider': instance.kamenRider.map((e) => e.toJson()).toList(),
  'Ultraman': instance.ultraman.map((e) => e.toJson()).toList(),
  'GaroSeries': instance.garoSeries.map((e) => e.toJson()).toList(),
  'OffTopic': instance.offTopic.map((e) => e.toJson()).toList(),
  'Music': instance.music.map((e) => e.toJson()).toList(),
  'Movies': instance.movies.toJson(),
  'Specials': instance.specials.toJson(),
  'Libreria': instance.libreria.map((e) => e.toJson()).toList(),
};
