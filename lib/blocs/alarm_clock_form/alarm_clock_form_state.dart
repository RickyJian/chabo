part of 'alarm_clock_form_bloc.dart';

sealed class AlarmClockFormState extends Equatable {
  const AlarmClockFormState();

  @override
  List<Object?> get props => [];
}

class AlarmClockFormInitial extends AlarmClockFormState {}

class AlarmClockFormLoading extends AlarmClockFormState {}

class AlarmClockFormLoaded extends AlarmClockFormState {
  final AlarmClock clock;
  final List<SystemAlarmRingtone> ringtones;
  final core.AlarmClockFormErrorCode? errorCode;

  const AlarmClockFormLoaded({required this.clock, required this.ringtones, this.errorCode});

  @override
  List<Object?> get props => [clock, ringtones, errorCode];
}

class AlarmClockFormSuccess extends AlarmClockFormState {}
