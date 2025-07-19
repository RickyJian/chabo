import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chabo/module/common/constant.dart';

class Snackbar {
  Snackbar._();

  static void getSnackbar({required double height, required double iconSize, required String message}) {
    Get.rawSnackbar(
      messageText: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Icon(Icons.info_outline_rounded, color: Colors.white, size: iconSize),
            ),
            const Padding(padding: EdgeInsets.only(right: Constant.notificationTextPadding)),
            Expanded(
              flex: 9,
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      margin: EdgeInsets.only(
        left: Constant.notificationMarginWidth.w,
        right: Constant.notificationMarginWidth.w,
        bottom: Constant.notificationMarginBottom.h,
      ),
      boxShadows: [
        const BoxShadow(
          color: Colors.black54,
          offset: Offset(0, 10),
          spreadRadius: Constant.notificationBoxShadowSpreadRadius,
          blurRadius: Constant.notificationBoxShadowBlurRadius,
        ),
      ],
      borderRadius: Constant.notificationBorderRadius,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      duration: const Duration(seconds: 2),
    );
  }
}
