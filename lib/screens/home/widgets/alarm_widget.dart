import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chabo/l10n/app_localizations.dart';
import 'package:chabo/models/alarm.dart';
import 'package:chabo/core/enums/enums.dart';
import 'package:chabo/core/extensions/extensions.dart';
import 'constant.dart';

class AlarmWidget extends StatelessWidget {
  final Alarm alarm;
  final bool isLast;
  final Function(bool value) toggleEnable;
  final Function(Weekday weekday) toggleWeekday;

  const AlarmWidget({
    required this.alarm,
    this.isLast = false,
    required this.toggleEnable,
    required this.toggleWeekday,
  });

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
                '${alarm.period == DayPeriod.am ? 'AM' : 'PM'} ${alarm.hour}:${alarm.minute}',
                style: TextStyle(fontSize: Constant.timeFontSize.sp),
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
            child: alarm.status == Status.enabled
                ? Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      // TODO: make timer count down
                      '2${AppLocalizations.of(context)!.dayShort}4${AppLocalizations.of(context)!.hourShort}30${AppLocalizations.of(context)!.minuteShort}',
                      style: TextStyle(fontSize: Constant.farawayFontSize.sp, color: Colors.black45),
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
                      color: alarm.name.isEmpty ? Colors.black45 : Colors.black,
                      Icons.label_outline_rounded,
                      size: Constant.labelFontSize.sp * Constant.labelFontRatio,
                    ),
                  ),
                  Text(
                    alarm.name.isEmpty ? AppLocalizations.of(context)!.labelEmpty : alarm.name,
                    style: TextStyle(
                      color: alarm.name.isEmpty ? Colors.black45 : Colors.black,
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
                  child: Switch(value: alarm.status == Status.enabled ? true : false, onChanged: toggleEnable),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: Constant.weekdayPaddingTop.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: Weekday.values
                  .map(
                    (weekday) => Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: Constant.weekdayBorderWidth),
                          color: alarm.weekdays.contains(weekday) ? Colors.yellow[200] : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        height: Constant.weekdaySize.r,
                        width: Constant.weekdaySize.r,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(Constant.weekdayCircularRadius)),
                          child: Center(child: Text(weekday.localize(context))),
                          onTap: () => toggleWeekday(weekday),
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
