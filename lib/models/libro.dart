import 'package:json_annotation/json_annotation.dart';

part 'libro.g.dart';

@JsonSerializable()
class Libro {
  final String nombre;
  final String enlace;
  final String preview;

  Libro({
    required this.nombre,
    required this.enlace,
    required this.preview,
  });

  factory Libro.fromJson(Map<String, dynamic> json) => _$LibroFromJson(json);
  Map<String, dynamic> toJson() => _$LibroToJson(this);
}
