import 'package:json_annotation/json_annotation.dart';
import 'especial_multi_cap.dart';
import 'especial_one_cap.dart';

part 'specials_data.g.dart';

@JsonSerializable(explicitToJson: true)
class SpecialsData {
  final List<EspecialMultiCap> specialMultiCap;
  final List<EspecialOneCap> specialOneCap;

  SpecialsData({
    required this.specialMultiCap,
    required this.specialOneCap,
  });

  factory SpecialsData.fromJson(Map<String, dynamic> json) => _$SpecialsDataFromJson(json);
  Map<String, dynamic> toJson() => _$SpecialsDataToJson(this);
}
