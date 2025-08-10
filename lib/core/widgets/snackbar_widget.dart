import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'constant.dart';

class Snackbar {
  Snackbar._();

  static void showSnackbar({required BuildContext context, required double height, required String message}) {
    final snackBar = SnackBar(
      content: SizedBox(
        height: height.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.info_outline_rounded, color: Colors.white, size: Constant.notificationIconSize.w),
            const Padding(padding: EdgeInsets.only(right: Constant.notificationTextPadding)),
            Expanded(
              child: Text(
                message,
                // todo: consider to make font size auto fit to the message
                style: TextStyle(fontSize: Constant.notificationTextSize.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black87,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.fixed,
      elevation: Constant.notificationBoxShadowSpreadRadius,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
