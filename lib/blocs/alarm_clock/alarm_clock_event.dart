part of 'alarm_clock_bloc.dart';

sealed class AlarmClockEvent extends Equatable {
  const AlarmClockEvent();

  @override
  List<Object?> get props => [];
}

final class AlarmClockListed extends AlarmClockEvent {
  const AlarmClockListed();

  @override
  List<Object?> get props => [];
}

final class AlarmClockEnableToggled extends AlarmClockEvent {
  final AlarmClock alarm;
  final bool enabled;

  const AlarmClockEnableToggled({required this.alarm, required this.enabled});

  @override
  List<Object?> get props => [alarm, enabled];
}

final class AlarmClockWeekdayToggled extends AlarmClockEvent {
  final AlarmClock alarm;
  final Weekday weekday;
  final String? message;
  const AlarmClockWeekdayToggled({required this.alarm, required this.weekday, this.message});

  @override
  List<Object?> get props => [alarm, weekday, message];
}

class AlarmClockAdded extends AlarmClockEvent {
  final AlarmClock alarm;
  const AlarmClockAdded({required this.alarm});

  @override
  List<Object?> get props => [alarm];
}

class AlarmClockUpdated extends AlarmClockEvent {
  final AlarmClock alarm;
  const AlarmClockUpdated({required this.alarm});

  @override
  List<Object?> get props => [alarm];
}

class AlarmClockDeleted extends AlarmClockEvent {
  final AlarmClock alarm;
  const AlarmClockDeleted({required this.alarm});

  @override
  List<Object?> get props => [alarm];
}

// final class AlarmClockDialogOpened extends AlarmClockEvent {
//   final AlarmClock alarm;
//   const AlarmClockDialogOpened({required this.alarm});
// }
