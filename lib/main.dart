import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/navigation_screen.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    const ProviderScope(
      child: CampusBazaarApp(),
    ),
  );
}

class CampusBazaarApp extends ConsumerWidget {
  const CampusBazaarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    const primaryPurple = Color(0xFF6B4EFF);
    const accentCoral = Color(0xFFFF6B6B);
    const secondaryCyan = Color(0xFF00C4CC);

    return MaterialApp(
      title: 'CampusBazaar',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          brightness: Brightness.light,
        ).copyWith(
          primary: primaryPurple,
          secondary: secondaryCyan,
          tertiary: accentCoral,
          surface: Colors.white,
          surfaceContainerLowest: const Color(0xFFF3E5F5),
          surfaceContainer: const Color(0xFFE1BEE7),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3E5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 4,
          shadowColor: primaryPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryPurple,
          brightness: Brightness.dark,
        ).copyWith(
          primary: primaryPurple,
          secondary: secondaryCyan,
          tertiary: accentCoral,
          surface: const Color(0xFF2A2438),
          surfaceContainerLowest: const Color(0xFF1E1B24),
          surfaceContainer: const Color(0xFF2A2438),
        ),
        scaffoldBackgroundColor: const Color(0xFF1E1B24),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A2438),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF2A2438),
          elevation: 4,
          shadowColor: primaryPurple.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      home: const AuthGate(),
    );
  }
}