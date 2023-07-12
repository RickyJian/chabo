import 'package:chabo/constant.dart';
import 'package:chabo/module/modules.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'module/home/home.dart';

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
            fontFamily: Constant.fontFamily,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
            useMaterial3: true,
          ),
          home: AppPage(),
        ),
      );
}

class AppPage extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());

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
              duration: const Duration(milliseconds: Constant.navigationDuration),
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
            children: home.clocks.map((clock) => ClockWidget(component: clock)).toList(),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: Constant.fabLeftMargin.w,
                bottom: Constant.fabBottomMargin.h,
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
                left: Constant.fabLeftMargin.w,
                bottom: Constant.fabBottomMargin.h,
              ),
              child: FloatingActionButton(
                heroTag: null,
                child: const FaIcon(
                  FontAwesomeIcons.plus,
                ),
                onPressed: () => print('open dialog'),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
}
