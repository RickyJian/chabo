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
  static const String clockTimeSectionAM = 'CLOCK_TIME_SECTION_AM';
  static const String clockTimeSectionPM = 'CLOCK_TIME_SECTION_PM';

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

  /// error message

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          appTitle: 'Chabo',
          clockTimeSectionAM: 'AM',
          clockTimeSectionPM: 'PM',
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
        },
        'zh_TW': {
          appTitle: '日本矮雞',
          clockTimeSectionAM: '上午',
          clockTimeSectionPM: '下午',
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
        }
      };
}
