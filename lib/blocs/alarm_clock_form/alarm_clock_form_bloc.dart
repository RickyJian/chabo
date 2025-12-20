import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chabo/models/models.dart';
import 'package:chabo/core/core.dart' as core;
import 'dart:convert';
import 'dart:developer';
import 'package:chabo/repositories/reporistories.dart';

part 'alarm_clock_form_event.dart';
part 'alarm_clock_form_state.dart';

class AlarmClockFormBloc extends Bloc<AlarmClockFormEvent, AlarmClockFormState> {
  static const MethodChannel alarmChannel = MethodChannel('chabo/alarm');
  final AlarmClockRepository _repository = AlarmClockRepository();

  AlarmClockFormBloc() : super(AlarmClockFormInitial()) {
    on<AlarmClockDialogOpened>(_onAlarmClockDialogOpened);
    on<AlarmClockFormHourChanged>(_onAlarmClockFormHourChanged);
    on<AlarmClockFormMinuteChanged>(_onAlarmClockFormMinuteChanged);
    on<AlarmClockFormLabelChanged>(_onAlarmClockFormLabelChanged);
    on<AlarmClockDayPeriodPressed>(_onAlarmClockDayPeriodPressed);
    on<AlarmClockFormEnableToggled>(_onAlarmClockFormEnableToggled);
    on<AlarmClockFormWeekdayToggled>(_onAlarmClockFormWeekdayToggled);
    on<AlarmClockFormVibrationToggled>(_onAlarmClockFormVibrationToggled);
    on<AlarmClockFormRingtoneChanged>(_onAlarmClockFormRingtoneChanged);
    on<AlarmClockFormRingtonePlayed>(_onAlarmClockFormRingtonePlayed);
    on<AlarmClockFormRingtoneStopped>(_onAlarmClockFormRingtoneStopped);
    on<AlarmClockFormAdded>(_onAlarmClockFormAdded);
  }

  void _onAlarmClockDialogOpened(AlarmClockDialogOpened event, Emitter<AlarmClockFormState> emit) async {
    emit(AlarmClockFormLoading());

    final ringtones = await fetchSystemRingtones();

    final AlarmClock clock;
    if (event.id case final id?) {
      clock = await _repository.getAlarmClock(id);
    } else {
      clock = AlarmClock.init(TimeOfDay.now())..copyWith(ringtone: ringtones.first);
    }
    emit(AlarmClockFormLoaded(clock: clock, ringtones: ringtones));
  }

