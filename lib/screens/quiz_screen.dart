import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'main_shell.dart';
import 'results_screen.dart';

/// One multiple-choice question: what does [phrase] mean?
class QuizQuestion {
  const QuizQuestion({
    required this.phrase,
    required this.meaning,
    required this.options,
    required this.answer,
  });

  /// Kapampangan phrase, e.g. "Mayap a abak".
  final String phrase;

  /// English meaning, e.g. "Good morning".
  final String meaning;
  final List<String> options;

  /// Index of the correct option.
  final int answer;
}

/// Quiz tab (Figma: "Test your words" frames).
///
/// Shows the question, then green/red feedback, then Results in the same
/// tab so the bottom nav stays visible.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Figma quiz content.
  // TODO: verify with a Kapampangan speaker, then load from Firestore phrases.
  static const _questions = [
    QuizQuestion(
      phrase: 'Mayap a abak',
      meaning: 'Good morning',
      options: ['Good evening', 'Good morning', 'Thank you', 'Delicious'],
      answer: 1,
    ),
  ];

  int _index = 0;
  int _correct = 0;
  int? _selected;
  bool _showResults = false;

  bool get _answered => _selected != null;
  bool get _isLast => _index == _questions.length - 1;

  void _choose(int option) {
    if (_answered) return;
    setState(() {
      _selected = option;
      if (option == _questions[_index].answer) _correct++;
    });
  }

  void _next() {
    setState(() {
      if (_isLast) {
        _showResults = true;
      } else {
        _index++;
        _selected = null;
      }
    });
  }

  /// Start the quiz again from the first question.
  void _restart() {
    setState(() {
      _index = 0;
      _correct = 0;
      _selected = null;
      _showResults = false;
    });
  }

  /// Leave the quiz for the Learn tab. The quiz starts fresh next time.
  void _goToLearn() {
    _restart();
    MainShell.goTo(context, MainShell.learn);
  }

  @override
  Widget build(BuildContext context) {
    if (_showResults) {
      return ResultsScreen(
        score: _correct,
        total: _questions.length,
        lastQuestion: _questions[_index],
        onTryAgain: _restart,
        onPractice: _goToLearn,
        onReview: _goToLearn,
      );
    }

    final c = AppPalette.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final question = _questions[_index];
    final total = _questions.length;
    // Figma: 0% before answering, 100% after the last answer.
    final done = _index + (_answered ? 1 : 0);
    final percent = (done / total * 100).round();
    final isCorrect = _answered && _selected == question.answer;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Text(
              'QUICK QUIZ • $total ${total == 1 ? 'QUESTION' : 'QUESTIONS'}',
              // Accent is too dim on the dark background, so use ink there.
              style: AppText.label.copyWith(color: dark ? c.ink : c.accent),
            ),
            const SizedBox(height: 4),
            Text('Test your words', style: AppText.h1.copyWith(color: c.ink)),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Score $_correct / $total',
                    style: AppText.body.copyWith(color: c.muted),
                  ),
                ),
                Text(
                  '$percent%',
                  style: AppText.small.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: c.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: done / total,
                minHeight: 6,
                backgroundColor: c.line,
                valueColor: AlwaysStoppedAnimation(c.accent),
                semanticsLabel: 'Quiz progress',
                semanticsValue: '$percent percent',
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'What does this mean?',
              style: AppText.body.copyWith(fontSize: 15, color: c.muted),
            ),
            const SizedBox(height: 2),
            Text(
              '“${question.phrase}”',
              style: AppText.h2.copyWith(fontSize: 26, color: c.ink),
            ),
            const SizedBox(height: 16),
            ...List.generate(question.options.length, (i) {
              var state = _OptionState.neutral;
              if (_answered && i == question.answer) {
                state = _OptionState.correct;
              } else if (_answered && i == _selected) {
                state = _OptionState.wrong;
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AnswerOption(
                  label: question.options[i],
                  state: state,
                  onTap: _answered ? null : () => _choose(i),
                ),
              );
            }),
            const SizedBox(height: 4),
            if (!_answered)
              Text(
                'Choose one answer. You can learn from every try.',
                style: AppText.small.copyWith(fontSize: 13, color: c.muted),
              )
            else ...[
              _Feedback(correct: isCorrect, question: question),
              const SizedBox(height: 16),
              PrimaryButton(
                label: _isLast ? 'See my results' : 'Next question',
                onPressed: _next,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum _OptionState { neutral, correct, wrong }

/// One answer card. Figma: white card; green with ✓ if right, red if wrong.
class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.label,
    required this.state,
    required this.onTap,
  });

  final String label;
  final _OptionState state;

  /// Null once the question is answered.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    final (background, border, text) = switch (state) {
      _OptionState.correct => (c.successSoft, c.success, c.success),
      _OptionState.wrong => (c.errorSoft, c.error, c.error),
      _OptionState.neutral => (c.surface, c.line, c.ink),
    };
    final stateLabel = switch (state) {
      _OptionState.correct => ', correct answer',
      _OptionState.wrong => ', your answer, wrong',
      _OptionState.neutral => '',
    };
    return Semantics(
      button: onTap != null,
      label: '$label$stateLabel',
      excludeSemantics: true,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: border,
            width: state == _OptionState.neutral ? 1 : 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 52), // 48dp+
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            child: Text(
              state == _OptionState.correct ? '✓  $label' : label,
              style: AppText.body.copyWith(fontSize: 16, color: text),
            ),
          ),
        ),
      ),
    );
  }
}

/// Green or red box under the answers.
class _Feedback extends StatelessWidget {
  const _Feedback({required this.correct, required this.question});

  final bool correct;
  final QuizQuestion question;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    final ink = correct ? c.success : c.error;
    return Semantics(
      liveRegion: true, // read out when it appears
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        decoration: BoxDecoration(
          color: correct ? c.successSoft : c.errorSoft,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              correct ? 'Correct — a good start!' : 'Not quite — keep learning.',
              style: AppText.body.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '“${question.phrase}” means “${question.meaning}”.',
              style: AppText.small.copyWith(fontSize: 13, color: ink),
            ),
          ],
        ),
      ),
    );
  }
}
