import 'package:chabo/constant.dart';
import 'package:chabo/module/modules.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(context) => Sizer(
        builder: (context, orientation, deviceType) => GetMaterialApp(
          title: Constant.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
            useMaterial3: true,
          ),
          home: AppPage(),
        ),
      );
}

class AppPage extends StatelessWidget {
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
          title: Text(Constant.appName),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
        ),
        body: Center(
          child: Text('Alarm clock list page'),
        ),
        floatingActionButton: Column(
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
