import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'quiz_screen.dart';

/// Flashcard — one phrase at a time, with reveal and next/previous.
class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  static const _cards = [
    (
      kapampangan: 'Manyaman!',
      pronunciation: 'mah-nya-man',
      english: 'Delicious',
    ),
    (
      kapampangan: 'Mangan ta na!',
      pronunciation: 'mah-ngan tah nah',
      english: "Let's eat!",
    ),
    (
      kapampangan: 'Salamat',
      pronunciation: 'sah-lah-MAHT',
      english: 'Thank you',
    ),
  ];

  int _index = 0;
  bool _revealed = false;

  void _next() {
    setState(() {
      _index = (_index + 1) % _cards.length;
      _revealed = false;
    });
  }

  void _previous() {
    setState(() {
      _index = (_index - 1 + _cards.length) % _cards.length;
      _revealed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = _cards[_index];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: AppColors.navy),
                  ),
                  Text(
                    '${_index + 1} of ${_cards.length}',
                    style: AppText.small.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'FLASHCARD',
                textAlign: TextAlign.center,
                style: AppText.label.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _revealed = !_revealed),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'AT THE TABLE',
                          style: AppText.label.copyWith(
                            color: AppColors.yellow,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          card.kapampangan,
                          textAlign: TextAlign.center,
                          style: AppText.display.copyWith(
                            color: AppColors.yellow,
                            fontSize: 38,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          card.pronunciation,
                          style: AppText.small.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 28),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _revealed ? 1 : 0,
                          child: Text(
                            card.english,
                            style: AppText.h2.copyWith(color: Colors.white),
                          ),
                        ),
                        if (!_revealed) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Tap to reveal',
                            style: AppText.small.copyWith(
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Previous',
                      onPressed: _previous,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(label: 'Next', onPressed: _next),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const QuizScreen()));
                },
                icon: const Icon(Icons.quiz_outlined, size: 18),
                label: const Text('Take the quiz'),
                style: TextButton.styleFrom(foregroundColor: AppColors.navy),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
