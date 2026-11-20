import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../services/auth_service.dart';
import 'onboarding_screen.dart';
import 'main_shell.dart';

/// Brand colours for the splash screen.
/// Keep them here until the full design-token set is added.
class _Palette {
  const _Palette._();

  static const cream = Color(0xFFF7F1E2);
  static const navy = Color(0xFF1F2A44);
  static const yellow = Color(0xFFF2C230);
  static const orange = Color(0xFFE07A1F);
  static const brown = Color(0xFF3B2A1A);
  static const grey = Color(0xFF5F5A50);
  static const darkBackground = Color(0xFF12100C);
  static const darkText = Color(0xFFF7F1E2);
  static const darkMuted = Color(0xFFC9C0AE);
}

/// Splash screen — screen 01 in workflow.md.
///
/// The design shows branding for two seconds, then moves on automatically.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // workflow.md: splash advances automatically after two seconds.
    _timer = Timer(const Duration(seconds: 2), _autoAdvance);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Runs after the two-second timer.
  void _autoAdvance() {
    if (!mounted) return;
    _openOnboarding();
  }

  /// Button handler.
  void _continue() {
    if (!mounted) return;
    _openOnboarding();
  }

  /// Logged-in users go straight to Places. Everyone else sees Onboarding.
  void _openOnboarding() {
    final loggedIn = AuthService.instance.currentUser != null;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            loggedIn ? const MainShell() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? _Palette.darkBackground : _Palette.cream;
    final primaryText = isDark ? _Palette.darkText : _Palette.navy;
    final mutedText = isDark ? _Palette.darkMuted : _Palette.grey;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(flex: 5, child: _SplashIllustration()),
              const SizedBox(height: 28),
              Text(
                'PAMPANGA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                  color: primaryText.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'LOCALINGO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Good food. New words. Local stories.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: mutedText),
              ),
              const Spacer(),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _continue,
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark ? _Palette.yellow : _Palette.navy,
                    foregroundColor: isDark ? _Palette.navy : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Let's explore",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Made for students & culture lovers',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: mutedText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple stand-in for the Figma/Canva illustration.
class _SplashIllustration extends StatelessWidget {
  const _SplashIllustration();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        color: _Palette.yellow,
        child: Stack(
          children: [
            // TODO: replace with the exported Canva illustration asset.
            const Positioned(
              top: 18,
              left: 24,
              child: Icon(
                Icons.wb_sunny_rounded,
                size: 44,
                color: _Palette.orange,
              ),
            ),
            Positioned(
              top: 34,
              right: 30,
              child: Container(
                width: 46,
                height: 120,
                decoration: const BoxDecoration(
                  color: _Palette.navy,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(23)),
                ),
              ),
            ),
            const Center(
              child: Icon(
                Icons.ramen_dining_rounded,
                size: 132,
                color: _Palette.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
