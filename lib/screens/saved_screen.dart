import 'package:material_ui/material_ui.dart';

import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'learn_screen.dart';
import 'places_screen.dart';
import 'restaurant_detail_screen.dart';

/// Saved — places the user bookmarked, with an empty state.
class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  // TODO: replace with the user's saved spots from Firestore.
  final List<Place> _saved = [mockPlaces.first];

  void _onNav(int index) {
    if (index == 3) return;
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PlacesScreen()),
      );
      return;
    }
    if (index == 1) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LearnScreen()));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quiz is available from Learn.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: AppBottomNav(index: 3, onTap: _onNav),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          children: [
            Text(
              'YOUR FOOD TRAIL',
              style: AppText.label.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 10),
            Text(
              'Saved places',
              style: AppText.h1.copyWith(color: AppColors.navy),
            ),
            const SizedBox(height: 8),
            Text(
              'Keep the tables you want to come back to.',
              style: AppText.body.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 24),
            if (_saved.isEmpty)
              _EmptyState()
            else
              ..._saved.map(
                (place) => _SavedCard(
                  place: place,
                  onOpen: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailScreen(place: place),
                      ),
                    );
                  },
                  onRemove: () => setState(() => _saved.remove(place)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SavedCard extends StatelessWidget {
  const _SavedCard({
    required this.place,
    required this.onOpen,
    required this.onRemove,
  });

  final Place place;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: AppText.h3.copyWith(color: AppColors.navy),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${place.city} · Pampanga',
                      style: AppText.small.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      place.phrase,
                      style: AppText.small.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onRemove,
                tooltip: 'Remove',
                icon: const Icon(
                  Icons.bookmark,
                  color: AppColors.navy,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.bookmark_border, size: 34, color: AppColors.navy),
          const SizedBox(height: 12),
          Text(
            'Nothing saved yet',
            style: AppText.h3.copyWith(color: AppColors.navy),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap the bookmark on a place to keep it here.',
            textAlign: TextAlign.center,
            style: AppText.small.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
