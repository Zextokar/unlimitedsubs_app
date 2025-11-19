
part of 'libro.dart';


Libro _$LibroFromJson(Map<String, dynamic> json) => Libro(
  nombre: json['nombre'] as String,
  enlace: json['enlace'] as String,
  preview: json['preview'] as String,
);

Map<String, dynamic> _$LibroToJson(Libro instance) => <String, dynamic>{
  'nombre': instance.nombre,
  'enlace': instance.enlace,
  'preview': instance.preview,
};
