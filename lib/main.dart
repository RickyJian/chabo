import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chabo/l10n/app_localizations.dart';
import 'package:chabo/models/models.dart';
import 'blocs/blocs.dart';
import 'module/common/common.dart' as cmn;
import 'screens/screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),
      builder: (context, child) {
        DeviceModel.init(context: context);
        return MultiBlocProvider(
          providers: [
            BlocProvider<AlarmClockBloc>(create: (context) => AlarmClockBloc()..add(const AlarmClockListed())),
            BlocProvider<DialogBloc>(create: (context) => DialogBloc()),
          ],
          child: MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('zh')],
            locale: const Locale('en'),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: cmn.Constant.fontFamily,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
              useMaterial3: true,
            ),
            home: child,
          ),
        );
      },
      child: const HomeScreen(),
    );
  }
}

// class AppPage extends StatelessWidget {
//   final HomeController _homeController = getx.Get.put(HomeController());
//   final FormController _formController = getx.Get.put(
//     FormController(alarmTag: 'new'),
//   );

//   @override
//   Widget build(context) => Scaffold(
//     appBar: AppBar(
//       leading: IconButton(
//         icon: const FaIcon(FontAwesomeIcons.bars),
//         alignment: Alignment.center,
//         onPressed: () => getx.Get.to(
//           SettingPage(),
//           duration: const Duration(
//             milliseconds: cmn.Constant.navigationDuration,
//           ),
//           transition: getx.Transition.leftToRight,
//         ),
//       ),
//       title: Text(Message.appTitle.tr),
//       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       centerTitle: true,
//     ),
//     body: BlocBuilder<AlarmBloc, AlarmState>(
//       builder: (context, state) {
//         return switch (state) {
//           AlarmInitial() => const Center(child: CircularProgressIndicator()),
//           AlarmListLoaded(alarms: final alarms) => ListView.builder(
//             itemCount: alarms.length,
//             itemBuilder: (context, index) {
//               final alarm = alarms[index];
//               return ClockWidget(
//                 component: ClockComponent.fromAlarm(alarm),
//                 isLast: index == alarms.length - 1,
//                 toggleEnable: (enabled) => context.read<AlarmBloc>().add(
//                   AlarmEnableToggled(alarm: alarm, enabled: enabled),
//                 ),
//                 toggleWeekday: (weekday) => context.read<AlarmBloc>().add(
//                   AlarmWeekdayToggled(alarm: alarm, weekday: weekday),
//                 ),
//               );
//             },
//           ),
//         };
//       },
//     ),

//     // getx.GetX<HomeController>(
//     //   init: _homeController,
//     //   builder: (home) => ListView(
//     //     children: home.clocks
//     //         .map(
//     //           (clock) => ClockWidget(
//     //             component: clock,
//     //             isLast: home.clocks.indexOf(clock) == home.clocks.length - 1,
//     //             toggleEnable: (enabled) => home.toggleEnable(clock, enabled),
//     //             toggleWeekday: (weekday) => home.toggleWeekday(clock, weekday),
//     //           ),
//     //         )
//     //         .toList(),
//     //   ),
//     // ),
//     floatingActionButton: Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Container(
//           margin: EdgeInsets.only(
//             left: cmn.Constant.fabLeftMargin.w,
//             bottom: cmn.Constant.fabBottomMargin.h,
//           ),
//           child: FloatingActionButton(
//             heroTag: null,
//             child: const Icon(Icons.grid_view_rounded),
//             onPressed: () => print('change grid mode'),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(
//             left: cmn.Constant.fabLeftMargin.w,
//             bottom: cmn.Constant.fabBottomMargin.h,
//           ),
//           child: FloatingActionButton(
//             heroTag: null,
//             child: const FaIcon(FontAwesomeIcons.plus),
//             onPressed: () {
//               _formController.setTime(
//                 DateTime.now().add(const Duration(minutes: 10)),
//               );
//               getx.Get.dialog(
//                 barrierDismissible: false,
//                 cmn.DialogWidget(
//                   title: cmn.Message.clockCreateTitle.tr,
//                   contents: getx.GetX<FormController>(
//                     init: _formController,
//                     builder: (form) => ClockFormWidget(
//                       clock: form.clock.value,
//                       alarms: form.alarms,
//                       selectedAlarm: form.alarmSelected.value,
//                       hourController: form.hourController,
//                       minuteController: form.minuteController,
//                       onPressDayPeriod: form.onPressDayPeriod,
//                       labelController: form.labelController,
//                       toggleEnable: form.toggleEnable,
//                       toggleWeekday: form.toggleWeekday,
//                       toggleVibration: form.toggleVibration,
//                       onChangeAlarm: form.onChangeAlarm,
//                       playAlarm: form.alarmController.playAlarm,
//                       stopAlarm: form.alarmController.stopAlarm,
//                     ),
//                   ),
//                   footer: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       cmn.DialogFooterButton(
//                         label: cmn.Message.cancel.tr,
//                         onPressed: () => getx.Get.back(),
//                       ),
//                       cmn.DialogFooterButton(
//                         label: cmn.Message.save.tr,
//                         onPressed: () => _formController.save(),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//     floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//   );
// }