  void _onAlarmClockFormHourChanged(AlarmClockFormHourChanged event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(clock: final clock, ringtones: final ringtones)) {
      var hour = int.tryParse(event.value);
      if (hour == null) {
        emit(
          AlarmClockFormLoaded(clock: clock, ringtones: ringtones, errorCode: core.AlarmClockFormErrorCode.hourInvalid),
        );
      } else if (hour < 0 || hour > 23) {
        emit(
          AlarmClockFormLoaded(
            clock: clock,
            ringtones: ringtones,
            errorCode: core.AlarmClockFormErrorCode.hourOutOfRange,
          ),
        );
      } else {
        emit(
          AlarmClockFormLoaded(
            clock: clock.copyWith(hour: hour),
            ringtones: ringtones,
          ),
        );
      }
    }
  }

  void _onAlarmClockFormMinuteChanged(AlarmClockFormMinuteChanged event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(clock: final clock, ringtones: final ringtones)) {
      var minute = int.tryParse(event.value);
      if (minute == null) {
        emit(
          AlarmClockFormLoaded(
            clock: clock,
            ringtones: ringtones,
            errorCode: core.AlarmClockFormErrorCode.minuteInvalid,
          ),
        );
      } else if (minute < 0 || minute > 59) {
        emit(
          AlarmClockFormLoaded(
            clock: clock,
            ringtones: ringtones,
            errorCode: core.AlarmClockFormErrorCode.minuteOutOfRange,
          ),
        );
      } else {
        emit(
          AlarmClockFormLoaded(
            clock: clock.copyWith(minute: minute),
            ringtones: ringtones,
          ),
        );
      }
    }
  }

  void _onAlarmClockFormLabelChanged(AlarmClockFormLabelChanged event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(clock: final clock, ringtones: final ringtones)) {
      var name = event.value.trim();
      if (name.length > 10) {
        emit(
          AlarmClockFormLoaded(
            clock: clock,
            ringtones: ringtones,
            errorCode: core.AlarmClockFormErrorCode.labelOutOfLength,
          ),
        );
      } else {
        emit(
          AlarmClockFormLoaded(
            clock: clock.copyWith(name: name),
            ringtones: ringtones,
          ),
        );
      }
    }
  }

  void _onAlarmClockDayPeriodPressed(AlarmClockDayPeriodPressed event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(clock: final clock, ringtones: final ringtones)) {
      emit(
        AlarmClockFormLoaded(
          clock: clock.togglePeriod(event.index == 0 ? DayPeriod.am : DayPeriod.pm),
          ringtones: ringtones,
        ),
      );
    }
  }

  void _onAlarmClockFormEnableToggled(AlarmClockFormEnableToggled event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(clock: final clock, ringtones: final ringtones)) {
      emit(
        AlarmClockFormLoaded(
          clock: clock.toggleEnable(event.enabled ? core.Status.enabled : core.Status.disabled),
          ringtones: ringtones,
        ),
      );
    }
  }

  void _onAlarmClockFormWeekdayToggled(AlarmClockFormWeekdayToggled event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(clock: final clock, ringtones: final ringtones)) {
      emit(AlarmClockFormLoaded(clock: clock.toggleWeekdays(event.weekday), ringtones: ringtones));
    }
  }

  void _onAlarmClockFormVibrationToggled(AlarmClockFormVibrationToggled event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(clock: final clock, ringtones: final ringtones)) {
      emit(AlarmClockFormLoaded(clock: clock.toggleVibration(event.vibration), ringtones: ringtones));
    }
  }

  void _onAlarmClockFormRingtoneChanged(AlarmClockFormRingtoneChanged event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(clock: final clock, ringtones: final ringtones)) {
      emit(
        AlarmClockFormLoaded(
          clock: clock.copyWith(ringtone: event.ringtone),
          ringtones: ringtones,
        ),
      );
    }
  }

  void _onAlarmClockFormRingtonePlayed(AlarmClockFormRingtonePlayed event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded()) {
      playAlarm(event.ringtone.uri);
    }
  }

  void _onAlarmClockFormRingtoneStopped(AlarmClockFormRingtoneStopped event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded()) {
      stopAlarm();
    }
  }

  Future<List<SystemAlarmRingtone>> fetchSystemRingtones() async => alarmChannel
      .invokeMethod('listSystemAlarms')
      .then((data) {
        if (data is! List) {
          throw Exception('[fetchAlarms] invalid type when invoke method channel listSystemAlarms');
        } else if (data.isEmpty) {
          throw Exception('[fetchAlarms] cannot find system alarms');
        }
        return data;
      })
      .then((array) {
        return List<SystemAlarmRingtone>.generate(
          array.length,
          (i) => SystemAlarmRingtone.fromJson(jsonDecode(array[i])),
        );
      })
      .catchError((error) {
        // TODO: use log package instead
        log(error);
        return <SystemAlarmRingtone>[];
      });

  Future<void> playAlarm(String uri) async =>
      await alarmChannel.invokeMethod('playSystemAlarm', uri).catchError((error) => log(error));

  Future<void> stopAlarm() async =>
      await alarmChannel.invokeMethod('stopSystemAlarm').catchError((error) => log(error));

  Future<void> _onAlarmClockFormAdded(AlarmClockFormAdded event, Emitter<AlarmClockFormState> emit) async {
    if (state case AlarmClockFormLoaded(clock: final clock)) {
      await _repository.createAlarmClock(clock);
      emit(AlarmClockFormSuccess());
    }
  }
}
