import 'package:chabo/module/common/common.dart' as cmn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller.dart';
import 'constant.dart';

class ClockComponent {
  int id;
  int hour;
  int minute;
  DayPeriod period;
  String name;
  List<cmn.Weekday> weekdays;
  cmn.Status status;
  bool vibration;

  // TODO: add diff time, ringtone

  ClockComponent(
      {this.id = -1,
      this.hour = 1,
      this.minute = 0,
      this.period = DayPeriod.am,
      this.name = '',
      this.weekdays = cmn.Weekday.values,
      this.status = cmn.Status.enabled,
      this.vibration = true});

  ClockComponent.init(TimeOfDay t)
      : id = DateTime.now().microsecondsSinceEpoch,
        hour = t.hourOfPeriod,
        minute = t.minute,
        period = t.period,
        name = '',
        weekdays = cmn.Weekday.values,
        status = cmn.Status.enabled,
        vibration = true;

  toggleWeekdays(cmn.Weekday weekday) {
    if (weekdays.contains(weekday)) {
      weekdays.remove(weekday);
    } else {
      weekdays.add(weekday);
      weekdays.sort((left, right) {
        if (left.index < right.index) {
          return -1;
        } else if (left.index == right.index) {
          return 0;
        }
        // left.index > right.index
        return 1;
      });
    }
    if (weekdays.isEmpty) {
      weekdays.addAll(cmn.Weekday.values);
    }
  }

  toggleEnable(cmn.Status status) => this.status = status;

  onPressDayPeriod(int index) => index == 0 ? period = DayPeriod.am : period = DayPeriod.pm;
}

class ClockWidget extends StatelessWidget {
  final ClockComponent component;
  final HomeController _homeController = Get.find();
  final bool isLast;

  ClockWidget({required this.component, this.isLast = false});

  @override
  Widget build(context) => Card(
        margin: EdgeInsets.only(
          top: Constant.outerMarginTop.h,
          left: Constant.outerMarginWidth.w,
          right: Constant.outerMarginWidth.w,
          bottom: isLast ? Constant.outerMarginBottom.h : 0,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: Constant.innerMarginVertical.h,
            horizontal: Constant.innerMarginHorizontal.w,
          ),
          padding: EdgeInsets.symmetric(
            vertical: Constant.innerPaddingVertical.h,
            horizontal: Constant.innerPaddingHorizontal.w,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // TODO: make `:` in center position
                    '${component.period.localize} ${component.hour}:${component.minute}',
                    style: TextStyle(
                      fontSize: Constant.timeFontSize.sp,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: () => null,
                  ),
                ],
              ),
              SizedBox(
                width: Constant.farawayWidth.w,
                height: Constant.farawayHeight.h,
                child: component.status == cmn.Status.enabled
                    ? Text(
                        // TODO: make timer count down
                        '2${cmn.Message.dayShort.tr}4${cmn.Message.hourShort.tr}30${cmn.Message.minuteShort.tr}',
                        style: TextStyle(
                          fontSize: Constant.farawayFontSize.sp,
                          color: Colors.black45,
                        ),
                      )
                    : Container(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _iconLabel(component.name),
                  const Spacer(),
                  Switch(
                    value: component.status == cmn.Status.enabled ? true : false,
                    onChanged: (value) => _homeController.toggleEnable(component, value),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: Constant.weekdayPaddingTop.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: cmn.Weekday.values
                      .map(
                        (weekday) => _weekday(component, weekday),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _iconLabel(String name) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Constant.labelIconPaddingRight.w),
            child: Icon(
              color: name.isEmpty ? Colors.black45 : Colors.black,
              Icons.label_outline_rounded,
              size: Constant.labelFontSize.sp * Constant.labelFontRatio,
            ),
          ),
          Text(
            name.isEmpty ? cmn.Message.labelEmpty.tr : name,
            style: TextStyle(
              color: name.isEmpty ? Colors.black45 : Colors.black,
              fontSize: Constant.labelFontSize.sp,
            ),
          ),
        ],
      );

  Widget _weekday(ClockComponent clock, cmn.Weekday weekday) => Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: Constant.weekdayBorderWidth,
            ),
            color: clock.weekdays.contains(weekday) ? Colors.yellow[200] : Colors.transparent,
            shape: BoxShape.circle,
          ),
          height: Constant.weekdaySize.h,
          width: Constant.weekdaySize.w,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(Constant.weekdayCircularRadius)),
            child: Center(
              child: Text(weekday.string),
            ),
            onTap: () {
              if (_homeController.isWeekdaysEmpty(clock.weekdays, weekday)) {
                Get.rawSnackbar(
                    messageText: SizedBox(
                      height: Constant.notificationHeight.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Icon(
                              Icons.info_outline_rounded,
                              color: Colors.white,
                              size: Constant.notificationIconSize.sp,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: Constant.notificationTextPadding),
                          ),
                          Expanded(
                            flex: 9,
                            child: Text(
                              cmn.Message.infoMsgWeekdayIsEmpty.tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: Constant.notificationMarginWidth.w,
                      right: Constant.notificationMarginWidth.w,
                      bottom: Constant.notificationMarginBottom.h,
                    ),
                    boxShadows: [
                      const BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0, 10),
                        spreadRadius: Constant.notificationBoxShadowSpreadRadius,
                        blurRadius: Constant.notificationBoxShadowBlurRadius,
                      )
                    ],
                    borderRadius: Constant.notificationBorderRadius,
                    snackPosition: SnackPosition.BOTTOM,
                    snackStyle: SnackStyle.FLOATING,
                    duration: const Duration(seconds: 2));
              }
              _homeController.toggleWeekday(clock, weekday);
            },
          ),
        ),
      );
}

