import 'package:flutter/material.dart';
import 'package:chabo/core/enums/enums.dart';
import 'package:ulid/ulid.dart';
import 'ringtone.dart';

class AlarmClock {
  final String id;
  final int hour;
  final int minute;
  final DayPeriod period;
  final String name;
  final List<Weekday> weekdays;
  final Status status;
  final bool vibration;
  final AlarmRingtone? ringtone;

  AlarmClock({
    String? id,
    int? hour,
    int? minute,
    DayPeriod? period,
    String? name,
    List<Weekday>? weekdays,
    Status? status,
    bool? vibration,
    AlarmRingtone? ringtone,
  }) : id = id ?? Ulid().toString(),
       hour = hour ?? 1,
       minute = minute ?? 0,
       period = period ?? DayPeriod.am,
       name = name ?? '',
       weekdays = weekdays ?? Weekday.values,
       status = status ?? Status.enabled,
       vibration = vibration ?? true,
       ringtone = ringtone ?? null;

  AlarmClock.init(TimeOfDay t)
    : id = Ulid().toString(),
      hour = t.hourOfPeriod,
      minute = t.minute,
      period = t.period,
      name = '',
      weekdays = Weekday.values,
      status = Status.enabled,
      vibration = true,
      ringtone = null;

  AlarmClock copyWith({
    String? id,
    int? hour,
    int? minute,
    DayPeriod? period,
    String? name,
    List<Weekday>? weekdays,
    Status? status,
    bool? vibration,
    AlarmRingtone? ringtone,
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
      ringtone: ringtone ?? this.ringtone,
    );
  }

  AlarmClock togglePeriod(DayPeriod period) => copyWith(period: period);

  AlarmClock toggleVibration(bool vibration) => copyWith(vibration: vibration);

  AlarmClock toggleEnable(Status status) => copyWith(status: status);

  AlarmClock toggleWeekdays(Weekday weekday) {
    final newWeekdays =
        weekdays.contains(weekday) ? weekdays.where((day) => day != weekday).toList() : [...weekdays, weekday]
          ..sort((a, b) => a.index.compareTo(b.index));
    return copyWith(weekdays: newWeekdays.isEmpty ? Weekday.values.toList() : newWeekdays);
  }
}
