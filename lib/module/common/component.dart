import 'package:flutter/material.dart';

class TextEditComponent {
  final TextEditingController controller;
  final bool autoFocus;
  final FocusNode? node;
  FocusNode? nextNode;

  TextEditComponent({required this.controller, this.autoFocus = false, this.node, this.nextNode});
}
