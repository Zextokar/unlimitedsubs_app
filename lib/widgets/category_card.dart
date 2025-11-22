// lib/widgets/category_card.dart

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? imagePath;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    this.icon,
    this.imagePath,
    required this.onTap,
  }) : assert(
         icon != null || imagePath != null,
         'Debes proveer un icono o una ruta de imagen',
       );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget cardContent;
    if (imagePath != null) {
      // --- ¡CAMBIO! Fondo blanco para logos ---
      cardContent = Container(
        padding: const EdgeInsets.all(12.0), // Espacio interno
        decoration: BoxDecoration(
          color: const Color.fromARGB(
            255,
            74,
            74,
            74,
          ), // Fondo blanco para que el logo resalte
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
        ),
        child: Image.asset(imagePath!, fit: BoxFit.contain),
      );
      // --- FIN CAMBIO ---
    } else {
      cardContent = Icon(icon, size: 48, color: colorScheme.primary);
    }

    return Card(
      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // La imagen/ícono toma todo el espacio vertical sobrante
              Expanded(child: Center(child: cardContent)),
              const SizedBox(height: 12),
              // El texto se mantiene abajo
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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
