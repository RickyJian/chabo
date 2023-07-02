import 'package:chabo/constant.dart';
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
          title: Text(Constant.appName),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_vert_rounded,
              ),
              alignment: Alignment.topRight,
              onPressed: () => print('go to action'),
            ),
          ],
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
                child: Icon(
                  Icons.grid_view,
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
                child: Icon(
                  Icons.add,
                ),
                onPressed: () => print('open dialog'),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      );
}
