import 'package:material_ui/material_ui.dart';

/// Shared text styles, matching the Figma type.
///
/// Headings use Lora Medium (confirmed in Figma); everything else uses
/// DM Sans. Both fonts are bundled in assets/fonts (see pubspec.yaml).
class AppText {
  const AppText._();

  /// Heading font family.
  static const serif = 'Lora';

  /// Body font family. Also set as the app default in main.dart.
  static const sans = 'DMSans';

  static const display = TextStyle(
    fontFamily: serif,
    fontSize: 34,
    height: 1.1,
    fontWeight: FontWeight.w500,
  );

  /// Page titles. Figma: Lora Medium 28, line height 40, letter spacing -2%.
  static const h1 = TextStyle(
    fontFamily: serif,
    fontSize: 28,
    height: 40 / 28,
    letterSpacing: 28 * -0.02,
    fontWeight: FontWeight.w500,
  );

  static const h2 = TextStyle(
    fontFamily: serif,
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );

  static const h3 = TextStyle(
    fontFamily: serif,
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );

  static const body = TextStyle(fontFamily: sans, fontSize: 14, height: 1.45);

  static const small = TextStyle(fontFamily: sans, fontSize: 12, height: 1.35);

  static const label = TextStyle(
    fontFamily: sans,
    fontSize: 11,
    letterSpacing: 0.6,
    fontWeight: FontWeight.w700,
  );
}
