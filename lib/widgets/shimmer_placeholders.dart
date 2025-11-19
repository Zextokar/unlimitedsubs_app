// lib/widgets/shimmer_placeholders.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// --- WIDGET 1: El Esqueleto de la HomeScreen ---
// (Imita el Banner + una cuadrícula)
class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // El widget Shimmer aplica el efecto de brillo a todos sus hijos
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!, // Color base del esqueleto
      highlightColor: Colors.grey[700]!, // Color del brillo
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll
        child: Column(
          children: [
            // 1. Placeholder del Hero Banner
            Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.black, // Color sólido para el Shimmer
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            
            // 2. Placeholder de la Cuadrícula
            _buildGridPlaceholder(context),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET 2: El Esqueleto de las Pantallas de Cuadrícula ---
// (Imita SeriesCategoryScreen, LibraryMoviesScreen, etc.)
class GridScreenSkeleton extends StatelessWidget {
  const GridScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[700]!,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: _buildGridPlaceholder(context), // Solo la cuadrícula
      ),
    );
  }
}

// --- Widget Auxiliar para construir una cuadrícula falsa ---
Widget _buildGridPlaceholder(BuildContext context) {
  // Calculamos el ancho de las tarjetas falsas
  final screenWidth = MediaQuery.of(context).size.width;
  final sectionPadding = 16.0 * 2;
  final spacing = 12.0;
  final cardWidth = (screenWidth - sectionPadding - spacing) / 2;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Wrap(
      spacing: 12.0,
      runSpacing: 16.0,
      children: List.generate(8, (index) { // Genera 8 tarjetas falsas
        return SizedBox(
          width: cardWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder de la imagen 16:9
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Placeholder del texto (una barra)
              Container(
                height: 14,
                width: cardWidth * 0.8, // 80% del ancho
                color: Colors.black,
              ),
            ],
          ),
        );
      }),
    ),
  );
}