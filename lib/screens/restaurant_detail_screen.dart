import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key, required this.place});

  final Place place;

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    return Scaffold(
      backgroundColor: AppPalette.of(context).background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LOCAL FAVORITE',
                  style: AppText.label.copyWith(color: AppPalette.of(context).muted),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: AppPalette.of(context).ink),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(place.name, style: AppText.h1.copyWith(color: AppPalette.of(context).ink)),
            const SizedBox(height: 4),
            Text(
              '${place.city} · Pampanga',
              style: AppText.small.copyWith(color: AppPalette.of(context).muted),
            ),
            const SizedBox(height: 20),
            Text(
              'The taste of sisig country.',
              style: AppText.h2.copyWith(color: AppPalette.of(context).ink),
            ),
            const SizedBox(height: 10),
            Text(
              place.description,
              style: AppText.body.copyWith(color: AppPalette.of(context).muted),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppPalette.of(context).soft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.phrase.kapampangan,
                    style: AppText.h2.copyWith(color: AppPalette.of(context).ink),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    place.phrase.syllables,
                    style: AppText.small.copyWith(color: AppPalette.of(context).muted),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.phrase.english,
                    style: AppText.body.copyWith(color: AppPalette.of(context).muted),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.volume_up_outlined,
                        size: 18,
                        color: AppPalette.of(context).ink,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Hear the phrase',
                        style: AppText.small.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppPalette.of(context).ink,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Directions',
              icon: Icons.north_east,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Maps opens in a later step.')),
                );
              },
            ),
            const SizedBox(height: 10),
            SecondaryButton(
              label: _saved ? 'Saved' : 'Save this place',
              onPressed: () => setState(() => _saved = !_saved),
            ),
          ],
        ),
      ),
    );
  }
}
