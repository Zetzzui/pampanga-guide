import 'package:material_ui/material_ui.dart';

import '../theme/app_colors.dart';

/// Reusable LOCALINGO widgets used by more than one screen.
///
/// Colours come from `AppPalette.of(context)`, so every widget here works in
/// both the light and dark theme.
class FoodIllustration extends StatelessWidget {
  const FoodIllustration({super.key, this.height = 280});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: ColoredBox(
          color: AppColors.yellow,
          child: Stack(
            children: [
              // TODO: replace with the exported Canva illustration.
              Positioned(
                top: height * 0.10,
                left: 24,
                child: Icon(
                  Icons.wb_sunny_rounded,
                  size: height * 0.16,
                  color: AppColors.orange,
                ),
              ),
              Positioned(
                top: height * 0.14,
                right: 28,
                child: Container(
                  width: height * 0.17,
                  height: height * 0.44,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(height * 0.09),
                    ),
                  ),
                ),
              ),
              Center(
                child: Icon(
                  Icons.ramen_dining_rounded,
                  size: height * 0.48,
                  color: AppColors.brown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main action button (Figma: accent fill, white text).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: c.onAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(label),
          ],
        ),
      ),
    );
  }
}

/// Second action button (Figma: soft fill, ink text).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: c.soft,
          foregroundColor: c.ink,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}

/// Onboarding page indicator.
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Semantics(
      label: 'Page ${index + 1} of $count',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == index ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == index ? c.accent : c.line,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}

/// Filter chip (Figma: accent when selected, outlined surface otherwise).
/// The visible pill is 36dp tall inside a 48dp touch target.
class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 48, // 48dp touch target
          child: Center(
            child: Container(
              height: 44, // Figma chip height
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? c.accent : c.surface,
                border: Border.all(color: selected ? c.accent : c.line),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: selected ? c.onAccent : c.ink,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Centered spinner shown while a screen loads its data.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, required this.label});

  /// Read aloud by screen readers, e.g. "Loading places".
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Semantics(
          label: label,
          child: CircularProgressIndicator(color: c.accent),
        ),
      ),
    );
  }
}

/// Icon, title, message, and an optional button.
/// Used for error, offline, empty, and no-results states on every screen.
class StatusMessage extends StatelessWidget {
  const StatusMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 40, color: c.ink),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: c.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: c.muted),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 48, // 48dp touch target
              child: FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: c.accent,
                  foregroundColor: c.onAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Banner shown when data comes from the phone's cache (no internet).
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: c.soft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi_off, size: 18, color: c.ink),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "You're offline. Showing saved data.",
              style: TextStyle(fontSize: 13, color: c.ink),
            ),
          ),
          SizedBox(
            height: 48, // 48dp touch target
            child: TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(foregroundColor: c.ink),
              child: const Text(
                'Retry',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom tabs: Places, Learn, Quiz, Saved.
/// Figma: the selected tab sits on a soft rounded square.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    ('Places', Icons.place_outlined, Icons.place),
    ('Learn', Icons.menu_book_outlined, Icons.menu_book),
    ('Quiz', Icons.emoji_events_outlined, Icons.emoji_events), // trophy
    ('Saved', Icons.star_border, Icons.star),
  ];

  @override
  Widget build(BuildContext context) {
    final c = AppPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.surface, // Figma: white bar with a thin top line
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final selected = i == index;
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: selected,
                  label: '${item.$1} tab',
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      // Figma: selected tab = wide soft rounded rectangle.
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected ? c.soft : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              selected ? item.$3 : item.$2,
                              size: 22,
                              color: selected ? c.ink : c.muted,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.$1,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected ? c.ink : c.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
