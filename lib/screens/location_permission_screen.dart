import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'places_screen.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  void _goToPlaces(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const PlacesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'YOUR PAMPANGA, NEARBY.',
                style: AppText.label.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              Text(
                "Let's find your city.",
                style: AppText.h1.copyWith(color: AppColors.navy),
              ),
              const Spacer(),
              Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.card,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.place_outlined,
                    size: 30,
                    color: AppColors.navy,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Good food is\ncloser than you think.',
                textAlign: TextAlign.center,
                style: AppText.h2.copyWith(color: AppColors.navy),
              ),
              const SizedBox(height: 12),
              Text(
                'Allow location to suggest nearby restaurants. '
                'Your location is used only while you explore.',
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppColors.grey),
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
                style: AppText.small.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
