// lib/screens/about_screen.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Función auxiliar para abrir enlaces
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Opcional: mostrar un error si no se puede abrir
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de UnlimitedSubs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // --- 1. Tu Logo ---
          Image.asset(
            'assets/images/logo.jpg', // <-- El logo que añadimos
            height: 150,
          ),
          const SizedBox(height: 16),

          // --- 2. Versión ---
          const Center(
            child: Text(
              'Versión 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 32),

          // --- 3. Enlaces a Redes ---
          // (Puedes añadir o quitar los que necesites)

          _SocialLinkButton(
            icon: Icons.discord,
            text: 'Únete a nuestro Discord',
            // --- ¡CAMBIA ESTA URL POR LA TUYA! ---
            onTap: () => _launchUrl('https://discord.gg/TU_INVITACION'),
          ),
          
          _SocialLinkButton(
            icon: Icons.public, // Icono genérico para "web"
            text: 'Visita nuestra Web',
            // --- ¡CAMBIA ESTA URL POR LA TUYA! ---
            onTap: () => _launchUrl('https://unlimitedsubs.com'),
          ),

          _SocialLinkButton(
            icon: Icons.facebook,
            text: 'Síguenos en Facebook',
            // --- ¡CAMBIA ESTA URL POR LA TUYA! ---
            onTap: () => _launchUrl('https://facebook.com/TuPagina'),
          ),
          
          const SizedBox(height: 32),
          
          // --- 4. Agradecimiento ---
          const Center(
            child: Text(
              'Hecho con ❤️ para la comunidad Tokusatsu',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Widget Auxiliar para los botones ---
class _SocialLinkButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _SocialLinkButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(text),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          // Usamos los colores del tema (azul)
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}