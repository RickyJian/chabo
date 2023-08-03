import 'package:chabo/module/common/common.dart' as cmn;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller.dart';
import 'constant.dart';

class ClockComponent {
  final int id;
  final int hour;
  final int minute;
  final cmn.TimeSection section;
  final String name;
  final List<cmn.Weekday> weekdays;
  final bool isLast;
  cmn.Status status;

  // TODO: add diff time, ringtone, and shake

  ClockComponent(
      {required this.id,
      required this.hour,
      required this.minute,
      required this.section,
      required this.name,
      required this.weekdays,
      required this.isLast,
      this.status = cmn.Status.enabled});
}

class ClockWidget extends StatelessWidget {
  final ClockComponent component;
  final HomeController _homeController = Get.find();

  ClockWidget({required this.component});

  @override
  Widget build(context) => Card(
        margin: EdgeInsets.only(
          top: Constant.outerMarginTop.h,
          left: Constant.outerMarginWidth.w,
          right: Constant.outerMarginWidth.w,
          bottom: component.isLast ? Constant.outerMarginBottom.h : 0,
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
                    '${component.section.string} ${component.hour}:${component.minute}',
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
                    onChanged: (_) => _homeController.toggleEnable(component),
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

class ClockContentWidget extends StatelessWidget {
  final HomeController _homeController = Get.find();
  final DateTime? time;
  late final DayPeriod _period;
  late final int _hour;
  late final int _minute;

  ClockContentWidget({this.time}) {
    var dayOfTime = cmn.DateTimeUtils.getDayOfTime(time: time);
    _period = dayOfTime.period;
    _hour = dayOfTime.hourOfPeriod;
    _minute = dayOfTime.minute;
  }

  @override
  Widget build(context) => Padding(
        padding: EdgeInsets.only(
          top: Constant.dialogTopPadding.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.ideographic,
                children: [
                  ToggleButtons(
                    isSelected: [
                      _period == DayPeriod.am,
                      _period == DayPeriod.pm,
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
                    children: cmn.TimeSection.values
                        .map(
                          (section) => Text(section.string),
                        )
                        .toList(),
                    onPressed: (index) => print(index),
                  ),
                  _timeField(12, 1, _hour),
                  Text(
                    ':',
                    style: TextStyle(
                      fontSize: 50.sp,
                    ),
                  ),
                  _timeField(59, 0, _minute),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _timeField(int max, int min, int value) => Container(
        width: Constant.timeFieldWidth.w,
        alignment: Alignment.center,
        child: TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(cmn.Constant.defaultBorderRadius),
              ),
            ),
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: Constant.timeFieldContentPadding,
            ),
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
          initialValue: value.toString().padLeft(2, Constant.timeFieldContentLeadingZero),
        ),
      );
}
