import 'package:flutter/services.dart';

class TimeRangeFormatter extends TextInputFormatter {
  final int max;
  final int min;
  final int? fallback;

  const TimeRangeFormatter({this.max = 59, this.min = 0, this.fallback});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return TextEditingValue(
        text: fallback?.toString() ?? '',
        selection: TextSelection.collapsed(offset: fallback?.toString().length ?? 0),
      );
    }
    var val = int.tryParse(newValue.text);
    if ((val == null) || (val > max)) {
      return oldValue;
    } else if ((val < min)) {
      var minStr = min.toString();
      return TextEditingValue(
        text: minStr,
        selection: TextSelection.collapsed(offset: minStr.length),
      );
    }
    return newValue;
  }
}
