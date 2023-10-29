import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chabo/module/common/common.dart' as cmn;

import 'widget/clock.dart';

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
  late final cmn.TextEditComponent hourController;
  late final cmn.TextEditComponent minuteController;
  late final cmn.TextEditComponent labelController;
  var clock = ClockComponent().obs;

  @override
  void onInit() {
    super.onInit();
    hourController =
        cmn.TextEditComponent(controller: TextEditingController(text: '01'), autoFocus: true, node: FocusNode());
    minuteController = cmn.TextEditComponent(controller: TextEditingController(text: '00'), node: FocusNode());
    labelController = cmn.TextEditComponent(controller: TextEditingController(), node: FocusNode());
    hourController.nextNode = minuteController.node;
    minuteController.nextNode = labelController.node;
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
}
