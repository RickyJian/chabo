// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '日本矮雞';

  @override
  String get dayPeriodAM => '上午';

  @override
  String get dayPeriodPM => '下午';

  @override
  String get weekdaySUN => '日';

  @override
  String get weekdayMON => '一';

  @override
  String get weekdayTUE => '二';

  @override
  String get weekdayWED => '三';

  @override
  String get weekdayTHU => '四';

  @override
  String get weekdayFRI => '五';

  @override
  String get weekdaySAT => '六';

  @override
  String get alarm => '鬧鈴';

  @override
  String get alarmSystem => '系統鬧鈴';

  @override
  String get dayShort => '天';

  @override
  String get hourShort => '時';

  @override
  String get minuteShort => '分';

  @override
  String get hourLong => '小時';

  @override
  String get minuteLong => '分鐘';

  @override
  String get label => '標籤';

  @override
  String get labelEmpty => '未設定標籤';

  @override
  String get labelHint => '請輸入標籤';

  @override
  String get infoMsgWeekdayIsEmpty => '當星期皆為非啟用時，自動將每天設定為啟用。';

  @override
  String get remove => '刪除';

  @override
  String get cancel => '取消';

  @override
  String get save => '存檔';

  @override
  String get clockCreateTitle => '新增鬧鐘';

  @override
  String get setting => '設定';

  @override
  String get comma => '：';

  @override
  String get errMsgHourInvalid => '請確認您輸入的小時數值。';

  @override
  String get errMsgHourOutOfRange => '小時請設定為 0 至 23。';

  @override
  String get errMsgMinuteInvalid => '請確認您輸入的分鐘數值。';

  @override
  String get errMsgMinuteOutOfRange => '分鐘請設定為 0 至 59。';

  @override
  String get errMsgLabelOutOfLength => '鬧鐘標籤請限制在 10 字內。';

  @override
  String get errMsgUnknown => '請聯繫開發人員，協助排除異常。';
}
