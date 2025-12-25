import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextEditComponent {
  final TextEditingController controller;
  final bool autoFocus;
  final FocusNode? node;
  final Function(String value)? onChanged;
  final FocusNode? nextNode;

  TextEditComponent({required this.controller, this.autoFocus = false, this.node, this.nextNode, this.onChanged});
}

class TimeRangeFormatter extends TextInputFormatter {
  final int max;
  final int min;
  final int? fallback;

  const TimeRangeFormatter({this.max = 59, this.min = 0, this.fallback});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      // 若無輸入資訊直接回傳 fallback 值
      final coalesce = fallback?.toString() ?? min.toString();
      return TextEditingValue(text: coalesce, selection: TextSelection.collapsed(offset: 0));
    }

    String text;
    if (oldValue.selection.baseOffset == 0) {
      // 若 cursor 在開頭：保留輸入資料清空後面的所有資訊
      text = newValue.text[0];
    } else if (oldValue.selection.baseOffset == 1 && newValue.text.length < oldValue.text.length) {
      // 若 cursor 在中間或最後，且執行刪除動作，保留第一位資訊
      text = newValue.text[0];
    } else if (newValue.text.length < 2) {
      // 若輸入資料長度小於 2，保留輸入資料
      text = newValue.text;
    } else {
      // 若輸入資料長度大於等於 2，保留前兩位資訊
      text = newValue.text.substring(0, 2);
    }

    // 若超出則設為最大或最小值
    var value = int.parse(text);
    if (value > max) {
      value = max;
    } else if (value < min) {
      value = min;
    }
    text = value.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
