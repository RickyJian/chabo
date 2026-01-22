class Constant {
  Constant._();

  /// database
  static const String database = 'chabo.db';
  static const int databaseVersion = 1;

  /// alarm_clocks table
  static const String tableAlarmClock = 'alarm_clocks';

  /// alarm_clocks columns
  static const String columnId = 'id';
  static const String columnHour = 'hour';
  static const String columnMinute = 'minute';
  static const String columnPeriod = 'period';
  static const String columnName = 'name';
  static const String columnWeekdays = 'weekdays';
  static const String columnStatus = 'status';
  static const String columnVibration = 'vibration';
  static const String columnRingtoneName = 'ringtone_name';
  static const String columnRingtoneUri = 'ringtone_uri';
}
