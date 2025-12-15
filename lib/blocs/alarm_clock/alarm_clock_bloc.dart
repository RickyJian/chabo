import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chabo/models/alarm.dart';
import 'package:chabo/core/core.dart' as core;
import 'package:chabo/repositories/reporistories.dart';

part 'alarm_clock_event.dart';
part 'alarm_clock_state.dart';

class AlarmClockBloc extends Bloc<AlarmClockEvent, AlarmClockState> {
  final AlarmClockRepository _repository = AlarmClockRepository();

  AlarmClockBloc() : super(AlarmClockInitial()) {
    on<AlarmClockListed>(_onAlarmClockListed);
    on<AlarmClockEnableToggled>(_onAlarmClockEnableToggled);
    on<AlarmClockWeekdayToggled>(_onAlarmClockWeekdayToggled);
  }

  Future<void> _onAlarmClockListed(AlarmClockListed event, Emitter<AlarmClockState> emit) async {
    final clocks = await _repository.listAlarmClocks();
    emit(AlarmClockListLoaded(clocks: clocks));
  }

  void _onAlarmClockEnableToggled(AlarmClockEnableToggled event, Emitter<AlarmClockState> emit) {
    if (state case AlarmClockListLoaded(clocks: final clocks)) {
      final updatedClocks = clocks
          .map(
            (clock) => clock.id == event.clock.id
                ? clock.toggleEnable(event.enabled ? core.Status.enabled : core.Status.disabled)
                : clock,
          )
          .toList();

      emit(AlarmClockListLoaded(clocks: updatedClocks));
    }
  }

  void _onAlarmClockWeekdayToggled(AlarmClockWeekdayToggled event, Emitter<AlarmClockState> emit) {
    if (state case AlarmClockListLoaded(clocks: final clocks)) {
      final clock = clocks.firstWhere((clock) => clock.id == event.clock.id);
      if (event.message?.isNotEmpty == true && (clock.weekdays.length <= 1 && clock.weekdays.contains(event.weekday))) {
        emit(AlarmClockSnackbarLoaded(message: event.message!));
      }

      final updatedClocks = clocks
          .map((clock) => clock.id == event.clock.id ? clock.toggleWeekdays(event.weekday) : clock)
          .toList();

      emit(AlarmClockListLoaded(clocks: updatedClocks));
    }
  }
}
