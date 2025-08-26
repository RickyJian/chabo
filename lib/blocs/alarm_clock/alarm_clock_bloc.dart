import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chabo/models/alarm.dart';
import 'package:chabo/core/enums/enums.dart';
import 'package:chabo/core/widgets/widgets.dart';

part 'alarm_clock_event.dart';
part 'alarm_clock_state.dart';

class AlarmClockBloc extends Bloc<AlarmClockEvent, AlarmClockState> {
  AlarmClockBloc() : super(AlarmClockInitial()) {
    on<AlarmClockListed>(_onAlarmClockListed);
    // on<AlarmClockDialogOpened>(_onAlarmClockDialogOpened);
    on<AlarmClockEnableToggled>(_onAlarmClockEnableToggled);
    on<AlarmClockWeekdayToggled>(_onAlarmClockWeekdayToggled);
  }

  void _onAlarmClockListed(AlarmClockListed event, Emitter<AlarmClockState> emit) {
    final alarms = List.generate(
      5,
      (i) => AlarmClock(
        id: i,
        hour: 12,
        minute: 10,
        name: 'label $i',
        period: DayPeriod.am,
        status: Status.enabled,
        weekdays: Weekday.values.toList(),
      ),
    );

    emit(AlarmClockListLoaded(alarms: alarms));
  }

  // void _onAlarmClockDialogOpened(AlarmClockDialogOpened event, Emitter<AlarmClockState> emit) {
  //   emit(AlarmClockDialogLoaded(alarm: event.alarm));
  // }

  void _onAlarmClockEnableToggled(AlarmClockEnableToggled event, Emitter<AlarmClockState> emit) {
    if (state case AlarmClockListLoaded(alarms: final alarms)) {
      final updatedAlarms = alarms
          .map(
            (alarm) => alarm.id == event.alarm.id
                ? alarm.toggleEnable(event.enabled ? Status.enabled : Status.disabled)
                : alarm,
          )
          .toList();

      emit(AlarmClockListLoaded(alarms: updatedAlarms));
    }
  }

  void _onAlarmClockWeekdayToggled(AlarmClockWeekdayToggled event, Emitter<AlarmClockState> emit) {
    if (state case AlarmClockListLoaded(alarms: final alarms)) {
      final alarm = alarms.firstWhere((alarm) => alarm.id == event.alarm.id);
      if (event.message?.isNotEmpty == true && (alarm.weekdays.length <= 1 && alarm.weekdays.contains(event.weekday))) {
        emit(AlarmClockSnackbarLoaded(message: event.message!));
      }

      final updatedAlarms = alarms
          .map((alarm) => alarm.id == event.alarm.id ? alarm.toggleWeekdays(event.weekday) : alarm)
          .toList();

      emit(AlarmClockListLoaded(alarms: updatedAlarms));
    }
  }
}
