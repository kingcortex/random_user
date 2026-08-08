import 'package:flutter/widgets.dart';

class Spacing {
  Spacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;

  static const EdgeInsets pagePadding = EdgeInsets.all(xl);
  static const EdgeInsets bannerPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );
  static const EdgeInsets sectionVertical = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets tileContent = EdgeInsets.symmetric(
    horizontal: xs,
    vertical: xxs,
  );
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: sm,
  );
}
