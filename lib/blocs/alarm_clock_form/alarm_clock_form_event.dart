part of 'alarm_clock_form_bloc.dart';

sealed class AlarmClockFormEvent extends Equatable {
  const AlarmClockFormEvent();

  @override
  List<Object?> get props => [];
}

class AlarmClockDialogOpened extends AlarmClockFormEvent {
  final AlarmClockForm form;
  const AlarmClockDialogOpened({required this.form});

  @override
  List<Object?> get props => [form];
}

class AlarmClockDayPeriodPressed extends AlarmClockFormEvent {
  final int index;
  const AlarmClockDayPeriodPressed({required this.index});

  @override
  List<Object?> get props => [index];
}

class AlarmClockFormEnableToggled extends AlarmClockFormEvent {
  final bool enabled;

  const AlarmClockFormEnableToggled({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

class AlarmClockFormWeekdayToggled extends AlarmClockFormEvent {
  final core.Weekday weekday;
  final String? message;
  const AlarmClockFormWeekdayToggled({required this.weekday, this.message});

  @override
  List<Object?> get props => [weekday, message];
}

class AlarmClockFormVibrationToggled extends AlarmClockFormEvent {
  final bool vibration;
  const AlarmClockFormVibrationToggled({required this.vibration});

  @override
  List<Object?> get props => [vibration];
}

class AlarmClockFormRingtoneChanged extends AlarmClockFormEvent {
  final AlarmRingtone ringtone;
  const AlarmClockFormRingtoneChanged({required this.ringtone});

  @override
  List<Object?> get props => [ringtone];
}

class AlarmClockFormRingtonePlayed extends AlarmClockFormEvent {
  final AlarmRingtone ringtone;
  const AlarmClockFormRingtonePlayed({required this.ringtone});

  @override
  List<Object?> get props => [ringtone];
}

class AlarmClockFormRingtoneStopped extends AlarmClockFormEvent {
  const AlarmClockFormRingtoneStopped();

  @override
  List<Object?> get props => [];
}

class AlarmClockFormAdded extends AlarmClockFormEvent {
  final AlarmClock clock;
  const AlarmClockFormAdded({required this.clock});

  @override
  List<Object?> get props => [clock];
}

class AlarmClockFormUpdated extends AlarmClockFormEvent {
  final AlarmClock clock;
  const AlarmClockFormUpdated({required this.clock});

  @override
  List<Object?> get props => [clock];
}

class AlarmClockFormDeleted extends AlarmClockFormEvent {
  final AlarmClock clock;
  const AlarmClockFormDeleted({required this.clock});

  @override
  List<Object?> get props => [clock];
}
