part of 'alarm_clock_bloc.dart';

sealed class AlarmClockState extends Equatable {
  const AlarmClockState();

  @override
  List<Object?> get props => [];
}

class AlarmClockInitial extends AlarmClockState {}

// class AlarmClockDialogLoaded extends AlarmClockState {
//   final AlarmClock alarm;

//   const AlarmClockDialogLoaded({required this.alarm});

//   @override
//   List<Object?> get props => [alarm];
// }

class AlarmClockListLoaded extends AlarmClockState {
  final List<AlarmClock> alarms;

  const AlarmClockListLoaded({required this.alarms});

  @override
  List<Object?> get props => [alarms];
}

class AlarmClockSnackbarLoaded extends AlarmClockState {
  final String message;

  const AlarmClockSnackbarLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}
