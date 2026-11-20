import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'results_screen.dart';

/// Quiz — multiple choice over the phrases from Learn.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  static const _questions = [
    _Question(
      prompt: 'What does "Manyaman!" mean?',
      options: ['Delicious', 'Goodbye', 'Come in', 'Thank you'],
      answer: 0,
    ),
    _Question(
      prompt: 'How do you say "Thank you" in Kapampangan?',
      options: ['Mangan ta na', 'Salamat', 'Manyaman', 'Mayap a abak'],
      answer: 1,
    ),
    _Question(
      prompt: 'What does "Mangan ta na!" mean?',
      options: ["Let's eat!", 'See you', 'Good morning', 'Where is it?'],
      answer: 0,
    ),
  ];

  int _index = 0;
  int _correct = 0;
  int? _selected;

  bool get _answered => _selected != null;

  void _choose(int option) {
    if (_answered) return;
    setState(() {
      _selected = option;
      if (option == _questions[_index].answer) _correct++;
    });
  }

  void _next() {
    if (_index == _questions.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              ResultsScreen(score: _correct, total: _questions.length),
        ),
      );
      return;
    }
    setState(() {
      _index++;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_index];
    final progress = (_index + 1) / _questions.length;

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
                    'Question ${_index + 1} of ${_questions.length}',
                    style: AppText.small.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: AppColors.line,
                  valueColor: const AlwaysStoppedAnimation(AppColors.navy),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'QUIZ',
                style: AppText.label.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 10),
              Text(
                question.prompt,
                style: AppText.h2.copyWith(color: AppColors.navy),
              ),
              const SizedBox(height: 24),
              ...List.generate(question.options.length, (i) {
                final isCorrect = i == question.answer;
                final isPicked = i == _selected;
                Color border = AppColors.line;
                Color background = Colors.white.withValues(alpha: 0.6);
                if (_answered && isCorrect) {
                  border = AppColors.navy;
                  background = AppColors.card;
                } else if (_answered && isPicked) {
                  border = AppColors.orange;
                  background = const Color(0xFFFBE7D4);
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => _choose(i),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 56),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: background,
                        border: Border.all(color: border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              question.options[i],
                              style: AppText.body.copyWith(
                                color: AppColors.navy,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (_answered && isCorrect)
                            const Icon(
                              Icons.check_circle,
                              size: 20,
                              color: AppColors.navy,
                            )
                          else if (_answered && isPicked)
                            const Icon(
                              Icons.cancel,
                              size: 20,
                              color: AppColors.orange,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              PrimaryButton(
                label: _index == _questions.length - 1 ? 'See results' : 'Next',
                onPressed: _answered ? _next : () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Question {
  const _Question({
    required this.prompt,
    required this.options,
    required this.answer,
  });

  final String prompt;
  final List<String> options;
  final int answer;
}
