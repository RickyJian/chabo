import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'common.dart';
import 'controller.dart';

class DialogWidget extends StatelessWidget {
  final String title;
  final Widget contents;
  final Widget? footer;

  final DialogController _controller = Get.put(DialogController());

  DialogWidget({required this.title, required this.contents, this.footer});

  @override
  Widget build(context) => GetX<DialogController>(
        init: _controller,
        builder: (dialogBuilder) => Column(
          children: [
            Card(
              margin: EdgeInsets.symmetric(
                vertical: Constant.dialogMarginVt.h,
                horizontal: Constant.dialogMarginHz.w,
              ),
              elevation: Constant.dialogElevation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // title
                  SizedBox(
                    height: dialogBuilder.headerHeight.value.h,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(Constant.dialogBorderRadius),
                          topRight: Radius.circular(Constant.dialogBorderRadius),
                        ),
                        boxShadow: [
                          ContainerDecoration.getBoxShadow(const Offset(0, 2)),
                        ],
                        color: Colors.yellow[200],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Constant.dialogInnerPaddingVertical.h,
                          horizontal: Constant.dialogInnerPaddingHorizontal.w,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: Constant.dialogHeaderFontSize.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // content
                  SizedBox(
                    height: dialogBuilder.contentHeight.value.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Constant.dialogInnerPaddingVertical.h,
                        horizontal: Constant.dialogInnerPaddingHorizontal.w,
                      ),
                      child: contents,
                    ),
                  ),
                  // footer
                  footer == null
                      ? Container()
                      : SizedBox(
                          height: Constant.dialogFooterHeight.h,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(Constant.dialogBorderRadius),
                                bottomRight: Radius.circular(Constant.dialogBorderRadius),
                              ),
                              boxShadow: [
                                ContainerDecoration.getBoxShadow(const Offset(0, -2)),
                              ],
                              color: Colors.yellow[200],
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(right: Constant.dialogInnerPaddingHorizontal.w),
                              child: footer,
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      );
}

class DialogFooterButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const DialogFooterButton({required this.label, this.onPressed});

  @override
  Widget build(context) => TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(Constant.dialogTextButtonPadding),
          textStyle: TextStyle(fontSize: Constant.dialogTextFontSize.sp),
        ),
        onPressed: onPressed,
        child: Text(label),
      );
}
