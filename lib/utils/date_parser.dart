// lib/utils/date_parser.dart

DateTime parseDate(dynamic date) {
  if (date == null) return DateTime(1970);
  if (date is int) return DateTime(date); // Si es un año, ej: 2008
  if (date is String) {
    try {
      if (date.length == 4) {
        // Es solo un año, ej: "2024"
        return DateTime(int.parse(date));
      }
      // Es una fecha completa, ej: "2024-11-22"
      return DateTime.parse(date);
    } catch (e) {
      // Si falla, devuelve una fecha muy antigua
      return DateTime(1970);
    }
  }
  return DateTime(1970);
}