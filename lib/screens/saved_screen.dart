import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../state/saved_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/place_card.dart';
import '../widgets/ui_kit.dart';
import 'main_shell.dart';
import 'restaurant_detail_screen.dart';

/// Saved tab (Figma: "Saved places" frames).
///
/// Shows starred places, or the empty state when there are none.
/// Tapping a filled star removes the place (workflow.md: Save a Favorite).
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  void _openPlace(BuildContext context, Place place) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RestaurantDetailScreen(place: place)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    final store = SavedStore.instance;
    // The bottom nav lives in MainShell, so it stays still between tabs.
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        // Rebuild when a place is starred or unstarred on any screen.
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final saved = store.places;
            if (saved.isEmpty) return const _EmptySaved();
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              children: [
                const _Heading(label: 'READY FOR YOUR NEXT FOOD TRIP'),
                const SizedBox(height: 4),
                Text(
                  'Your favorites  ·  Available offline',
                  style: AppText.small.copyWith(fontSize: 13, color: c.muted),
                ),
                const SizedBox(height: 16),
                ...saved.map(
                  (place) => PlaceCard(
                    place: place,
                    onTap: () => _openPlace(context, place),
                  ),
                ),
                const _PhraseTip(),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Small label plus the "Saved places" title.
class _Heading extends StatelessWidget {
  const _Heading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          // Accent is too dim on the dark background, so use ink there.
          style: AppText.label.copyWith(color: dark ? c.ink : c.accent),
        ),
        const SizedBox(height: 4),
        Text('Saved places', style: AppText.h1.copyWith(color: c.ink)),
      ],
    );
  }
}

/// Figma empty frame: star circle, "Your favorites start here.", button.
class _EmptySaved extends StatelessWidget {
  const _EmptySaved();

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Heading(label: 'YOUR LITTLE LOCAL LIST'),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: c.soft,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star_border, size: 28, color: c.ink),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Your favorites\nstart here.',
                      textAlign: TextAlign.center,
                      style: AppText.h2.copyWith(
                        fontSize: 26,
                        height: 1.35,
                        color: c.ink,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Tap the star on any restaurant to keep it close '
                      'for your next food trip.',
                      textAlign: TextAlign.center,
                      style: AppText.body.copyWith(fontSize: 15, color: c.muted),
                    ),
                    const SizedBox(height: 22),
                    // workflow.md: Empty State -> "Browse Places" -> Places.
                    PrimaryButton(
                      label: 'Discover local places',
                      onPressed: () =>
                          MainShell.goTo(context, MainShell.places),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma tip box under the saved list.
class _PhraseTip extends StatelessWidget {
  const _PhraseTip();

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: c.soft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good food, good words.',
            style: AppText.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 6),
          // TODO: verify "Dakal a salamat" with a Kapampangan speaker.
          Text(
            'Try saying “Dakal a salamat” — thank you very much — '
            'before you leave.',
            style: AppText.body.copyWith(fontSize: 13, color: c.muted),
          ),
        ],
      ),
    );
  }
}
