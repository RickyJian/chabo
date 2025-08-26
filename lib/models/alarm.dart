import 'package:flutter/material.dart';
import 'package:chabo/core/enums/weekday.dart';
import 'package:chabo/core/enums/status.dart';

class AlarmClock {
  final int id;
  final int hour;
  final int minute;
  final DayPeriod period;
  final String name;
  final List<Weekday> weekdays;
  final Status status;
  final bool vibration;

  // TODO: add diff time, ringtone

  AlarmClock({
    this.id = -1,
    this.hour = 1,
    this.minute = 0,
    this.period = DayPeriod.am,
    this.name = '',
    this.weekdays = Weekday.values,
    this.status = Status.enabled,
    this.vibration = true,
  });

  AlarmClock.init(TimeOfDay t)
    : id = DateTime.now().microsecondsSinceEpoch,
      hour = t.hourOfPeriod,
      minute = t.minute,
      period = t.period,
      name = '',
      weekdays = Weekday.values,
      status = Status.enabled,
      vibration = true;

  AlarmClock copyWith({
    int? id,
    int? hour,
    int? minute,
    DayPeriod? period,
    String? name,
    List<Weekday>? weekdays,
    Status? status,
    bool? vibration,
  }) {
    return AlarmClock(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      period: period ?? this.period,
      name: name ?? this.name,
      weekdays: weekdays ?? this.weekdays,
      status: status ?? this.status,
      vibration: vibration ?? this.vibration,
    );
  }

  AlarmClock toggleEnable(Status status) => copyWith(status: status);

  AlarmClock toggleWeekdays(Weekday weekday) {
    final newWeekdays =
        weekdays.contains(weekday) ? weekdays.where((day) => day != weekday).toList() : [...weekdays, weekday]
          ..sort((a, b) => a.index.compareTo(b.index));
    return copyWith(weekdays: newWeekdays.isEmpty ? Weekday.values.toList() : newWeekdays);
  }
}

// class SystemAlarmComponent {
//   String name;
//   String uri;

//   SystemAlarmComponent({this.name = '', this.uri = ''});

//   factory SystemAlarmComponent.fromJson(Map<String, dynamic> json) {
//     return SystemAlarmComponent(name: json['name'] as String, uri: json['uri'] as String);
//   }
// }
