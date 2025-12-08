import 'package:flutter/material.dart';
import 'package:chabo/core/enums/enums.dart';
import 'package:chabo/repositories/constant.dart' as db_constant;
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

  Map<String, dynamic> toMap() => {
    db_constant.Constant.columnId: id,
    db_constant.Constant.columnHour: hour,
    db_constant.Constant.columnMinute: minute,
    db_constant.Constant.columnPeriod: period.index,
    db_constant.Constant.columnName: name,
    db_constant.Constant.columnWeekdays: Weekday.bitMask(weekdays),
    db_constant.Constant.columnStatus: status.index,
    db_constant.Constant.columnVibration: vibration ? 1 : 0,
    db_constant.Constant.columnRingtoneName: ringtone?.name ?? '',
    db_constant.Constant.columnRingtoneUri: ringtone?.uri ?? '',
  };

  AlarmClock.fromMap(Map<String, dynamic> map)
    : id = map[db_constant.Constant.columnId] as String,
      hour = map[db_constant.Constant.columnHour] as int,
      minute = map[db_constant.Constant.columnMinute] as int,
      period = DayPeriod.values[map[db_constant.Constant.columnPeriod] as int],
      name = map[db_constant.Constant.columnName] as String,
      weekdays = Weekday.fromMask(map[db_constant.Constant.columnWeekdays] as int),
      status = Status.values[map[db_constant.Constant.columnStatus] as int],
      vibration = map[db_constant.Constant.columnVibration] == 1,
      ringtone = map[db_constant.Constant.columnRingtoneName] != null
          ? SystemAlarmRingtone(
              name: map[db_constant.Constant.columnRingtoneName] as String,
              uri: map[db_constant.Constant.columnRingtoneUri] as String,
            )
          : null;

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
