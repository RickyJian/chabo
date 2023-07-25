import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'constant.dart';

class DialogWidget extends StatelessWidget {
  final String title;
  final Widget contents;
  final double? contentRatio;
  final Widget? footer;

  const DialogWidget({required this.title, required this.contents, this.contentRatio, this.footer});

  @override
  Widget build(context) => Column(
        children: [
          Card(
            margin: EdgeInsets.only(
              top: Constant.dialogMarginTop,
              left: Constant.dialogMarginHorizontal.w,
              right: Constant.dialogMarginHorizontal.w,
            ),
            elevation: Constant.dialogElevation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Constant.dialogHeaderHeight.h,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: const Border(
                        top: BorderSide(width: Constant.dialogBorderZeroWidth),
                        bottom: BorderSide(width: Constant.dialogBorderSectionWidth),
                        left: BorderSide(width: Constant.dialogBorderZeroWidth),
                        right: BorderSide(width: Constant.dialogBorderZeroWidth),
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(Constant.dialogBorderRadius),
                        topRight: Radius.circular(Constant.dialogBorderRadius),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0, 2),
                          blurRadius: Constant.dialogShadowBlurRadius,
                        ),
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
                SizedBox(
                  height: contentRatio ?? Constant.dialogContentHeight.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Constant.dialogInnerPaddingVertical.h,
                      horizontal: Constant.dialogInnerPaddingHorizontal.w,
                    ),
                    child: contents,
                  ),
                ),
                footer == null
                    ? Container()
                    : SizedBox(
                        height: Constant.dialogFooterHeight.h,
                        child: Container(
                          decoration: BoxDecoration(
                            border: const Border(
                              top: BorderSide(width: Constant.dialogBorderSectionWidth),
                              bottom: BorderSide(width: Constant.dialogBorderZeroWidth),
                              left: BorderSide(width: Constant.dialogBorderZeroWidth),
                              right: BorderSide(width: Constant.dialogBorderZeroWidth),
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(Constant.dialogBorderRadius),
                              bottomRight: Radius.circular(Constant.dialogBorderRadius),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0, -2),
                                blurRadius: Constant.dialogShadowBlurRadius,
                              ),
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
