import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chabo/blocs/blocs.dart';
import 'package:chabo/screens/home/widgets/widgets.dart';
import 'package:chabo/l10n/app_localizations.dart';
import 'package:chabo/core/widgets/widgets.dart';
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
    body: BlocListener<AlarmBloc, AlarmState>(
      listenWhen: (previous, current) => current is AlarmSnackbarLoaded,
      listener: (context, state) {
        if (state case AlarmSnackbarLoaded(message: final message)) {
          Snackbar.showSnackbar(context: context, height: Constant.notificationHeight, message: message);
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
          listener: (context, state) {
            switch (state) {
              case DialogClose():
                Navigator.of(context).pop();
              case DialogReady():
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => BlocBuilder<DialogBloc, DialogState>(
                    builder: (context, dialogState) {
                      if (dialogState case (DialogReady(model: final model) || DialogResized(model: final model))) {
                        return DialogWidget(model: model);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                );
              default:
            }
          },
          child: BlocBuilder<DialogBloc, DialogState>(
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.only(left: Constant.fabLeftMargin.w, bottom: Constant.fabBottomMargin.h),
                child: FloatingActionButton(
                  heroTag: null,
                  child: const FaIcon(FontAwesomeIcons.plus),
                  onPressed: () => context.read<DialogBloc>().add(
                    DialogOpened(
                      model: DialogModel(
                        title: AppLocalizations.of(context)!.clockCreateTitle,
                        titleHeight: Constant.dialogHeaderHeight.h,
                        contents: Container(), // todo: use alarm form widget
                        contentHeight: Constant.dialogContentHeight.h,
                        fallbackHeight: Constant.dialogContentHeight.h,
                        footer: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DialogFooterButton(
                              label: AppLocalizations.of(context)!.cancel,
                              onPressed: () => context.read<DialogBloc>().add(DialogClosed()),
                            ),
                            // todo: use alarm bloc to save alarm
                            DialogFooterButton(label: AppLocalizations.of(context)!.save, onPressed: () => null),
                          ],
                        ),
                        footerHeight: Constant.dialogFooterHeight.h,
                      ),
                    ),
                  ),
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
