import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Message extends Translations {
  static final Message _singleton = Message._internal();

  factory Message() => _singleton;

  Message._internal();

  // support language
  static const englishLocale = Locale('en', 'US');
  static const chineseLocale = Locale('zh', 'TW');

  /// project
  static const appTitle = 'APP_TITLE';

  /// clock
  static const String dayPeriodAM = 'CLOCK_TIME_SECTION_AM';
  static const String dayPeriodPM = 'CLOCK_TIME_SECTION_PM';
  static const String clockCreateTitle = 'CLOCK_CREATE_TITLE';

  /// label
  static const String label = 'LABEL';
  static const String labelEmpty = 'LABEL_EMPTY';
  static const String labelHint = 'LABEL_HINT';

  /// weekday
  static const String weekdaySUN = 'WEEKDAY_SUN';
  static const String weekdayMON = 'WEEKDAY_MON';
  static const String weekdayTUE = 'WEEKDAY_TUE';
  static const String weekdayWED = 'WEEKDAY_WED';
  static const String weekdayTHU = 'WEEKDAY_THU';
  static const String weekdayFRI = 'WEEKDAY_FRI';
  static const String weekdaySAT = 'WEEKDAY_SAT';

  /// common
  static const String dayShort = 'DAY';
  static const String hourShort = 'HOUR_SHORT';
  static const String minuteShort = 'MINUTE_SHORT';
  static const String hourLong = 'HOUR';
  static const String minuteLong = 'MINUTE';
  static const String cancel = 'CANCEL';
  static const String save = 'SAVE';

  /// info message
  static const String infoMsgWeekdayIsEmpty = 'MSG_WEEKDAY_IS_EMPTY';

  /// error message

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          appTitle: 'Chabo',
          dayPeriodAM: 'AM',
          dayPeriodPM: 'PM',
          weekdaySUN: 'SUN',
          weekdayMON: 'MON',
          weekdayTUE: 'TUE',
          weekdayWED: 'WED',
          weekdayTHU: 'THU',
          weekdayFRI: 'FRI',
          weekdaySAT: 'SAT',
          dayShort: 'D',
          hourShort: 'H',
          minuteShort: 'M',
          hourLong: 'Hour',
          minuteLong: 'Minute',
          label: 'Label',
          labelEmpty: 'empty label',
          labelHint: 'input label',
          infoMsgWeekdayIsEmpty: 'When week days are disabled, will set every day enabled.',
          cancel: 'cancel',
          save: 'save',
          clockCreateTitle: 'New Alarm Clock',
        },
        'zh_TW': {
          appTitle: '日本矮雞',
          dayPeriodAM: '上午',
          dayPeriodPM: '下午',
          weekdaySUN: '日',
          weekdayMON: '一',
          weekdayTUE: '二',
          weekdayWED: '三',
          weekdayTHU: '四',
          weekdayFRI: '五',
          weekdaySAT: '六',
          dayShort: '天',
          hourShort: '時',
          minuteShort: '分',
          hourLong: '小時',
          minuteLong: '分鐘',
          label: '標籤',
          labelEmpty: '未設定標籤',
          labelHint: '請輸入標籤',
          infoMsgWeekdayIsEmpty: '當星期皆為非啟用時，自動將每天設定為啟用。',
          cancel: '取消',
          save: '存檔',
          clockCreateTitle: '新增鬧鐘',
        }
      };
}
