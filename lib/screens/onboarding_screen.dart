import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/ui_kit.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    _OnboardingPage(
      step: '01 / TASTE',
      title: 'Find your next\nfavorite table.',
      body: 'Explore local food in Angeles, San Fernando, and beyond.',
    ),
    _OnboardingPage(
      step: '02 / SPEAK',
      title: 'A few words.\nA warmer welcome.',
      body: 'Learn useful Kapampangan phrases, one little lesson at a time.',
    ),
    _OnboardingPage(
      step: '03 / KEEP',
      title: 'Bring your\nfavorites along.',
      body:
          'Save restaurants for later and build a food trail with your '
          'favorites.',
    ),
  ];

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _finish() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LOCALINGO',
                    style: AppText.small.copyWith(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                  TextButton(
                    onPressed: _finish,
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: AppColors.navy),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, i) => _PageContent(page: _pages[i]),
                ),
              ),
              PageDots(count: _pages.length, index: _index),
              const SizedBox(height: 20),
              PrimaryButton(
                label: _index == _pages.length - 1 ? 'Get started' : 'Next',
                onPressed: _next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FoodIllustration(height: 250),
          const SizedBox(height: 28),
          Text(
            page.step,
            style: AppText.label.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 10),
          Text(page.title, style: AppText.h1.copyWith(color: AppColors.navy)),
          const SizedBox(height: 12),
          Text(page.body, style: AppText.body.copyWith(color: AppColors.grey)),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.step,
    required this.title,
    required this.body,
  });

  final String step;
  final String title;
  final String body;
}
