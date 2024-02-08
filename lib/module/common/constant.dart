import 'package:flutter/material.dart';

class Constant {
  Constant._();

  /// common
  static const String fontFamily = 'openhuninn';

  /// router
  static const int navigationDuration = 400;

  /// fab
  static const double fabLeftMargin = 3;
  static const double fabBottomMargin = 1.5;

  /// common
  static const double defaultBorderRadius = 10;

  /// dialog constant
  static final double dialogMarginTop = AppBar().preferredSize.height / 2;
  static const double dialogMarginHorizontal = 5;
  static const double dialogElevation = 30;
  static const double dialogBorderRadius = defaultBorderRadius;
  static const double dialogInnerPaddingVertical = 1;
  static const double dialogInnerPaddingHorizontal = 5;
  static const double dialogHeaderHeight = 7;
  static const double dialogContentHeight = 40;
  static const double dialogFooterHeight = 7;
  static const double dialogBorderSectionWidth = 2;
  static const double dialogBorderZeroWidth = 0;
  static const double dialogHeaderFontSize = 16;
  static const double dialogShadowBlurRadius = 2;

  /// dialog footer
  static const double dialogTextFontSize = 14;
  static const double dialogTextButtonPadding = 12;

  /// snackbar
  static const double notificationBorderRadius = 5;
  static const double notificationMarginWidth = 10;
  static const double notificationMarginBottom = 10;
  static const double notificationTextPadding = 2;
  static const double notificationBoxShadowSpreadRadius = 1;
  static const double notificationBoxShadowBlurRadius = 10;
}
