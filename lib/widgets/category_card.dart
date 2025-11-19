// lib/widgets/category_card.dart

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData? icon; // <-- ¡Hecho opcional!
  final String? imagePath; // <-- ¡AÑADIDO!
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    this.icon,
    this.imagePath,
    required this.onTap,
  }) : assert(icon != null || imagePath != null, 'Debes proveer un icono o una ruta de imagen');
  // ^ (Nos aseguramos de que nos den al menos uno de los dos)

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // --- ¡LÓGICA NUEVA! ---
    // Decide qué mostrar: la imagen o el ícono
    Widget cardContent;
    if (imagePath != null) {
      // Si hay imagen, la usamos
      cardContent = Image.asset(
        imagePath!,
        fit: BoxFit.contain, // Ajusta la imagen dentro del espacio
        height: 64, // Un tamaño fijo para el logo
      );
    } else {
      // Si no, usamos el ícono
      cardContent = Icon(
        icon,
        size: 48, 
        color: colorScheme.primary,
      );
    }
    // --- FIN LÓGICA NUEVA ---

    return Card(
      // ignore: deprecated_member_use
      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Usamos el widget que decidimos arriba
              Expanded(
                child: Center(child: cardContent),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}