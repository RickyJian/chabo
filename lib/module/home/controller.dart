import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:chabo/module/common/common.dart' as cmn;

import 'widget/component.dart';

class HomeController extends GetxController {
  var clocks = <ClockComponent>[].obs;

  @override
  void onInit() {
    super.onInit();
    listClocks();
  }

  listClocks() {
    clocks.value = List.generate(
      5,
      (i) => ClockComponent(
        id: i,
        hour: 12,
        minute: 10,
        name: 'label $i',
        period: DayPeriod.am,
        status: cmn.Status.enabled,
        weekdays: cmn.Weekday.values.toList(),
      ),
    );
  }

  toggleEnable(ClockComponent clock, bool enabled) {
    var status = cmn.Status.enabled;
    if (!enabled) {
      status = cmn.Status.disabled;
    }
    clock.toggleEnable(status);
    clocks.refresh();
  }

  toggleWeekday(ClockComponent clock, cmn.Weekday weekday) {
    clock.toggleWeekdays(weekday);
    if (clock.status == cmn.Status.enabled) {
      // TODO: enable count down timer
    }
    clocks.refresh();
  }

  bool isWeekdaysEmpty(List<cmn.Weekday> weekdays, cmn.Weekday weekday) {
    if (weekdays.length > 1 || !weekdays.contains(weekday)) {
      return false;
    }
    return true;
  }
}

class FormController extends GetxController {
  final HomeController _homeController = Get.find();
  final AlarmController alarmController;
  late final List<SystemAlarmComponent> alarms;

  late final cmn.TextEditComponent hourController;
  late final cmn.TextEditComponent minuteController;
  late final cmn.TextEditComponent labelController;

  var clock = ClockComponent().obs;
  var alarmSelected = SystemAlarmComponent().obs;

  FormController({required alarmTag}) : alarmController = Get.put(tag: alarmTag, AlarmController());

  @override
  void onInit() async {
    super.onInit();

    // init clock
    hourController =
        cmn.TextEditComponent(controller: TextEditingController(text: '01'), autoFocus: true, node: FocusNode());
    minuteController = cmn.TextEditComponent(controller: TextEditingController(text: '00'), node: FocusNode());
    labelController = cmn.TextEditComponent(controller: TextEditingController(), node: FocusNode());
    hourController.nextNode = minuteController.node;
    minuteController.nextNode = labelController.node;

    // init alarms
    alarms = await alarmController.fetchAlarms();
    alarmSelected.value = alarms[0];
  }

  @override
  void onClose() {
    hourController.controller.dispose();
    minuteController.controller.dispose();
    labelController.controller.dispose();
  }

  Future<void> setTime(DateTime t) async {
    var d = TimeOfDay.fromDateTime(t);
    clock.value
      ..hour = d.hourOfPeriod
      ..minute = d.minute
      ..period = d.period;
    hourController.controller.text = clock.value.hour.toString().padLeft(2, '0');
    minuteController.controller.text = clock.value.minute.toString().padLeft(2, '0');
    clock.refresh();
  }

  onPressDayPeriod(int index) {
    clock.value.onPressDayPeriod(index);
    clock.refresh();
  }

  toggleEnable(bool enabled) {
    clock.value.toggleEnable(enabled ? cmn.Status.enabled : cmn.Status.disabled);
    clock.refresh();
  }

  // TODO: research why directly add or remove weekday from list will meet unmodifiable list error
  toggleWeekday(cmn.Weekday weekday) {
    clock.value
      ..weekdays = List<cmn.Weekday>.from(clock.value.weekdays)
      ..toggleWeekdays(weekday);
    clock.refresh();
  }

  toggleVibration(bool enabled) {
    clock.value.vibration = enabled;
    clock.refresh();
  }

  save() => _homeController.clocks.add(clock.value);

  onChangeAlarm(SystemAlarmComponent alarm) => alarmSelected.value = alarm;
}

class AlarmController {
  static const MethodChannel alarmChannel = MethodChannel('chabo/alarm');

  Future<List<SystemAlarmComponent>> fetchAlarms() async => alarmChannel.invokeMethod('listSystemAlarms').then((data) {
        if (data is! List) {
          throw Exception('[fetchAlarms] invalid type when invoke method channel listSystemAlarms');
        } else if (data.isEmpty) {
          throw Exception('[fetchAlarms] cannot find system alarms');
        }
        return data;
      }).then((array) {
        return List<SystemAlarmComponent>.generate(
            array.length, (i) => SystemAlarmComponent.fromJson(jsonDecode(array[i])));
      }).catchError((error) {
        // TODO: use log package instead
        log(error);
      });

  Future<void> playAlarm(String uri) async =>
      await alarmChannel.invokeMethod('playSystemAlarm', uri).catchError((error) => log(error));

  Future<void> stopAlarm() async =>
      await alarmChannel.invokeMethod('stopSystemAlarm').catchError((error) => log(error));
}
