import 'package:chabo/module/modules.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'module/home/home.dart';
import 'module/common/common.dart' as cmn;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(context) => Sizer(
        builder: (context, orientation, deviceType) => GetMaterialApp(
          title: 'Chabo',
          translations: Message(),
          locale: Message.englishLocale,
          fallbackLocale: Message.englishLocale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: cmn.Constant.fontFamily,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
            useMaterial3: true,
          ),
          home: AppPage(),
        ),
      );
}

class AppPage extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  final FormController _formController = Get.put(FormController());

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.bars,
            ),
            alignment: Alignment.center,
            onPressed: () => Get.to(
              SettingPage(),
              duration: const Duration(milliseconds: cmn.Constant.navigationDuration),
              transition: Transition.leftToRight,
            ),
          ),
          title: Text(Message.appTitle.tr),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
        ),
        body: GetX<HomeController>(
          init: _homeController,
          builder: (home) => ListView(
            children: home.clocks
                .map((clock) =>
                    ClockWidget(component: clock, isLast: home.clocks.indexOf(clock) == home.clocks.length - 1))
                .toList(),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: cmn.Constant.fabLeftMargin.w,
                bottom: cmn.Constant.fabBottomMargin.h,
              ),
              child: FloatingActionButton(
                heroTag: null,
                child: const Icon(
                  Icons.grid_view_rounded,
                ),
                onPressed: () => print('change grid mode'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: cmn.Constant.fabLeftMargin.w,
                bottom: cmn.Constant.fabBottomMargin.h,
              ),
              child: FloatingActionButton(
                heroTag: null,
                child: const FaIcon(
                  FontAwesomeIcons.plus,
                ),
                onPressed: () {
                  _formController.setTime(DateTime.now().add(const Duration(minutes: 10)));
                  Get.dialog(
                    barrierDismissible: false,
                    cmn.DialogWidget(
                      title: cmn.Message.clockCreateTitle.tr,
                      contents: GetX<FormController>(
                        init: _formController,
                        builder: (form) => ClockFormWidget(
                          clock: form.clock.value,
                          hourController: form.hourController,
                          minuteController: form.minuteController,
                          onPressDayPeriod: form.onPressDayPeriod,
                          toggleEnable: form.toggleEnable,
                          toggleWeekday: form.toggleWeekday,
                          toggleVibration: form.toggleVibration,
                        ),
                      ),
                      footer: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          cmn.DialogFooterButton(
                            label: cmn.Message.cancel.tr,
                            onPressed: () => Get.back(),
                          ),
                          cmn.DialogFooterButton(
                            label: cmn.Message.save.tr,
                            onPressed: () => _formController.save(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
}
