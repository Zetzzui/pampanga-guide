import 'package:material_ui/material_ui.dart';

import '../widgets/ui_kit.dart';
import 'learn_screen.dart';
import 'places_screen.dart';
import 'quiz_screen.dart';
import 'saved_screen.dart';

/// Holds the tab screens (Places, Learn, Quiz, Saved) under one fixed
/// bottom nav.
///
/// Switching tabs only swaps the content, so the nav bar never moves and
/// each tab keeps its scroll position and loaded data.
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialTab = places});

  // Tab numbers, in nav bar order.
  static const places = 0;
  static const learn = 1;
  static const quiz = 2;
  static const saved = 3;

  final int initialTab;

  /// The selected tab. Shared so any screen can switch tabs.
  static final tab = ValueNotifier<int>(places);

  /// Switch to [index] from anywhere, closing screens opened on top
  /// (e.g. Results -> "Back to Learn").
  static void goTo(BuildContext context, int index) {
    tab.value = index;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  void initState() {
    super.initState();
    MainShell.tab.value = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MainShell.tab,
      builder: (context, index, _) {
        return Scaffold(
          // IndexedStack keeps every tab alive, so nothing reloads.
          body: IndexedStack(
            index: index,
            children: const [
              PlacesScreen(),
              LearnScreen(),
              QuizScreen(), // Figma: Quiz and Results keep the nav visible.
              SavedScreen(),
            ],
          ),
          bottomNavigationBar: AppBottomNav(
            index: index,
            onTap: (i) {
              if (i != index) MainShell.goTo(context, i);
            },
          ),
        );
      },
    );
  }
}
