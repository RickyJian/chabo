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
  Widget build(context) => MultiBlocListener(
    listeners: [
      BlocListener<DialogBloc, DialogState>(
        listener: (context, dialogState) {
          switch (dialogState) {
            case DialogClose():
              Navigator.of(context, rootNavigator: true).pop();
            case DialogReady():
              showDialog(
                useRootNavigator: true,
                barrierDismissible: false,
                context: context,
                builder: (_) => BlocBuilder<DialogBloc, DialogState>(
                  builder: (_, state) {
                    if (state case (DialogReady(model: final model) || DialogResized(model: final model))) {
                      return core.DialogWidget(
                        model: model.copyWith(
                          contents: BlocBuilder<AlarmClockFormBloc, AlarmClockFormState>(
                            builder: (_, state) {
                              switch (state) {
                                case AlarmClockFormLoading():
                                  return const Center(child: CircularProgressIndicator());
                                case AlarmClockFormLoaded(clock: final clock, ringtones: final ringtones):
                                  return AlarmEditWidget(
                                    form: AlarmClockForm.init(
                                      clock: clock,
                                      ringtones: ringtones,
                                      onHourChanged: (value) => context.read<AlarmClockFormBloc>().add(
                                        AlarmClockFormHourChanged(value: value),
                                      ),
                                      onMinuteChanged: (value) => context.read<AlarmClockFormBloc>().add(
                                        AlarmClockFormMinuteChanged(value: value),
                                      ),
                                      onLabelChanged: (value) => context.read<AlarmClockFormBloc>().add(
                                        AlarmClockFormLabelChanged(value: value),
                                      ),
                                      onPressDayPeriod: (index) => context.read<AlarmClockFormBloc>().add(
                                        AlarmClockDayPeriodPressed(index: index),
                                      ),
                                      toggleEnable: (enabled) => context.read<AlarmClockFormBloc>().add(
                                        AlarmClockFormEnableToggled(enabled: enabled),
                                      ),
                                      toggleWeekday: (weekday) => context.read<AlarmClockFormBloc>().add(
                                        AlarmClockFormWeekdayToggled(
                                          weekday: weekday,
                                          message: AppLocalizations.of(context)!.infoMsgWeekdayIsEmpty,
                                        ),
                                      ),
                                      toggleVibration: (vibration) => context.read<AlarmClockFormBloc>().add(
                                        AlarmClockFormVibrationToggled(vibration: vibration),
                                      ),
                                      changeRingtone: (ringtone) => context.read<AlarmClockFormBloc>().add(
                                        AlarmClockFormRingtoneChanged(ringtone: ringtone),
                                      ),
                                      playRingtone: (ringtone) => context.read<AlarmClockFormBloc>().add(
                                        AlarmClockFormRingtonePlayed(ringtone: ringtone),
                                      ),
                                      stopRingtone: () =>
                                          context.read<AlarmClockFormBloc>().add(AlarmClockFormRingtoneStopped()),
                                    ),
                                  );
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
      ),
      BlocListener<AlarmClockFormBloc, AlarmClockFormState>(
        listenWhen: (previous, current) {
          if (current is AlarmClockFormLoaded && current.errorCode != null) {
            return true;
          }
          return current is AlarmClockFormSuccess;
        },
        listener: (context, formState) {
          switch (formState) {
            case AlarmClockFormSuccess():
              // 關閉 Dialog
              context.read<DialogBloc>().add(DialogClosed());
              // 列表重新載入
              context.read<AlarmClockBloc>().add(AlarmClockListed());
            case AlarmClockFormLoaded(errorCode: final errorCode):
              // 跳出提示訊息
              switch (errorCode) {
                case core.AlarmClockFormErrorCode.hourInvalid:
                  core.Snackbar.showSnackbar(
                    context: context,
                    height: Constant.notificationHeight,
                    message: AppLocalizations.of(context)!.errMsgHourInvalid,
                  );
                  break;
                case core.AlarmClockFormErrorCode.hourOutOfRange:
                  core.Snackbar.showSnackbar(
                    context: context,
                    height: Constant.notificationHeight,
                    message: AppLocalizations.of(context)!.errMsgHourOutOfRange,
                  );
                  break;
                case core.AlarmClockFormErrorCode.minuteInvalid:
                  core.Snackbar.showSnackbar(
                    context: context,
                    height: Constant.notificationHeight,
                    message: AppLocalizations.of(context)!.errMsgMinuteInvalid,
                  );
                  break;
                case core.AlarmClockFormErrorCode.minuteOutOfRange:
                  core.Snackbar.showSnackbar(
                    context: context,
                    height: Constant.notificationHeight,
                    message: AppLocalizations.of(context)!.errMsgMinuteOutOfRange,
                  );
                  break;
                case core.AlarmClockFormErrorCode.labelOutOfLength:
                  core.Snackbar.showSnackbar(
                    context: context,
                    height: Constant.notificationHeight,
                    message: AppLocalizations.of(context)!.errMsgLabelOutOfLength,
                  );
                  break;
                default:
                  core.Snackbar.showSnackbar(
                    context: context,
                    height: Constant.notificationHeight,
                    message: AppLocalizations.of(context)!.errMsgUnknown,
                  );
                  break;
              }
            default:
            // do nothing
          }
        },
      ),
    ],
    child: Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: BlocListener<AlarmClockBloc, AlarmClockState>(
        listenWhen: (previous, current) {
          return current is AlarmClockSnackbarLoaded;
        },
        listener: (context, state) {
          switch (state) {
            case AlarmClockSnackbarLoaded(message: final message):
              core.Snackbar.showSnackbar(context: context, height: Constant.notificationHeight, message: message);
            default:
            // do nothing
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
                    openDialog: (id) {
                      context.read<AlarmClockFormBloc>().add(AlarmClockDialogOpened(id: id));
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
                                core.DialogFooterButton(
                                  label: AppLocalizations.of(context)!.save,
                                  onPressed: () =>
                                      context.read<AlarmClockFormBloc>().add(AlarmClockFormUpdated(clock: clock)),
                                ),
                              ],
                            ),
                            footerHeight: Constant.dialogFooterHeight.h,
                          ),
                        ),
                      );
                    },
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
          BlocBuilder<DialogBloc, DialogState>(
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.only(left: Constant.fabLeftMargin.w, bottom: Constant.fabBottomMargin.h),
                child: FloatingActionButton(
                  heroTag: null,
                  child: const FaIcon(FontAwesomeIcons.plus),
                  onPressed: () {
                    context.read<AlarmClockFormBloc>().add(AlarmClockDialogOpened());
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
                              core.DialogFooterButton(
                                label: AppLocalizations.of(context)!.save,
                                onPressed: () => context.read<AlarmClockFormBloc>().add(AlarmClockFormAdded()),
                              ),
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ),
  );
}
