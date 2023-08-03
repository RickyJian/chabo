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

  /// label
  static const String labelEmpty = 'LABEL_EMPTY';

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
  static const String hourShort = 'HOUR';
  static const String minuteShort = 'MINUTE';

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
          labelEmpty: 'empty label',
          infoMsgWeekdayIsEmpty: 'When week days are disabled, will set every day enabled.',
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
          labelEmpty: '未設定標籤',
          infoMsgWeekdayIsEmpty: '當星期皆為非啟用時，自動將每天設定為啟用。',
        }
      };
}
