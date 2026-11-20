import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'flashcard_screen.dart';
import 'places_screen.dart';
import 'quiz_screen.dart';
import 'saved_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  int _category = 0;
  bool _revealed = false;

  static const _categories = ['Food', 'Greetings'];

  void _onNav(int index) {
    if (index == 1) return;
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PlacesScreen()),
      );
      return;
    }
    if (index == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const QuizScreen()));
      return;
    }
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SavedScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: AppBottomNav(index: 1, onTap: _onNav),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          children: [
            Text(
              'A LITTLE EVERY DAY',
              style: AppText.label.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 10),
            Text(
              'Learn Kapampangan',
              style: AppText.h1.copyWith(color: AppColors.navy),
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(_categories.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterPill(
                    label: _categories[i],
                    selected: _category == i,
                    onTap: () => setState(() {
                      _category = i;
                      _revealed = false;
                    }),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1 of 8 phrases',
                  style: AppText.small.copyWith(color: AppColors.muted),
                ),
                Text(
                  '13%',
                  style: AppText.small.copyWith(color: AppColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: const LinearProgressIndicator(
                value: 0.13,
                minHeight: 5,
                backgroundColor: AppColors.line,
                valueColor: AlwaysStoppedAnimation(AppColors.navy),
              ),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () => setState(() => _revealed = !_revealed),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'AT THE TABLE',
                      style: AppText.label.copyWith(
                        color: AppColors.yellow,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Manyaman!',
                      textAlign: TextAlign.center,
                      style: AppText.display.copyWith(color: AppColors.yellow),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'mah-nya-man',
                      style: AppText.small.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _revealed ? 'Delicious' : 'Tap to reveal the meaning',
                      textAlign: TextAlign.center,
                      style: AppText.body.copyWith(
                        color: _revealed ? Colors.white : Colors.white70,
                        fontWeight: _revealed
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const FlashcardScreen()),
                  );
                },
                icon: const Icon(Icons.style_outlined, size: 18),
                label: const Text('Practice with flashcards'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  side: const BorderSide(color: AppColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Try it locally',
                    style: AppText.small.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Say 'Manyaman!' when you enjoy a Kapampangan dish.",
                    style: AppText.small.copyWith(color: AppColors.brown),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
