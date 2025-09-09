import 'package:chabo/core/core.dart' as core;
import 'package:chabo/core/widgets/text_component.dart';
import 'package:flutter/material.dart';
import 'package:chabo/models/alarm.dart';
import 'package:chabo/models/ringtone.dart';

class AlarmClockForm {
  final AlarmClock clock;

  final TextEditComponent hourController;
  final TextEditComponent minuteController;
  final Function(int index)? onPressDayPeriod;

  final TextEditComponent labelController;

  final Function(bool value)? toggleEnable;
  final Function(bool value)? toggleVibration;
  final Function(core.Weekday weekday)? toggleWeekday;

  final List<AlarmRingtone>? ringtones;
  final Function(AlarmRingtone alarm)? changeRingtone;
  final Function(AlarmRingtone alarm)? playRingtone;
  final Function()? stopRingtone;

  AlarmClockForm.init({
    required this.clock,
    this.onPressDayPeriod,
    this.toggleEnable,
    this.toggleWeekday,
    this.toggleVibration,
    this.changeRingtone,
    this.playRingtone,
    this.stopRingtone,
  }) : hourController = TextEditComponent(
         controller: TextEditingController(text: clock.hour.toString().padLeft(2, '0')),
         autoFocus: true,
         node: FocusNode(),
       ),
       minuteController = TextEditComponent(
         controller: TextEditingController(text: clock.minute.toString().padLeft(2, '0')),
         node: FocusNode(),
       ),
       labelController = TextEditComponent(controller: TextEditingController(), node: FocusNode()),
       ringtones = null;

  AlarmClockForm copyWith({
    AlarmClock? clock,
    TextEditComponent? hourController,
    TextEditComponent? minuteController,
    Function(int index)? onPressDayPeriod,
    TextEditComponent? labelController,
    Function(bool value)? toggleEnable,
    Function(bool value)? toggleVibration,
    Function(core.Weekday weekday)? toggleWeekday,
    List<AlarmRingtone>? ringtones,
    Function(AlarmRingtone alarm)? changeRingtone,
    Function(AlarmRingtone alarm)? playRingtone,
    Function()? stopRingtone,
  }) {
    return AlarmClockForm._internal(
      clock: clock ?? this.clock,
      hourController: hourController ?? this.hourController,
      minuteController: minuteController ?? this.minuteController,
      onPressDayPeriod: onPressDayPeriod ?? this.onPressDayPeriod,
      labelController: labelController ?? this.labelController,
      toggleEnable: toggleEnable ?? this.toggleEnable,
      toggleVibration: toggleVibration ?? this.toggleVibration,
      toggleWeekday: toggleWeekday ?? this.toggleWeekday,
      ringtones: ringtones ?? this.ringtones,
      changeRingtone: changeRingtone ?? this.changeRingtone,
      playRingtone: playRingtone ?? this.playRingtone,
      stopRingtone: stopRingtone ?? this.stopRingtone,
    );
  }

  /// 私有建構子供 copyWith 使用
  AlarmClockForm._internal({
    required this.clock,
    required this.hourController,
    required this.minuteController,
    required this.onPressDayPeriod,
    required this.labelController,
    required this.toggleEnable,
    required this.toggleVibration,
    required this.toggleWeekday,
    required this.ringtones,
    required this.changeRingtone,
    required this.playRingtone,
    required this.stopRingtone,
  });
}
