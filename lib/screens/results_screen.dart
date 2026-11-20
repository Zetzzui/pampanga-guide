import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'quiz_screen.dart';

/// Results (Figma: "Little wins add up." frames).
///
/// Shown inside the Quiz tab, so the bottom nav stays visible.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.score,
    required this.total,
    required this.lastQuestion,
    required this.onTryAgain,
    required this.onPractice,
    required this.onReview,
  });

  final int score;
  final int total;

  /// Used for the one-question messages, e.g. "Good morning".
  final QuizQuestion lastQuestion;

  final VoidCallback onTryAgain;

  /// "Practice more words" (perfect score).
  final VoidCallback onPractice;

  /// "Review the phrase" (not perfect).
  // TODO: Figma opens a Pronunciation screen here. It is not in the
  // AGENTS.md screen list, so this goes to Learn until it is approved.
  final VoidCallback onReview;

  bool get _perfect => total > 0 && score == total;

  String get _title =>
      _perfect ? 'A perfect little start!' : 'Every try teaches you.';

  String get _message {
    final q = lastQuestion;
    if (total == 1) {
      return _perfect
          ? 'You know how to say “${q.meaning}”.'
          : '“${q.phrase}” means “${q.meaning}”.';
    }
    return _perfect
        ? 'You got all $total right.'
        : 'You got $score of $total right.';
  }

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                children: [
                  Text(
                    'QUICK QUIZ COMPLETE',
                    style: AppText.label.copyWith(
                      color: dark ? c.ink : c.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Little wins add up.',
                    style: AppText.h1.copyWith(color: c.ink),
                  ),
                  const SizedBox(height: 18),
                  // Figma: yellow score card.
                  Semantics(
                    label: 'Score $score out of $total. $_title $_message',
                    excludeSemantics: true,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                      decoration: BoxDecoration(
                        color: c.highlight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$score / $total',
                            style: AppText.display.copyWith(
                              fontSize: 44,
                              color: c.onHighlight,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _title,
                            textAlign: TextAlign.center,
                            style: AppText.body.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: c.onHighlight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _message,
                            textAlign: TextAlign.center,
                            style: AppText.small.copyWith(
                              fontSize: 13,
                              color: c.onHighlight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Keep the conversation going',
                    style: AppText.body.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Practice a useful phrase, then try it the next time '
                    "you're out in Pampanga.",
                    style: AppText.body.copyWith(color: c.muted),
                  ),
                ],
              ),
            ),
            // Figma: two buttons at the bottom, above the nav.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  PrimaryButton(
                    label: _perfect ? 'Practice more words' : 'Review the phrase',
                    onPressed: _perfect ? onPractice : onReview,
                  ),
                  const SizedBox(height: 10),
                  SecondaryButton(label: 'Try again', onPressed: onTryAgain),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
