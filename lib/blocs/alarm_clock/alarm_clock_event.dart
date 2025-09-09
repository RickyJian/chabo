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
  final AlarmClock clock;
  final bool enabled;

  const AlarmClockEnableToggled({required this.clock, required this.enabled});

  @override
  List<Object?> get props => [clock, enabled];
}

final class AlarmClockWeekdayToggled extends AlarmClockEvent {
  final AlarmClock clock;
  final core.Weekday weekday;
  final String? message;
  const AlarmClockWeekdayToggled({required this.clock, required this.weekday, this.message});

  @override
  List<Object?> get props => [clock, weekday, message];
}
