import 'package:chabo/module/common/common.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DialogController extends GetxController {
  static const keyboardEventChannel = EventChannel('chabo/keyboard');

  var headerHeight = Constant.dialogHeaderHeight.obs;
  var contentHeight = Constant.dialogContentHeight.obs;
  var footerHeight = Constant.dialogFooterHeight.obs;

  @override
  void onInit() {
    super.onInit();
    keyboardEventChannel.receiveBroadcastStream().listen((data) {
      if (data is! int) {
        Exception('channel wrong type');
      }

      // content 剩餘高度：螢幕高度 - camera 缺口高度 - dialog margin(上下) - dialog header 高度 - keyboard 高度 - dialog footer 高度
      var remainingHeight = Get.height -
          Get.mediaQuery.viewPadding.top -
          Constant.dialogMarginVt * 2 -
          Constant.dialogHeaderHeight -
          (data.toDouble() / Get.pixelRatio) -
          Constant.dialogFooterHeight;
      if (Constant.dialogContentHeight > remainingHeight) {
        contentHeight.value = remainingHeight;
      } else {
        contentHeight.value = Constant.dialogContentHeight;
      }
    });
  }
}
