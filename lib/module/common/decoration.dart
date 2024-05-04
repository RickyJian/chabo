import 'package:flutter/material.dart';
import 'common.dart';

class ContainerDecoration {
  ContainerDecoration._();

  static BoxShadow getBoxShadow(Offset offset) {
    return BoxShadow(
      color: Colors.black54,
      offset: offset,
      blurRadius: Constant.dialogShadowBlurRadius,
    );
  }
}
