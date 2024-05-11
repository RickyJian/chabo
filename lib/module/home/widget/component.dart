import 'package:flutter/material.dart';
import 'package:chabo/module/common/common.dart' as cmn;

class ClockComponent {
  int id;
  int hour;
  int minute;
  DayPeriod period;
  String name;
  List<cmn.Weekday> weekdays;
  cmn.Status status;
  bool vibration;

  // TODO: add diff time, ringtone

  ClockComponent(
      {this.id = -1,
      this.hour = 1,
      this.minute = 0,
      this.period = DayPeriod.am,
      this.name = '',
      this.weekdays = cmn.Weekday.values,
      this.status = cmn.Status.enabled,
      this.vibration = true});

  ClockComponent.init(TimeOfDay t)
      : id = DateTime.now().microsecondsSinceEpoch,
        hour = t.hourOfPeriod,
        minute = t.minute,
        period = t.period,
        name = '',
        weekdays = cmn.Weekday.values,
        status = cmn.Status.enabled,
        vibration = true;

  toggleWeekdays(cmn.Weekday weekday) {
    if (weekdays.contains(weekday)) {
      weekdays.remove(weekday);
    } else {
      weekdays.add(weekday);
      weekdays.sort((left, right) {
        if (left.index < right.index) {
          return -1;
        } else if (left.index == right.index) {
          return 0;
        }
        // left.index > right.index
        return 1;
      });
    }
    if (weekdays.isEmpty) {
      weekdays.addAll(cmn.Weekday.values);
    }
  }

  bool isWeekdaysEmpty(cmn.Weekday weekday) => !(weekdays.length > 1 || !weekdays.contains(weekday));

  toggleEnable(cmn.Status status) => this.status = status;

  onPressDayPeriod(int index) => index == 0 ? period = DayPeriod.am : period = DayPeriod.pm;
}

class AlarmComponent {
  String name;
  String uri;

  AlarmComponent({required this.name, required this.uri});

  factory AlarmComponent.fromJson(Map<String, dynamic> json) {
    return AlarmComponent(
      name: json['name'] as String,
      uri: json['uri'] as String,
    );
  }
}
