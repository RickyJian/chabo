import 'package:flutter/material.dart';

class DeviceModel {
  DeviceModel._internal();

  static DeviceModel? _instance;
  MediaQueryData? _mediaQuery;

  factory DeviceModel.init({required BuildContext context}) {
    _instance ??= DeviceModel._internal();
    _instance!._mediaQuery = MediaQuery.of(context);
    return _instance!;
  }

  static double get screenHeight => _instance?._mediaQuery?.size.height ?? 0;

  static double get statusBarHeight => _instance?._mediaQuery?.viewPadding.top ?? 0;

  static double get bottomSafeAreaHeight => _instance?._mediaQuery?.viewPadding.bottom ?? 0;

  static double get devicePixelRatio => _instance?._mediaQuery?.devicePixelRatio ?? 0;
}
