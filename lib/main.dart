import 'package:material_ui/material_ui.dart';

import 'screens/splash_screen.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Start Firebase. If it is not set up yet, the app still runs in guest mode.
  await AuthService.instance.init();
  runApp(const LocalingoApp());
}

/// App root: light and dark themes plus the first screen.
class LocalingoApp extends StatelessWidget {
  const LocalingoApp({super.key});

  static const _seed = Color(0xFF1F2A44);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOCALINGO',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
