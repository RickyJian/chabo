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

    if (event.form case final form?) {
      emit(
        AlarmClockFormLoaded(
          form: form.copyWith(
            ringtones: ringtones,
            clock: event.form!.clock.copyWith(ringtone: ringtones.first),
          ),
        ),
      );
    } else if (event.id case final id?) {
      final clock = await _repository.getAlarmClock(id);
      emit(
        AlarmClockFormLoaded(
          form: AlarmClockForm.init(
            clock: clock,
            onHourChanged: (value) => add(AlarmClockFormHourChanged(value: value)),
            onMinuteChanged: (value) => add(AlarmClockFormMinuteChanged(value: value)),
            onLabelChanged: (value) => add(AlarmClockFormLabelChanged(value: value)),
            onPressDayPeriod: (index) => add(AlarmClockDayPeriodPressed(index: index)),
            toggleEnable: (enabled) => add(AlarmClockFormEnableToggled(enabled: enabled)),
            toggleWeekday: (weekday) => add(AlarmClockFormWeekdayToggled(weekday: weekday)),
            toggleVibration: (vibration) => add(AlarmClockFormVibrationToggled(vibration: vibration)),
            changeRingtone: (ringtone) => add(AlarmClockFormRingtoneChanged(ringtone: ringtone)),
            playRingtone: (ringtone) => add(AlarmClockFormRingtonePlayed(ringtone: ringtone)),
            stopRingtone: () => add(AlarmClockFormRingtoneStopped()),
          ),
        ),
      );
    }
  }

  void _onAlarmClockFormHourChanged(AlarmClockFormHourChanged event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(form: final form)) {
      var hour = int.tryParse(event.value);
      if (hour == null) {
        emit(AlarmClockFormLoaded(form: form, errorCode: core.AlarmClockFormErrorCode.hourInvalid));
      } else if (hour < 0 || hour > 23) {
        emit(AlarmClockFormLoaded(form: form, errorCode: core.AlarmClockFormErrorCode.hourOutOfRange));
      } else {
        emit(
          AlarmClockFormLoaded(
            form: form.copyWith(clock: form.clock.copyWith(hour: hour)),
          ),
        );
      }
    }
  }

  void _onAlarmClockFormMinuteChanged(AlarmClockFormMinuteChanged event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(form: final form)) {
      var minute = int.tryParse(event.value);
      if (minute == null) {
        emit(AlarmClockFormLoaded(form: form, errorCode: core.AlarmClockFormErrorCode.minuteInvalid));
      } else if (minute < 0 || minute > 59) {
        emit(AlarmClockFormLoaded(form: form, errorCode: core.AlarmClockFormErrorCode.minuteOutOfRange));
      } else {
        emit(
          AlarmClockFormLoaded(
            form: form.copyWith(clock: form.clock.copyWith(minute: minute)),
          ),
        );
      }
    }
  }

  void _onAlarmClockFormLabelChanged(AlarmClockFormLabelChanged event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(form: final form)) {
      var name = form.labelController.controller.text.trim();
      if (name.length > 10) {
        emit(AlarmClockFormLoaded(form: form, errorCode: core.AlarmClockFormErrorCode.labelOutOfLength));
      } else {
        emit(
          AlarmClockFormLoaded(
            form: form.copyWith(clock: form.clock.copyWith(name: name)),
          ),
        );
      }
    }
  }

  void _onAlarmClockDayPeriodPressed(AlarmClockDayPeriodPressed event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(form: final form)) {
      emit(
        AlarmClockFormLoaded(
          form: form.copyWith(clock: form.clock.togglePeriod(event.index == 0 ? DayPeriod.am : DayPeriod.pm)),
        ),
      );
    }
  }

  void _onAlarmClockFormEnableToggled(AlarmClockFormEnableToggled event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(form: final form)) {
      emit(
        AlarmClockFormLoaded(
          form: form.copyWith(
            clock: form.clock.toggleEnable(event.enabled ? core.Status.enabled : core.Status.disabled),
          ),
        ),
      );
    }
  }

  void _onAlarmClockFormWeekdayToggled(AlarmClockFormWeekdayToggled event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(form: final form)) {
      emit(AlarmClockFormLoaded(form: form.copyWith(clock: form.clock.toggleWeekdays(event.weekday))));
    }
  }

  void _onAlarmClockFormVibrationToggled(AlarmClockFormVibrationToggled event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(form: final form)) {
      emit(AlarmClockFormLoaded(form: form.copyWith(clock: form.clock.toggleVibration(event.vibration))));
    }
  }

  void _onAlarmClockFormRingtoneChanged(AlarmClockFormRingtoneChanged event, Emitter<AlarmClockFormState> emit) {
    if (state case AlarmClockFormLoaded(form: final form)) {
      emit(
        AlarmClockFormLoaded(
          form: form.copyWith(clock: form.clock.copyWith(ringtone: event.ringtone)),
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
    if (state case AlarmClockFormLoaded(form: final form)) {
      await _repository.createAlarmClock(form.clock);
      emit(AlarmClockFormSuccess());
    }
  }
}
