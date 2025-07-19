import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chabo/blocs/blocs.dart';
import 'package:chabo/screens/home/widgets/widgets.dart';
import 'package:chabo/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(context) => Scaffold(
    appBar: AppBar(
      // leading: IconButton(
      //   icon: const FaIcon(FontAwesomeIcons.bars),
      //   alignment: Alignment.center,
      //   onPressed: () => getx.Get.to(
      //     SettingPage(),
      //     duration: const Duration(
      //       milliseconds: cmn.Constant.navigationDuration,
      //     ),
      //     transition: getx.Transition.leftToRight,
      //   ),
      // ),
      title: Text(AppLocalizations.of(context)!.appTitle),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      centerTitle: true,
    ),
    body: BlocListener<AlarmBloc, AlarmState>(
      listenWhen: (previous, current) => current is AlarmSnackbarLoaded,
      listener: (context, state) {
        if (state case AlarmSnackbarLoaded(message: final message)) {
          // todo: add snackbar
          // Snackbar.getSnackbar(
          //   height: Constant.notificationHeight.h,
          //   iconSize: Constant.notificationIconSize.sp,
          //   message: message,
          // );
        }
      },
      child: BlocBuilder<AlarmBloc, AlarmState>(
        builder: (context, state) {
          return switch (state) {
            AlarmInitial() => const Center(child: CircularProgressIndicator()),
            AlarmLoaded(alarms: final alarms) => ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
                return AlarmWidget(
                  alarm: alarm,
                  isLast: index == alarms.length - 1,
                  toggleEnable: (enable) =>
                      context.read<AlarmBloc>().add(AlarmEnableToggled(alarm: alarm, enabled: enable)),
                  toggleWeekday: (weekday) => context.read<AlarmBloc>().add(
                    AlarmWeekdayToggled(
                      alarm: alarm,
                      weekday: weekday,
                      message: AppLocalizations.of(context)!.infoMsgWeekdayIsEmpty,
                    ),
                  ),
                );
              },
            ),
            AlarmSnackbarLoaded() => const SizedBox.shrink(),
          };
        },
      ),
    ),
    // floatingActionButton: Row(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     Container(
    //       margin: EdgeInsets.only(
    //         left: cmn.Constant.fabLeftMargin.w,
    //         bottom: cmn.Constant.fabBottomMargin.h,
    //       ),
    //       child: FloatingActionButton(
    //         heroTag: null,
    //         child: const Icon(Icons.grid_view_rounded),
    //         onPressed: () => print('change grid mode'),
    //       ),
    //     ),
    //     Container(
    //       margin: EdgeInsets.only(
    //         left: cmn.Constant.fabLeftMargin.w,
    //         bottom: cmn.Constant.fabBottomMargin.h,
    //       ),
    //       child: FloatingActionButton(
    //         heroTag: null,
    //         child: const FaIcon(FontAwesomeIcons.plus),
    //         onPressed: () => null,
    //         // {
    //         //   _formController.setTime(
    //         //     DateTime.now().add(const Duration(minutes: 10)),
    //         //   );
    //         //   getx.Get.dialog(
    //         //     barrierDismissible: false,
    //         //     cmn.DialogWidget(
    //         //       title: cmn.Message.clockCreateTitle.tr,
    //         //       contents: getx.GetX<FormController>(
    //         //         init: _formController,
    //         //         builder: (form) => ClockFormWidget(
    //         //           clock: form.clock.value,
    //         //           alarms: form.alarms,
    //         //           selectedAlarm: form.alarmSelected.value,
    //         //           hourController: form.hourController,
    //         //           minuteController: form.minuteController,
    //         //           onPressDayPeriod: form.onPressDayPeriod,
    //         //           labelController: form.labelController,
    //         //           toggleEnable: form.toggleEnable,
    //         //           toggleWeekday: form.toggleWeekday,
    //         //           toggleVibration: form.toggleVibration,
    //         //           onChangeAlarm: form.onChangeAlarm,
    //         //           playAlarm: form.alarmController.playAlarm,
    //         //           stopAlarm: form.alarmController.stopAlarm,
    //         //         ),
    //         //       ),
    //         //       footer: Row(
    //         //         mainAxisAlignment: MainAxisAlignment.end,
    //         //         crossAxisAlignment: CrossAxisAlignment.center,
    //         //         children: [
    //         //           cmn.DialogFooterButton(
    //         //             label: cmn.Message.cancel.tr,
    //         //             onPressed: () => getx.Get.back(),
    //         //           ),
    //         //           cmn.DialogFooterButton(
    //         //             label: cmn.Message.save.tr,
    //         //             onPressed: () => _formController.save(),
    //         //           ),
    //         //         ],
    //         //       ),
    //         //     ),
    //         //   );
    //         // },
    //       ),
    //     ),
    //   ],
    // ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}
