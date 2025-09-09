part of 'alarm_clock_bloc.dart';

sealed class AlarmClockState extends Equatable {
  const AlarmClockState();

  @override
  List<Object?> get props => [];
}

class AlarmClockInitial extends AlarmClockState {}

class AlarmClockListLoaded extends AlarmClockState {
  final List<AlarmClock> clocks;

  const AlarmClockListLoaded({required this.clocks});

  @override
  List<Object?> get props => [clocks];
}

class AlarmClockSnackbarLoaded extends AlarmClockState {
  final String message;

  const AlarmClockSnackbarLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}
