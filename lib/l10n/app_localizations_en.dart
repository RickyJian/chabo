// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Chabo';

  @override
  String get dayPeriodAM => 'AM';

  @override
  String get dayPeriodPM => 'PM';

  @override
  String get weekdaySUN => 'SUN';

  @override
  String get weekdayMON => 'MON';

  @override
  String get weekdayTUE => 'TUE';

  @override
  String get weekdayWED => 'WED';

  @override
  String get weekdayTHU => 'THU';

  @override
  String get weekdayFRI => 'FRI';

  @override
  String get weekdaySAT => 'SAT';

  @override
  String get alarm => 'Alarm';

  @override
  String get alarmSystem => 'System Alarms';

  @override
  String get dayShort => 'D';

  @override
  String get hourShort => 'H';

  @override
  String get minuteShort => 'M';

  @override
  String get hourLong => 'Hour';

  @override
  String get minuteLong => 'Minute';

  @override
  String get label => 'Label';

  @override
  String get labelEmpty => 'empty label';

  @override
  String get labelHint => 'input label';

  @override
  String get infoMsgWeekdayIsEmpty =>
      'When week days are disabled, will set every day enabled.';

  @override
  String get cancel => 'cancel';

  @override
  String get save => 'save';

  @override
  String get clockCreateTitle => 'New Alarm Clock';

  @override
  String get setting => 'Setting';

  @override
  String get comma => ':';
}
