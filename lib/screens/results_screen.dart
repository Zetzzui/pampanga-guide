import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'learn_screen.dart';
import 'quiz_screen.dart';

/// Results — score after a quiz, with retry and back to Learn.
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.score, required this.total});

  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : (score / total * 100).round();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 132,
                  height: 132,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.yellow,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$percent%',
                        style: AppText.h1.copyWith(
                          color: AppColors.navy,
                          fontSize: 34,
                        ),
                      ),
                      Text(
                        'score',
                        style: AppText.small.copyWith(color: AppColors.brown),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                percent >= 70 ? 'Maupay! Nice work.' : 'Keep practicing.',
                textAlign: TextAlign.center,
                style: AppText.h1.copyWith(color: AppColors.navy),
              ),
              const SizedBox(height: 10),
              Text(
                'You got $score of $total right.',
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppColors.grey),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Try again',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const QuizScreen()),
                  );
                },
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                label: 'Back to Learn',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LearnScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
