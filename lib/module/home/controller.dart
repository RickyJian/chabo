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
        section: cmn.TimeSection.am,
        status: cmn.Status.enabled,
        weekdays: [cmn.Weekday.sunday, cmn.Weekday.monday, cmn.Weekday.friday],
        isLast: i == 4,
      ),
    );
  }

  toggleEnable(ClockComponent clock) {
    clock.status = clock.status == cmn.Status.enabled ? cmn.Status.disabled : cmn.Status.enabled;
    clocks.refresh();
  }

  toggleWeekday(ClockComponent clock, cmn.Weekday weekday) {
    if (clock.weekdays.contains(weekday)) {
      clock.weekdays.remove(weekday);
    } else {
      clock.weekdays.add(weekday);
      clock.weekdays.sort((left, right) {
        if (left.index < right.index) {
          return -1;
        } else if (left.index == right.index) {
          return 0;
        }
        // left.index > right.index
        return 1;
      });
    }
    if (clock.weekdays.isEmpty) {
      clock.weekdays.addAll(cmn.Weekday.values);
    }
    if (clock.status == cmn.Status.enabled) {
      beginTimer(clock);
    }
    clocks.refresh();
  }

  beginTimer(ClockComponent clock) {
    print(DateTime.now().weekday);
    // clocks.refresh();
  }
}
