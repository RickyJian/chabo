import 'package:flutter/material.dart';

class DialogModel {
  final String title;
  final double titleHeight;
  final Widget? contents;
  final double contentHeight;
  final double fallbackHeight;
  final Widget? footer;
  final double? footerHeight;

  const DialogModel({
    required this.title,
    required this.titleHeight,
    this.contents,
    required this.contentHeight,
    required this.fallbackHeight,
    this.footer,
    this.footerHeight,
  }) : assert(titleHeight > 0, 'titleHeight must be greater than 0'),
       assert(contentHeight > 0, 'contentHeight must be greater than 0'),
       assert(
         footer != null ? (footerHeight != null && footerHeight > 0) : footerHeight == 0,
         '1. footer != null then footerHeight > 0\n2. footer == null  then footerHeight = 0',
       );

  DialogModel copyWith({
    String? title,
    double? titleHeight,
    Widget? contents,
    double? contentHeight,
    double? fallbackHeight,
    Widget? footer,
    double? footerHeight,
    MediaQueryData? mediaQueryData,
  }) {
    return DialogModel(
      title: title ?? this.title,
      titleHeight: titleHeight ?? this.titleHeight,
      contents: contents ?? this.contents,
      contentHeight: contentHeight ?? this.contentHeight,
      fallbackHeight: fallbackHeight ?? this.fallbackHeight,
      footer: footer ?? this.footer,
      footerHeight: footerHeight ?? this.footerHeight,
    );
  }
}
