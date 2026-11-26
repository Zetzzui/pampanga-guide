import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../state/saved_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

// Place card shared by Places and Saved (Figma: same card on both screens).

/// One spot: name, city, tags, star, and its Kapampangan phrase.
class PlaceCard extends StatelessWidget {
  const PlaceCard({super.key, required this.place, required this.onTap});

  final Place place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    // Tags are accent blue in Figma; in dark mode accent is too dim on the
    // card, so use ink there to keep WCAG AA contrast.
    final tagColor =
        Theme.of(context).brightness == Brightness.dark ? c.ink : c.accent;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: c.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: c.line),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 6, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place.name,
                              style: AppText.body.copyWith(
                                fontSize: 19,
                                height: 1.25,
                                fontWeight: FontWeight.w600,
                                color: c.ink,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              place.city,
                              style: AppText.body.copyWith(color: c.muted),
                            ),
                            if (place.tags.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              // Figma: tags as plain text, "Sisig · Local favorite".
                              Text(
                                place.tags.join('  ·  '),
                                style: AppText.small.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: tagColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SaveStar(place: place),
                  ],
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: PhraseBox(phrase: place.phrase),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Star that saves or unsaves a place (workflow.md: "tap star").
/// Figma: outline star when not saved; filled star in a soft circle when saved.
class SaveStar extends StatelessWidget {
  const SaveStar({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    final store = SavedStore.instance;
    // Rebuild only the star when the saved list changes.
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final saved = store.isSaved(place);
        return IconButton(
          onPressed: () => store.toggle(place),
          tooltip: saved
              ? 'Remove ${place.name} from saved'
              : 'Save ${place.name}',
          isSelected: saved,
          color: c.ink,
          iconSize: saved ? 22 : 26,
          style: IconButton.styleFrom(
            backgroundColor: saved ? c.soft : Colors.transparent,
            minimumSize: const Size(48, 48), // 48dp touch target
          ),
          icon: const Icon(Icons.star_border),
          selectedIcon: const Icon(Icons.star),
        );
      },
    );
  }
}

/// Soft blue box with the Kapampangan phrase and its English meaning.
class PhraseBox extends StatelessWidget {
  const PhraseBox({super.key, required this.phrase});

  final Phrase phrase;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    if (phrase.kapampangan.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: c.soft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phrase.kapampangan,
            style: AppText.body.copyWith(
              fontSize: 19,
              height: 1.25,
              fontWeight: FontWeight.w700,
              color: c.ink,
            ),
          ),
          if (phrase.english.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              phrase.english,
              style: AppText.body.copyWith(color: c.muted),
            ),
          ],
        ],
      ),
    );
  }
}
