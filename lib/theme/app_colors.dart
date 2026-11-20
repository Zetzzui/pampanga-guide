import 'package:material_ui/material_ui.dart';

/// LOCALINGO colours, named after the Figma colour tokens (color/...).
///
/// Screens should read colours with `AppPalette.of(context)` so they follow
/// the light or dark theme. The static values below are the light theme.
class AppColors {
  const AppColors._();

  // ---- Figma tokens (light theme) ----
  static const background = Color(0xFFF6F3E7); // page background (cream)
  static const surface = Color(0xFFFFFFFF); // cards, search field
  static const accent = Color(0xFF253C74); // buttons, selected chip
  static const onAccent = Color(0xFFFFFFFF); // text on accent
  static const ink = Color(0xFF1F2E55); // headings and body text
  static const muted = Color(0xFF59627A); // secondary text (AA on cream)
  static const soft = Color(0xFFE5E9F3); // secondary buttons, phrase box
  static const line = Color(0xFFC6CAD5); // borders
  static const highlight = Color(0xFFF2CB57); // yellow
  static const onHighlight = Color(0xFF1F2E55); // text on yellow
  static const heritageHeroSurface = Color(0xFF253C74); // Places header
  static const heritageHeroInk = Color(0xFFFFFFFF); // text on header
  // Quiz feedback (sampled from the Figma quiz frames, AA on their soft).
  static const success = Color(0xFF27613C); // green text and border
  static const successSoft = Color(0xFFE6F2E7); // green background
  static const error = Color(0xFFA73132); // red text and border
  static const errorSoft = Color(0xFFFCEAEA); // red background

  // ---- Illustration colours (Canva art, not Figma tokens) ----
  static const orange = Color(0xFFE07A1F);
  static const brown = Color(0xFF3B2A1A);

  // ---- Old names, kept so screens not yet updated still build. ----
  // TODO: replace these with AppPalette.of(context) screen by screen.
  static const cream = background;
  static const navy = ink;
  static const yellow = highlight;
  static const grey = muted;
  static const card = soft;
  static const blueTint = soft;
}

/// Theme-aware colours. Registered in main.dart for light and dark themes.
///
/// Usage: `final c = AppPalette.of(context); ... color: c.ink`
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.accent,
    required this.onAccent,
    required this.ink,
    required this.muted,
    required this.soft,
    required this.line,
    required this.highlight,
    required this.onHighlight,
    required this.heroSurface,
    required this.heroInk,
    required this.success,
    required this.successSoft,
    required this.error,
    required this.errorSoft,
  });

  final Color background;
  final Color surface;
  final Color accent;
  final Color onAccent;
  final Color ink;
  final Color muted;
  final Color soft;
  final Color line;
  final Color highlight;
  final Color onHighlight;
  final Color heroSurface;
  final Color heroInk;
  final Color success;
  final Color successSoft;
  final Color error;
  final Color errorSoft;

  /// Light theme: exact Figma token values.
  static const light = AppPalette(
    background: AppColors.background,
    surface: AppColors.surface,
    accent: AppColors.accent,
    onAccent: AppColors.onAccent,
    ink: AppColors.ink,
    muted: AppColors.muted,
    soft: AppColors.soft,
    line: AppColors.line,
    highlight: AppColors.highlight,
    onHighlight: AppColors.onHighlight,
    heroSurface: AppColors.heritageHeroSurface,
    heroInk: AppColors.heritageHeroInk,
    success: AppColors.success,
    successSoft: AppColors.successSoft,
    error: AppColors.error,
    errorSoft: AppColors.errorSoft,
  );

  /// Dark theme: built from the Figma colours (Figma has no dark set yet).
  /// TODO: replace with Figma dark tokens if the designer adds them.
  /// All text pairs below pass WCAG AA (4.5:1) on their backgrounds.
  static const dark = AppPalette(
    background: Color(0xFF111522),
    surface: Color(0xFF1B2133),
    accent: Color(0xFF3A56A0), // white text on it: about 7:1
    onAccent: Color(0xFFFFFFFF),
    ink: Color(0xFFEEF1F8),
    muted: Color(0xFFA9B2C7),
    soft: Color(0xFF263049),
    line: Color(0xFF3A4560),
    highlight: Color(0xFFF2CB57),
    onHighlight: Color(0xFF1F2E55),
    heroSurface: Color(0xFF22335F),
    heroInk: Color(0xFFFFFFFF),
    success: Color(0xFF93D3A6),
    successSoft: Color(0xFF17321F),
    error: Color(0xFFF4A9A9),
    errorSoft: Color(0xFF3B1D21),
  );

  /// The palette for the current theme. Falls back to light.
  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>() ?? light;

  @override
  AppPalette copyWith({
    Color? background,
    Color? surface,
    Color? accent,
    Color? onAccent,
    Color? ink,
    Color? muted,
    Color? soft,
    Color? line,
    Color? highlight,
    Color? onHighlight,
    Color? heroSurface,
    Color? heroInk,
    Color? success,
    Color? successSoft,
    Color? error,
    Color? errorSoft,
  }) {
    return AppPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      ink: ink ?? this.ink,
      muted: muted ?? this.muted,
      soft: soft ?? this.soft,
      line: line ?? this.line,
      highlight: highlight ?? this.highlight,
      onHighlight: onHighlight ?? this.onHighlight,
      heroSurface: heroSurface ?? this.heroSurface,
      heroInk: heroInk ?? this.heroInk,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      error: error ?? this.error,
      errorSoft: errorSoft ?? this.errorSoft,
    );
  }

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      soft: Color.lerp(soft, other.soft, t)!,
      line: Color.lerp(line, other.line, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      onHighlight: Color.lerp(onHighlight, other.onHighlight, t)!,
      heroSurface: Color.lerp(heroSurface, other.heroSurface, t)!,
      heroInk: Color.lerp(heroInk, other.heroInk, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorSoft: Color.lerp(errorSoft, other.errorSoft, t)!,
    );
  }
}
