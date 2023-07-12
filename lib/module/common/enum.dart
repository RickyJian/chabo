import 'package:get/get.dart';

import 'message.dart';

enum TimeSection { am, pm }

extension TimeSectionExtension on TimeSection {
  String get string {
    switch (this) {
      case TimeSection.am:
        return Message.clockTimeSectionAM.tr;
      case TimeSection.pm:
        return Message.clockTimeSectionPM.tr;
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