class ClockFormWidget extends StatelessWidget {
  final ClockComponent clock;
  final TextEditingController hourController;
  final TextEditingController minuteController;
  final Function(int index)? onPressDayPeriod;
  final Function(bool value)? toggleEnable;
  final Function(cmn.Weekday weekday)? toggleWeekday;
  final Function(bool value)? toggleVibration;

  const ClockFormWidget(
      {required this.clock,
      required this.hourController,
      required this.minuteController,
      this.onPressDayPeriod,
      this.toggleEnable,
      this.toggleWeekday,
      this.toggleVibration});

  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: Constant.dialogVerticalPadding.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: (Constant.dialogRowHeight * 2).h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ToggleButtons(
                      isSelected: [
                        clock.period == DayPeriod.am,
                        clock.period == DayPeriod.pm,
                      ],
                      direction: Axis.vertical,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(cmn.Constant.defaultBorderRadius),
                      ),
                      borderWidth: Constant.dialogBorderWidth,
                      constraints: BoxConstraints(
                        minHeight: Constant.dayPeriodHeight.h,
                        minWidth: Constant.dayPeriodWidth.w,
                      ),
                      textStyle: TextStyle(
                        fontSize: Constant.dayPeriodFontSize.sp,
                      ),
                      children: DayPeriod.values
                          .map(
                            (section) => Text(section.localize),
                          )
                          .toList(),
                      onPressed: (index) => onPressDayPeriod == null ? null : onPressDayPeriod!(index),
                    ),
                    _timeField(hourController, 12, 1, clock.hour, cmn.Message.hourLong.tr),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: Constant.timeFieldFontSize.sp,
                      ),
                    ),
                    _timeField(minuteController, 59, 0, clock.minute, cmn.Message.minuteLong.tr),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: Constant.dialogRowHeight.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.label_outline_rounded,
                      size: Constant.dialogLabelFontSize.sp,
                    ),
                    Container(
                      width: Constant.labelFieldWidth.w,
                      alignment: Alignment.center,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          // TODO: add limit to be suffix
                          hintText: cmn.Message.labelHint.tr,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          fontSize: Constant.dialogLabelFontSize.sp,
                          height: 1, // 1 make text align vertical center
                        ),
                        initialValue: '',
                      ),
                    ),
                    Switch(
                      value: clock.status == cmn.Status.enabled ? true : false,
                      onChanged: (value) => toggleEnable == null ? null : toggleEnable!(value),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: Constant.dialogRowHeight.h,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: Constant.weekdayPaddingTop.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: cmn.Weekday.values
                        .map(
                          (weekday) => Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: Constant.weekdayBorderWidth,
                                ),
                                color: clock.weekdays.contains(weekday) ? Colors.yellow[200] : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              height: Constant.weekdaySize.h,
                              width: Constant.weekdaySize.w,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(Radius.circular(Constant.weekdayCircularRadius)),
                                child: Center(
                                  child: Text(weekday.string),
                                ),
                                onTap: () => toggleWeekday == null ? null : toggleWeekday!(weekday),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(cmn.Constant.defaultBorderRadius),
                child: SizedBox(
                  width: double.infinity,
                  height: Constant.dialogRowHeight.h,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        size: Constant.labelFontSize.sp * Constant.labelFontRatio,
                      ),
                      const Spacer(),
                      Text(
                        'ringtone',
                        style: TextStyle(
                          fontSize: Constant.labelFontSize.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => print('${Get.mediaQuery.viewInsets.bottom}'),
              ),
              Container(
                width: double.infinity,
                height: Constant.dialogRowHeight.h,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.vibration_outlined,
                      size: Constant.labelFontSize.sp * Constant.labelFontRatio,
                    ),
                    const Spacer(),
                    Switch(
                      value: clock.vibration,
                      onChanged: (value) => toggleVibration == null ? null : toggleVibration!(value),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _timeField(TextEditingController controller, int max, int min, int value, String labelText) => Container(
        width: Constant.timeFieldWidth.w,
        alignment: Alignment.center,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(cmn.Constant.defaultBorderRadius),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Constant.timeFieldContentHorizontalPadding,
              vertical: Constant.timeFieldContentVerticalPadding,
            ),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2),
            cmn.TimeRangeFormatter(max: max, min: min),
          ],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            fontSize: Constant.timeFieldFontSizePadding.sp,
            height: 1, // 1 make text align vertical center
          ),
          // initialValue: value.toString().padLeft(2, Constant.timeFieldContentLeadingZero),
        ),
      );
}
