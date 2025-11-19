import 'dart:convert'; // Para jsonDecode
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/all_data.dart'; // Importamos nuestro modelo raíz

const String _apiBaseUrl = "https://ulsapi.unlimiteds.workers.dev";

class ApiService {
  
  Future<AllData> getApiData() async {
    final Uri url = Uri.parse('$_apiBaseUrl/series/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        
        return AllData.fromJson(jsonData);
      } else {
        throw Exception('Error al cargar los datos de la API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de red o al parsear los datos: $e');
    }
  }
}


final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final allDataProvider = FutureProvider<AllData>((ref) {
  final service = ref.watch(apiServiceProvider);
  return service.getApiData();
});
