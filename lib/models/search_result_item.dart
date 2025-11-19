// lib/models/search_result_item.dart

// Un 'enum' para saber de qué tipo es el resultado
enum SearchItemType {
  all, // <-- ¡AÑADIDO!
  serie,
  pelicula,
  especialMulti,
  especialOneCap,
  videoMusical,
  episodio,         
  episodioEspecial, 
}

/// Un modelo unificado para contener cualquier tipo de resultado de búsqueda
class SearchResultItem {
  final String title;
  final String imageUrl;
  final SearchItemType type;
  final dynamic originalObject; 
  final String? hash; 

  SearchResultItem({
    required this.title,
    required this.imageUrl,
    required this.type,
    required this.originalObject,
    this.hash,
  });
}