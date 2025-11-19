// lib/services/changelog_service.dart

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// Modelo simple para guardar los datos del release
class AppRelease {
  final String tagName; // ej: "v1.0.0"
  final String body; // El texto del changelog en Markdown
  final String htmlUrl; // El enlace a la página de release

  AppRelease({
    required this.tagName,
    required this.body,
    required this.htmlUrl,
  });

  factory AppRelease.fromJson(Map<String, dynamic> json) {
    return AppRelease(
      tagName: json['tag_name'] ?? 'v1.0.0',
      body: json['body'] ?? 'No se encontraron notas de esta versión.',
      htmlUrl: json['html_url'] ?? '',
    );
  }
}

// El provider que hace la llamada a la API
final changelogProvider = FutureProvider<AppRelease>((ref) async {
  // URL de la API de GitHub para tu repositorio
  final url = Uri.parse(
    'https://api.github.com/repos/zextokar/unlimitedsubs_app/releases',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // La API devuelve una LISTA de releases.
      // Hacemos jsonDecode y tomamos el primero (el más nuevo).
      final List<dynamic> releases = jsonDecode(response.body);
      if (releases.isNotEmpty) {
        // Parseamos el primer release y lo devolvemos
        return AppRelease.fromJson(releases.first);
      } else {
        throw Exception('No se encontraron releases.');
      }
    } else {
      throw Exception('Error al cargar el changelog: ${response.statusCode}');
    }
  } catch (e) {
    // Si falla (sin internet, etc.), devolvemos un release de error
    return AppRelease(
      tagName: 'Error',
      body: 'No se pudo cargar el changelog. Revisa tu conexión a internet.',
      htmlUrl: 'https://github.com/zextokar/unlimitedsubs_app/releases',
    );
  }
});
