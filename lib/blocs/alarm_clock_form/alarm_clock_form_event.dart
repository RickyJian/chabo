part of 'alarm_clock_form_bloc.dart';

sealed class AlarmClockFormEvent extends Equatable {
  const AlarmClockFormEvent();

  @override
  List<Object?> get props => [];
}

class AlarmClockDialogOpened extends AlarmClockFormEvent {
  final AlarmClockForm? form;
  final String? id;
  const AlarmClockDialogOpened({this.form, this.id});

  @override
  List<Object?> get props => [form, id];
}

class AlarmClockFormHourChanged extends AlarmClockFormEvent {
  final String value;
  const AlarmClockFormHourChanged({required this.value});

  @override
  List<Object?> get props => [value];
}

class AlarmClockFormMinuteChanged extends AlarmClockFormEvent {
  final String value;
  const AlarmClockFormMinuteChanged({required this.value});

  @override
  List<Object?> get props => [value];
}

class AlarmClockFormLabelChanged extends AlarmClockFormEvent {
  final String value;
  const AlarmClockFormLabelChanged({required this.value});

  @override
  List<Object?> get props => [value];
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
  const AlarmClockFormAdded();

  @override
  List<Object?> get props => [];
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
