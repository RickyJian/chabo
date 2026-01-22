import 'package:chabo/models/alarm.dart';
import 'package:chabo/repositories/database_helper.dart';

class AlarmClockRepository {
  final DatabaseHelper _helper = DatabaseHelper();

  Future<AlarmClock> createAlarmClock(AlarmClock clock) async {
    return await _helper.insertAlarmClock(clock);
  }

  Future<AlarmClock> updateAlarmClock(AlarmClock clock) async {
    return await _helper.updateAlarmClock(clock);
  }

  Future<List<AlarmClock>> listAlarmClocks() async {
    return await _helper.listAlarmClocks();
  }

  Future<AlarmClock> getAlarmClock(String id) async {
    final clocks = await _helper.listAlarmClocks(id: id);
    return clocks.first;
  }
}
