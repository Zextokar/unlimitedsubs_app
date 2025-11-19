
part of 'specials_data.dart';


SpecialsData _$SpecialsDataFromJson(Map<String, dynamic> json) => SpecialsData(
  specialMultiCap: (json['specialMultiCap'] as List<dynamic>)
      .map((e) => EspecialMultiCap.fromJson(e as Map<String, dynamic>))
      .toList(),
  specialOneCap: (json['specialOneCap'] as List<dynamic>)
      .map((e) => EspecialOneCap.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SpecialsDataToJson(
  SpecialsData instance,
) => <String, dynamic>{
  'specialMultiCap': instance.specialMultiCap.map((e) => e.toJson()).toList(),
  'specialOneCap': instance.specialOneCap.map((e) => e.toJson()).toList(),
};
