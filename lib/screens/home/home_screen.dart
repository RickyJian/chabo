import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chabo/blocs/blocs.dart';
import 'package:chabo/screens/home/widgets/widgets.dart';
import 'package:chabo/l10n/app_localizations.dart';
import 'package:chabo/core/core.dart' as core;
import 'package:chabo/models/models.dart';

import 'constant.dart';

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
    body: BlocListener<AlarmClockBloc, AlarmClockState>(
      listenWhen: (previous, current) => current is AlarmClockSnackbarLoaded,
      listener: (context, state) {
        if (state case AlarmClockSnackbarLoaded(message: final message)) {
          core.Snackbar.showSnackbar(context: context, height: Constant.notificationHeight, message: message);
        }
      },
      child: BlocBuilder<AlarmClockBloc, AlarmClockState>(
        builder: (context, state) {
          return switch (state) {
            AlarmClockInitial() => const Center(child: CircularProgressIndicator()),
            AlarmClockListLoaded(clocks: final clocks) => ListView.builder(
              itemCount: clocks.length,
              itemBuilder: (context, index) {
                final clock = clocks[index];
                return AlarmListWidget(
                  clock: clock,
                  isLast: index == clocks.length - 1,
                  toggleEnable: (enable) =>
                      context.read<AlarmClockBloc>().add(AlarmClockEnableToggled(clock: clock, enabled: enable)),
                  toggleWeekday: (weekday) => context.read<AlarmClockBloc>().add(
                    AlarmClockWeekdayToggled(
                      clock: clock,
                      weekday: weekday,
                      message: AppLocalizations.of(context)!.infoMsgWeekdayIsEmpty,
                    ),
                  ),
                );
              },
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    ),
    floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(left: Constant.fabLeftMargin.w, bottom: Constant.fabBottomMargin.h),
          child: FloatingActionButton(
            heroTag: null,
            child: const Icon(Icons.grid_view_rounded),
            onPressed: () => print('change grid mode'),
          ),
        ),
        BlocListener<DialogBloc, DialogState>(
          listener: (context, dialogState) {
            switch (dialogState) {
              case DialogClose():
                Navigator.of(context).pop();
              case DialogReady():
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => BlocBuilder<DialogBloc, DialogState>(
                    builder: (context, state) {
                      if (state case (DialogReady(model: final model) || DialogResized(model: final model))) {
                        return core.DialogWidget(
                          model: model.copyWith(
                            contents: BlocBuilder<AlarmClockFormBloc, AlarmClockFormState>(
                              builder: (context, state) {
                                switch (state) {
                                  case AlarmClockFormLoading():
                                    debugPrint('=1=AlarmClockFormLoading');
                                    return AlarmEditWidget(
                                      form: AlarmClockForm.init(clock: AlarmClock.init(TimeOfDay.now())),
                                    );
                                  case AlarmClockFormLoaded(form: final form):
                                    debugPrint('=2=AlarmClockFormLoaded');
                                    return AlarmEditWidget(form: form);
                                  default:
                                    return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                );
              default:
              // do nothing
            }
          },
          child: BlocBuilder<DialogBloc, DialogState>(
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.only(left: Constant.fabLeftMargin.w, bottom: Constant.fabBottomMargin.h),
                child: FloatingActionButton(
                  heroTag: null,
                  child: const FaIcon(FontAwesomeIcons.plus),
                  onPressed: () {
                    final clock = AlarmClock.init(TimeOfDay.now());
                    context.read<AlarmClockFormBloc>().add(
                      AlarmClockDialogOpened(
                        form: AlarmClockForm.init(
                          clock: clock,
                          onPressDayPeriod: (index) =>
                              context.read<AlarmClockFormBloc>().add(AlarmClockDayPeriodPressed(index: index)),
                          toggleEnable: (enabled) =>
                              context.read<AlarmClockFormBloc>().add(AlarmClockFormEnableToggled(enabled: enabled)),
                          toggleWeekday: (weekday) => context.read<AlarmClockFormBloc>().add(
                            AlarmClockFormWeekdayToggled(
                              weekday: weekday,
                              message: AppLocalizations.of(context)!.infoMsgWeekdayIsEmpty,
                            ),
                          ),
                          toggleVibration: (vibration) => context.read<AlarmClockFormBloc>().add(
                            AlarmClockFormVibrationToggled(vibration: vibration),
                          ),
                          changeRingtone: (ringtone) =>
                              context.read<AlarmClockFormBloc>().add(AlarmClockFormRingtoneChanged(ringtone: ringtone)),
                          playRingtone: (ringtone) =>
                              context.read<AlarmClockFormBloc>().add(AlarmClockFormRingtonePlayed(ringtone: ringtone)),
                          stopRingtone: () => context.read<AlarmClockFormBloc>().add(AlarmClockFormRingtoneStopped()),
                        ),
                      ),
                    );
                    context.read<DialogBloc>().add(
                      DialogOpened(
                        model: DialogModel(
                          title: AppLocalizations.of(context)!.clockCreateTitle,
                          titleHeight: Constant.dialogHeaderHeight.h,
                          contentHeight: Constant.dialogContentHeight.h,
                          fallbackHeight: Constant.dialogContentHeight.h,
                          footer: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              core.DialogFooterButton(
                                label: AppLocalizations.of(context)!.cancel,
                                onPressed: () => context.read<DialogBloc>().add(DialogClosed()),
                              ),
                              // todo: 之後用鬧鐘區塊(Alarm Bloc)來儲存鬧鐘(alarm)
                              core.DialogFooterButton(label: AppLocalizations.of(context)!.save, onPressed: () => null),
                            ],
                          ),
                          footerHeight: Constant.dialogFooterHeight.h,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
  );
}
