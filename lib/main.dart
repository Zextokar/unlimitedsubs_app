import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/app_theme.dart'; // Importamos el provider
import 'screens/main_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'UnlimitedSubs',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme, // Tema a usar si es modo claro
      darkTheme: AppTheme.darkTheme, // Tema a usar si es modo oscuro
      themeMode: ThemeMode.dark, // <-- Le decimos qué modo usar

      home: const MainScreen(),
    );
  }
}
