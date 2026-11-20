import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'main_shell.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  /// Opens the tabs (MainShell) on Places.
  void _goToPlaces(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.of(context).background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'YOUR PAMPANGA, NEARBY.',
                style: AppText.label.copyWith(color: AppPalette.of(context).muted),
              ),
              const SizedBox(height: 12),
              Text(
                "Let's find your city.",
                style: AppText.h1.copyWith(color: AppPalette.of(context).ink),
              ),
              const Spacer(),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppPalette.of(context).soft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.place_outlined,
                    size: 30,
                    color: AppPalette.of(context).ink,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Good food is\ncloser than you think.',
                textAlign: TextAlign.center,
                style: AppText.h2.copyWith(color: AppPalette.of(context).ink),
              ),
              const SizedBox(height: 12),
              Text(
                'Allow location to suggest nearby restaurants. '
                'Your location is used only while you explore.',
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppPalette.of(context).muted),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Allow location',
                onPressed: () => _goToPlaces(context),
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                label: 'Not now',
                onPressed: () => _goToPlaces(context),
              ),
              const SizedBox(height: 12),
              Text(
                'You can change this in device settings.',
                textAlign: TextAlign.center,
                style: AppText.small.copyWith(color: AppPalette.of(context).muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
