part of 'alarm_bloc.dart';

sealed class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object?> get props => [];
}

final class AlarmListed extends AlarmEvent {
  const AlarmListed();

  @override
  List<Object?> get props => [];
}

final class AlarmEnableToggled extends AlarmEvent {
  final Alarm alarm;
  final bool enabled;

  const AlarmEnableToggled({required this.alarm, required this.enabled});

  @override
  List<Object?> get props => [alarm, enabled];
}

final class AlarmWeekdayToggled extends AlarmEvent {
  final Alarm alarm;
  final Weekday weekday;
  final String? message;
  const AlarmWeekdayToggled({required this.alarm, required this.weekday, this.message});

  @override
  List<Object?> get props => [alarm, weekday, message];
}

class AlarmAdded extends AlarmEvent {
  final Alarm alarm;
  const AlarmAdded({required this.alarm});

  @override
  List<Object?> get props => [alarm];
}

class AlarmUpdated extends AlarmEvent {
  final Alarm alarm;
  const AlarmUpdated({required this.alarm});

  @override
  List<Object?> get props => [alarm];
}

class AlarmDeleted extends AlarmEvent {
  final Alarm alarm;
  const AlarmDeleted({required this.alarm});

  @override
  List<Object?> get props => [alarm];
}
