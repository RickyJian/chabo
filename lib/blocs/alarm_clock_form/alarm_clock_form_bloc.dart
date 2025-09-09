import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chabo/models/models.dart';
import 'package:chabo/core/core.dart' as core;
import 'dart:convert';
import 'dart:developer';

part 'alarm_clock_form_event.dart';
part 'alarm_clock_form_state.dart';

class AlarmClockFormBloc extends Bloc<AlarmClockFormEvent, AlarmClockFormState> {
  static const MethodChannel alarmChannel = MethodChannel('chabo/alarm');

  AlarmClockFormBloc() : super(AlarmClockFormInitial()) {
    on<AlarmClockDialogOpened>(_onAlarmClockDialogOpened);
    on<AlarmClockDayPeriodPressed>(_onAlarmClockDayPeriodPressed);
    on<AlarmClockFormEnableToggled>(_onAlarmClockFormEnableToggled);
    on<AlarmClockFormWeekdayToggled>(_onAlarmClockFormWeekdayToggled);
    on<AlarmClockFormVibrationToggled>(_onAlarmClockFormVibrationToggled);
    on<AlarmClockFormRingtoneChanged>(_onAlarmClockFormRingtoneChanged);
    on<AlarmClockFormRingtonePlayed>(_onAlarmClockFormRingtonePlayed);
    on<AlarmClockFormRingtoneStopped>(_onAlarmClockFormRingtoneStopped);
  }

  void _onAlarmClockDialogOpened(AlarmClockDialogOpened event, Emitter<AlarmClockFormState> emit) async {
    // todo: enhance query system ringtones performance
    emit(AlarmClockFormLoading());

    final ringtones = await fetchSystemRingtones();
    emit(
      AlarmClockFormLoaded(
        form: event.form.copyWith(
          ringtones: ringtones,
          clock: event.form.clock.copyWith(ringtone: ringtones.first),
        ),
      ),
    );
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
}
