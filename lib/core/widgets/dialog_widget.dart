import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chabo/models/models.dart';
import 'constant.dart';

class DialogWidget extends StatelessWidget {
  final DialogModel model;

  const DialogWidget({required this.model});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Card(
        margin: EdgeInsets.symmetric(vertical: Constant.dialogMarginVt.h, horizontal: Constant.dialogMarginHz.w),
        elevation: Constant.dialogElevation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 標題(title)
            SizedBox(
              height: model.titleHeight,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(Constant.dialogBorderRadius),
                    topRight: Radius.circular(Constant.dialogBorderRadius),
                  ),
                  // 若 ContainerDecoration 未定義，請自行實作陰影
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, 2), blurRadius: 4),
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
                      model.title,
                      style: TextStyle(fontSize: Constant.dialogHeaderFontSize.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            // 內容(content)
            SizedBox(
              height: model.contentHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Constant.dialogInnerPaddingVertical.h,
                  horizontal: Constant.dialogInnerPaddingHorizontal.w,
                ),
                child: model.contents,
              ),
            ),
            // 頁腳(footer)
            model.footer == null
                ? SizedBox.shrink()
                : SizedBox(
                    height: model.footerHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(Constant.dialogBorderRadius),
                          bottomRight: Radius.circular(Constant.dialogBorderRadius),
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), offset: const Offset(0, -2), blurRadius: 4),
                        ],
                        color: Colors.yellow[200],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(right: Constant.dialogInnerPaddingHorizontal.w),
                        child: model.footer,
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
