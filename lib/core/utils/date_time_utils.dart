import 'package:flutter/material.dart';

class DateTimeUtils {
  static TimeOfDay getDayOfTime({DateTime? time, Duration? duration}) {
    time ??= DateTime.now();
    return TimeOfDay.fromDateTime(time.add(duration ?? Duration.zero));
  }

  static DayPeriod getDayPeriod({DateTime? time, Duration? duration}) {
    time ??= DateTime.now();
    return TimeOfDay.fromDateTime(time.add(duration ?? Duration.zero)).period;
  }

  static int getHour({DateTime? time, Duration? duration}) {
    time ??= DateTime.now();
    return TimeOfDay.fromDateTime(time.add(duration ?? Duration.zero)).hourOfPeriod;
  }

  static int getMinute({DateTime? time, Duration? duration}) {
    time ??= DateTime.now();
    return TimeOfDay.fromDateTime(time.add(duration ?? Duration.zero)).minute;
  }
} 