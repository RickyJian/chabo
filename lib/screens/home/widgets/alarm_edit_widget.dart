import 'package:chabo/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chabo/models/models.dart';
import 'package:chabo/core/core.dart' as core;

import 'constant.dart';

class AlarmEditWidget extends StatefulWidget {
  final AlarmClock clock;
  final List<AlarmRingtone>? ringtones;

  final Function(int index)? onPressDayPeriod;
  final Function(bool enabled)? onToggleEnable;
  final Function(bool vibration)? onToggleVibration;
  final Function(core.Weekday weekday)? onToggleWeekday;
  final Function(AlarmRingtone ringtone)? onChangeRingtone;
  final Function(AlarmRingtone ringtone)? onPlayRingtone;
  final Function()? onStopRingtone;

  const AlarmEditWidget({
    super.key,
    required this.clock,
    this.ringtones,
    this.onPressDayPeriod,
    this.onToggleEnable,
    this.onToggleVibration,
    this.onToggleWeekday,
    this.onChangeRingtone,
    this.onPlayRingtone,
    this.onStopRingtone,
  });

  @override
  State<AlarmEditWidget> createState() => AlarmEditWidgetState();
}

class AlarmEditWidgetState extends State<AlarmEditWidget> {
  late final core.TextEditComponent _hourController;
  late final core.TextEditComponent _minuteController;
  late final core.TextEditComponent _labelController;

