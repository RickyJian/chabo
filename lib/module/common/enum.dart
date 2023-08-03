import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'message.dart';

extension DayPeriodExtension on DayPeriod {
  String get localize {
    switch (this) {
      case DayPeriod.am:
        return Message.dayPeriodAM.tr;
      case DayPeriod.pm:
        return Message.dayPeriodPM.tr;
    }
  }
}

enum Status { enabled, both, disabled }

enum Weekday { sunday, monday, tuesday, wednesday, thursday, friday, saturday }

extension WeekdayExtension on Weekday {
  String get string {
    switch (this) {
      case Weekday.sunday:
        return Message.weekdaySUN.tr;
      case Weekday.monday:
        return Message.weekdayMON.tr;
      case Weekday.tuesday:
        return Message.weekdayTUE.tr;
      case Weekday.wednesday:
        return Message.weekdayWED.tr;
      case Weekday.thursday:
        return Message.weekdayTHU.tr;
      case Weekday.friday:
        return Message.weekdayFRI.tr;
      case Weekday.saturday:
        return Message.weekdaySAT.tr;
    }
  }
}
