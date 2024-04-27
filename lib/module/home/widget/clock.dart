import 'package:chabo/module/common/common.dart' as cmn;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  bool isWeekdaysEmpty(cmn.Weekday weekday) => !(weekdays.length > 1 || !weekdays.contains(weekday));

  toggleEnable(cmn.Status status) => this.status = status;

  onPressDayPeriod(int index) => index == 0 ? period = DayPeriod.am : period = DayPeriod.pm;
}

class ClockWidget extends StatelessWidget {
  final ClockComponent component;
  final bool isLast;
  final Function(bool value)? toggleEnable;
  final Function(cmn.Weekday weekday)? toggleWeekday;

  const ClockWidget({required this.component, this.isLast = false, this.toggleEnable, this.toggleWeekday});

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
                    onPressed: () => null, // TODO: open setting dialog
                  ),
                ],
              ),
              SizedBox(
                width: Constant.farawayWidth.w,
                height: Constant.farawayHeight.h,
                child: component.status == cmn.Status.enabled
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          // TODO: make timer count down
                          '2${cmn.Message.dayShort.tr}4${cmn.Message.hourShort.tr}30${cmn.Message.minuteShort.tr}',
                          style: TextStyle(
                            fontSize: Constant.farawayFontSize.sp,
                            color: Colors.black45,
                          ),
                        ),
                      )
                    : Container(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: Constant.labelIconPaddingRight.w),
                        child: Icon(
                          color: component.name.isEmpty ? Colors.black45 : Colors.black,
                          Icons.label_outline_rounded,
                          size: Constant.labelFontSize.sp * Constant.labelFontRatio,
                        ),
                      ),
                      Text(
                        component.name.isEmpty ? cmn.Message.labelEmpty.tr : component.name,
                        style: TextStyle(
                          color: component.name.isEmpty ? Colors.black45 : Colors.black,
                          fontSize: Constant.labelFontSize.sp,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: Constant.switchWidth.w,
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Switch(
                        value: component.status == cmn.Status.enabled ? true : false,
                        onChanged: (value) => toggleEnable == null ? null : toggleEnable!(value),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
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
                              color: component.weekdays.contains(weekday) ? Colors.yellow[200] : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            height: Constant.weekdaySize.r,
                            width: Constant.weekdaySize.r,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(Constant.weekdayCircularRadius)),
                              child: Center(
                                child: Text(weekday.string),
                              ),
                              onTap: () {
                                if (component.isWeekdaysEmpty(weekday)) {
                                  cmn.Snackbar.getSnackbar(
                                    height: Constant.notificationHeight.h,
                                    iconSize: Constant.notificationIconSize.sp,
                                    message: cmn.Message.infoMsgWeekdayIsEmpty.tr,
                                  );
                                }
                                if (toggleWeekday != null) {
                                  toggleWeekday!(weekday);
                                }
                              },
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
}

class ClockFormWidget extends StatelessWidget {
  final ClockComponent clock;
  final cmn.TextEditComponent hourController;
  final cmn.TextEditComponent minuteController;
  final Function(int index)? onPressDayPeriod;
  final cmn.TextEditComponent labelController;
  final Function(bool value)? toggleEnable;
  final Function(cmn.Weekday weekday)? toggleWeekday;
  final Function(bool value)? toggleVibration;

  const ClockFormWidget(
      {required this.clock,
      required this.hourController,
      required this.minuteController,
      required this.labelController,
      this.onPressDayPeriod,
      this.toggleEnable,
      this.toggleWeekday,
      this.toggleVibration});

  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: Constant.columnPaddingTop.h,
          horizontal: Constant.dialogHzPadding.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // row: time
              SizedBox(
                width: double.infinity,
                height: (Constant.dialogRowHeight * 2).h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: ToggleButtons(
                        isSelected: [
                          clock.period == DayPeriod.am,
                          clock.period == DayPeriod.pm,
                        ],
                        direction: Axis.vertical,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(cmn.Constant.defaultBorderRadius),
                        ),
                        borderWidth: cmn.Constant.defaultBorderWidth,
                        constraints: BoxConstraints(
                          maxHeight: Constant.dialogRowHeight.h - (cmn.Constant.defaultBorderWidth * 2),
                          maxWidth: double.infinity,
                          minHeight: Constant.dialogRowHeight.h - (cmn.Constant.defaultBorderWidth * 2),
                          minWidth: Constant.dayPeriodWidth.w,
                        ),
                        children: DayPeriod.values
                            .map(
                              (section) => FittedBox(
                                alignment: Alignment.center,
                                child: Text(section.localize.tr),
                              ),
                            )
                            .toList(),
                        onPressed: (index) => onPressDayPeriod == null ? null : onPressDayPeriod!(index),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: inputFieldTime(hourController, 12, 0, clock.hour, cmn.Message.hourLong.tr),
                    ),
                    Center(
                      child: Text(
                        cmn.Message.comma,
                        style: TextStyle(
                          fontSize: Constant.timeFieldFontSize.sp,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: inputFieldTime(minuteController, 59, 0, clock.minute, cmn.Message.minuteLong.tr),
                    ),
                  ],
                ),
              ),
              // label
              columnSpacer(),
              SizedBox(
                width: double.infinity,
                height: Constant.dialogRowHeight.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextFormField(
                        controller: labelController.controller,
                        focusNode: labelController.node,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          icon: Icon(
                            Icons.label_outline_rounded,
                            size: Constant.dialogFontSize.sp,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Constant.labelFieldHzPadding,
                            vertical: Constant.labelFieldVtPadding,
                          ),
                          hintText: cmn.Message.labelHint.tr,
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                        ],
                        textAlign: TextAlign.left,
                        textAlignVertical: TextAlignVertical.center,
                        onFieldSubmitted: (_) => labelController.node?.unfocus(),
                        style: TextStyle(
                          fontSize: Constant.dialogFontSize.sp,
                          height: 1, // 1 make text align vertical center
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Switch(
                        value: clock.status == cmn.Status.enabled ? true : false,
                        onChanged: (value) => toggleEnable == null ? null : toggleEnable!(value),
                      ),
                    ),
                  ],
                ),
              ),
              // weekdays
              columnSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            onTap: () {
                              if (clock.isWeekdaysEmpty(weekday)) {
                                cmn.Snackbar.getSnackbar(
                                  height: Constant.notificationHeight.h,
                                  iconSize: Constant.notificationIconSize.sp,
                                  message: cmn.Message.infoMsgWeekdayIsEmpty.tr,
                                );
                              }
                              toggleWeekday == null ? null : toggleWeekday!(weekday);
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              // ringtone
              columnSpacer(),
              InkWell(
                borderRadius: BorderRadius.circular(cmn.Constant.defaultBorderRadius),
                child: SizedBox(
                  width: double.infinity,
                  height: Constant.dialogRowHeight.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        size: Constant.dialogFontSize.sp,
                      ),
                      Text(
                        // TODO: change ringtone name
                        cmn.Message.ringtone.tr,
                        style: TextStyle(
                          fontSize: Constant.dialogFontSize.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => print('${Get.mediaQuery.viewInsets.bottom}'),
              ),
              columnSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.vibration_outlined,
                    size: Constant.dialogFontSize.sp,
                  ),
                  Switch(
                    value: clock.vibration,
                    onChanged: (value) => toggleVibration == null ? null : toggleVibration!(value),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  /// inputFieldTime
  Widget inputFieldTime(cmn.TextEditComponent controller, int max, int min, int value, String labelText) => Container(
        width: Constant.timeFieldWidth.w,
        constraints: BoxConstraints(
          maxWidth: double.infinity,
          minWidth: Constant.timeFieldWidth.w,
        ),
        alignment: Alignment.center,
        child: TextFormField(
          controller: controller.controller,
          focusNode: controller.node,
          autofocus: controller.autoFocus,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(cmn.Constant.defaultBorderRadius),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Constant.timeFieldContentHzPadding,
              vertical: Constant.timeFieldContentVtPadding,
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
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => controller.nextNode?.requestFocus(),
          style: TextStyle(
            fontSize: Constant.timeFieldFontSizePadding.sp,
            height: 1, // 1 make text align vertical center
          ),
        ),
      );

  /// columnSpacer
  Widget columnSpacer() => Padding(
        padding: EdgeInsets.only(top: Constant.columnPaddingTop.h),
      );
}