  @override
  void initState() {
    super.initState();

    // init controllers
    _hourController = core.TextEditComponent(
      controller: TextEditingController(text: widget.clock.hour.toString())
        ..selection = TextSelection.collapsed(offset: 0),
      autoFocus: true,
      node: FocusNode(),
    );
    _minuteController = core.TextEditComponent(
      controller: TextEditingController(text: widget.clock.minute.toString())
        ..selection = TextSelection.collapsed(offset: 0),
      node: FocusNode(),
    );
    _labelController = core.TextEditComponent(
      controller: TextEditingController(text: widget.clock.name)
        ..selection = TextSelection.collapsed(offset: widget.clock.name.length),
      node: FocusNode(),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _hourController.node != null) {
        _hourController.node!.requestFocus();
      }
    });
  }

  AlarmClock get clock {
    return widget.clock.copyWith(
      hour: int.tryParse(_hourController.controller.text),
      minute: int.tryParse(_minuteController.controller.text),
      name: _labelController.controller.text,
    );
  }

  @override
  void dispose() {
    _hourController.controller.dispose();
    _hourController.node?.dispose();
    _minuteController.controller.dispose();
    _minuteController.node?.dispose();
    _labelController.controller.dispose();
    _labelController.node?.dispose();
    super.dispose();
  }

  @override
  Widget build(context) => Padding(
    padding: EdgeInsets.symmetric(vertical: Constant.columnPaddingTop.h, horizontal: Constant.dialogHzPadding.w),
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
                    isSelected: [widget.clock.period == DayPeriod.am, widget.clock.period == DayPeriod.pm],
                    direction: Axis.vertical,
                    borderRadius: const BorderRadius.all(Radius.circular(Constant.defaultBorderRadius)),
                    borderWidth: Constant.defaultBorderWidth,
                    constraints: BoxConstraints(
                      maxHeight: Constant.dialogRowHeight.h - (Constant.defaultBorderWidth * 2),
                      maxWidth: double.infinity,
                      minHeight: Constant.dialogRowHeight.h - (Constant.defaultBorderWidth * 2),
                      minWidth: Constant.dayPeriodWidth.w,
                    ),
                    children: DayPeriod.values
                        .map(
                          (section) => FittedBox(alignment: Alignment.center, child: Text(section.localize(context))),
                        )
                        .toList(),
                    onPressed: (index) => widget.onPressDayPeriod?.call(index),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: inputFieldTime(
                    _hourController,
                    12,
                    1,
                    widget.clock.hour,
                    AppLocalizations.of(context)!.hourLong,
                  ),
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.comma,
                    style: TextStyle(fontSize: Constant.timeFieldFontSize.sp),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: inputFieldTime(
                    _minuteController,
                    59,
                    0,
                    widget.clock.minute,
                    AppLocalizations.of(context)!.minuteLong,
                  ),
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
                    controller: _labelController.controller,
                    focusNode: _labelController.node,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      icon: Icon(Icons.label_outline_rounded, size: Constant.dialogFontSize.sp),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Constant.labelFieldHzPadding,
                        vertical: Constant.labelFieldVtPadding,
                      ),
                      hintText: AppLocalizations.of(context)!.labelHint,
                    ),
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    textAlign: TextAlign.left,
                    textAlignVertical: TextAlignVertical.center,
                    // onFieldSubmitted: (_) => widget.labelController.node?.unfocus(),
                    style: TextStyle(
                      fontSize: Constant.dialogFontSize.sp,
                      height: 1, // 1 make text align vertical center
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Switch(
                    value: widget.clock.status == core.Status.enabled ? true : false,
                    onChanged: (value) => widget.onToggleEnable?.call(value),
                  ),
                ),
              ],
            ),
          ),
          // weekdays
          columnSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: core.Weekday.values
                .map(
                  (weekday) => Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: Constant.weekdayBorderWidth),
                        color: widget.clock.weekdays.contains(weekday) ? Colors.yellow[200] : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      height: Constant.weekdaySize.h,
                      width: Constant.weekdaySize.w,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(Constant.weekdayCircularRadius)),
                        child: Center(child: Text(weekday.localize(context))),
                        onTap: () {
                          if (widget.clock.weekdays.isEmpty) {
                            core.Snackbar.showSnackbar(
                              context: context,
                              height: Constant.notificationHeight.h,
                              message: AppLocalizations.of(context)!.infoMsgWeekdayIsEmpty,
                            );
                          }
                          widget.onToggleWeekday?.call(weekday);
                        },
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          // ringtone
          columnSpacer(),
          GestureDetector(
            child: InkWell(
              borderRadius: BorderRadius.circular(Constant.defaultBorderRadius),
              child: SizedBox(
                width: double.infinity,
                height: Constant.dialogRowHeight.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.notifications_active_outlined, size: Constant.dialogFontSize.sp),
                    Text(
                      // TODO: change ringtone name
                      widget.clock.ringtone?.name ?? '',
                      style: TextStyle(fontSize: Constant.dialogFontSize.sp),
                    ),
                  ],
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  enableDrag: false,
                  builder: (context) {
                    return Container(
                      height: Constant.ringtoneBottomSheetHeight.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Constant.defaultBorderRadius),
                          topRight: Radius.circular(Constant.defaultBorderRadius),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Constant.ringtoneTitleHeight.h,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.alarmSystem,
                                style: TextStyle(fontSize: Constant.ringtoneFontSize.sp),
                              ),
                            ),
                          ),
                          const Divider(),
                          widget.ringtones == null
                              ? const SizedBox.shrink()
                              : Expanded(
                                  child: ListView(
                                    children: [
                                      RadioGroup<AlarmRingtone>(
                                        groupValue: widget.clock.ringtone,
                                        onChanged: (selected) {
                                          if (selected != null) {
                                            widget.onChangeRingtone?.call(selected);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            for (final alarm in widget.ringtones!)
                                              RadioListTile(
                                                dense: true,
                                                value: alarm,
                                                title: Row(
                                                  children: [
                                                    const Expanded(flex: 2, child: Icon(Icons.alarm_outlined)),
                                                    Expanded(
                                                      flex: 8,
                                                      child: Text(alarm.name, style: TextStyle(fontSize: 20.sp)),
                                                    ),
                                                  ],
                                                ),
                                                controlAffinity: ListTileControlAffinity.trailing,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            onLongPressStart: (_) {
              if (widget.clock.ringtone case final ringtone?) {
                widget.onPlayRingtone?.call(ringtone);
              }
            },
            onLongPressEnd: (_) => widget.onStopRingtone?.call(),
          ),
          columnSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.vibration_outlined, size: Constant.dialogFontSize.sp),
              Switch(value: widget.clock.vibration, onChanged: (value) => widget.onToggleVibration?.call(value)),
            ],
          ),
        ],
      ),
    ),
  );

  /// inputFieldTime
  Widget inputFieldTime(core.TextEditComponent controller, int max, int min, int value, String labelText) => Container(
    width: Constant.timeFieldWidth.w,
    constraints: BoxConstraints(maxWidth: double.infinity, minWidth: Constant.timeFieldWidth.w),
    alignment: Alignment.center,
    child: TextFormField(
      controller: controller.controller,
      focusNode: controller.node,
      autofocus: controller.autoFocus,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(Constant.defaultBorderRadius))),
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
        core.TimeRangeFormatter(max: max, min: min),
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
  Widget columnSpacer() => Padding(padding: EdgeInsets.only(top: Constant.columnPaddingTop.h));
}
