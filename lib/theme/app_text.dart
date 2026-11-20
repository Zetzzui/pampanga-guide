import 'package:material_ui/material_ui.dart';

/// Shared text styles. Headings use a serif face like the design.
class AppText {
  const AppText._();

  static const display = TextStyle(
    fontFamily: 'serif',
    fontSize: 34,
    height: 1.1,
    fontWeight: FontWeight.w600,
  );

  static const h1 = TextStyle(
    fontFamily: 'serif',
    fontSize: 30,
    height: 1.15,
    fontWeight: FontWeight.w600,
  );

  static const h2 = TextStyle(
    fontFamily: 'serif',
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const h3 = TextStyle(
    fontFamily: 'serif',
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(fontSize: 14, height: 1.45);

  static const small = TextStyle(fontSize: 12, height: 1.35);

  static const label = TextStyle(
    fontSize: 11,
    letterSpacing: 1.6,
    fontWeight: FontWeight.w600,
  );
}
