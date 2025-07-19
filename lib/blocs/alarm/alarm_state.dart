part of 'alarm_bloc.dart';

sealed class AlarmState extends Equatable {
  const AlarmState();

  @override
  List<Object?> get props => [];
}

class AlarmInitial extends AlarmState {}

class AlarmLoaded extends AlarmState {
  final List<Alarm> alarms;

  const AlarmLoaded({required this.alarms});

  @override
  List<Object?> get props => [alarms];
}

class AlarmSnackbarLoaded extends AlarmState {
  final String message;

  const AlarmSnackbarLoaded({required this.message});

  @override
  List<Object?> get props => [message];
}
