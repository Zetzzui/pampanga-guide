import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoPageTransitionsBuilder;
import 'package:material_ui/material_ui.dart';

import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_colors.dart';
import 'theme/app_text.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Start Firebase. If it is not set up yet, the app still runs in guest mode.
  await AuthService.instance.init();
  runApp(const LocalingoApp());
}

/// App root: light and dark themes plus the first screen.
class LocalingoApp extends StatelessWidget {
  const LocalingoApp({super.key});

  /// Builds the light or dark theme from the Figma colour tokens.
  static ThemeData _theme(Brightness brightness) {
    final c = brightness == Brightness.dark
        ? AppPalette.dark
        : AppPalette.light;
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppText.sans, // DM Sans everywhere unless a style says Lora

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent,
        brightness: brightness,
      ).copyWith(
        primary: c.accent,
        onPrimary: c.onAccent,
        surface: c.background,
        onSurface: c.ink,
      ),
      scaffoldBackgroundColor: c.background,
      extensions: [c],
      // Same iOS-style slide on every platform (the Figma is an iOS design),
      // instead of the web/Android zoom that made screens jump.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOCALINGO',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: const SplashScreen(),
    );
  }
}
