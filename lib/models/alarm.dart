import 'package:flutter/material.dart';
import 'package:chabo/core/enums/weekday.dart';
import 'package:chabo/core/enums/status.dart';

class Alarm {
  final int id;
  final int hour;
  final int minute;
  final DayPeriod period;
  final String name;
  final List<Weekday> weekdays;
  final Status status;
  final bool vibration;

  // TODO: add diff time, ringtone

  Alarm({
    this.id = -1,
    this.hour = 1,
    this.minute = 0,
    this.period = DayPeriod.am,
    this.name = '',
    this.weekdays = Weekday.values,
    this.status = Status.enabled,
    this.vibration = true,
  });

  Alarm.init(TimeOfDay t)
    : id = DateTime.now().microsecondsSinceEpoch,
      hour = t.hourOfPeriod,
      minute = t.minute,
      period = t.period,
      name = '',
      weekdays = Weekday.values,
      status = Status.enabled,
      vibration = true;

  Alarm copyWith({
    int? id,
    int? hour,
    int? minute,
    DayPeriod? period,
    String? name,
    List<Weekday>? weekdays,
    Status? status,
    bool? vibration,
  }) {
    return Alarm(
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

  Alarm toggleEnable(Status status) => copyWith(status: status);

  Alarm toggleWeekdays(Weekday weekday) {
    final newWeekdays =
        weekdays.contains(weekday) ? weekdays.where((day) => day != weekday).toList() : [...weekdays, weekday]
          ..sort((a, b) => a.index.compareTo(b.index));
    return copyWith(weekdays: newWeekdays.isEmpty ? Weekday.values.toList() : newWeekdays);
  }
}
