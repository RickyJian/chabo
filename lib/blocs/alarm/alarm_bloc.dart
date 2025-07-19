import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chabo/models/alarm.dart';
import 'package:chabo/core/enums/enums.dart';

part 'alarm_event.dart';
part 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AlarmBloc() : super(AlarmInitial()) {
    on<AlarmListed>(_onAlarmListed);
    on<AlarmEnableToggled>(_onAlarmEnableToggled);
    on<AlarmWeekdayToggled>(_onAlarmWeekdayToggled);
  }

  void _onAlarmListed(AlarmListed event, Emitter<AlarmState> emit) {
    final alarms = List.generate(
      5,
      (i) => Alarm(
        id: i,
        hour: 12,
        minute: 10,
        name: 'label $i',
        period: DayPeriod.am,
        status: Status.enabled,
        weekdays: Weekday.values.toList(),
      ),
    );

    emit(AlarmLoaded(alarms: alarms));
  }

  void _onAlarmEnableToggled(AlarmEnableToggled event, Emitter<AlarmState> emit) {
    if (state case AlarmLoaded(alarms: final alarms)) {
      final updatedAlarms = alarms
          .map(
            (alarm) => alarm.id == event.alarm.id
                ? alarm.toggleEnable(event.enabled ? Status.enabled : Status.disabled)
                : alarm,
          )
          .toList();

      emit(AlarmLoaded(alarms: updatedAlarms));
    }
  }

  void _onAlarmWeekdayToggled(AlarmWeekdayToggled event, Emitter<AlarmState> emit) {
    if (state case AlarmLoaded(alarms: final alarms)) {
      final alarm = alarms.firstWhere((alarm) => alarm.id == event.alarm.id);
      if (event.message?.isNotEmpty == true && (alarm.weekdays.length <= 1 && alarm.weekdays.contains(event.weekday))) {
        emit(AlarmSnackbarLoaded(message: event.message!));
      }

      final updatedAlarms = alarms
          .map((alarm) => alarm.id == event.alarm.id ? alarm.toggleWeekdays(event.weekday) : alarm)
          .toList();

      emit(AlarmLoaded(alarms: updatedAlarms));
    }
  }
}
