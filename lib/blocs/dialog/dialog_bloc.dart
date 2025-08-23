import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:chabo/models/models.dart';
import 'dart:async';

part 'dialog_event.dart';
part 'dialog_state.dart';

class DialogBloc extends Bloc<DialogEvent, DialogState> {
  static const keyboardEventChannel = EventChannel('chabo/keyboard');
  StreamSubscription? _keyboardSubscription;

  DialogBloc() : super(DialogClose()) {
    on<DialogOpened>(_onDialogOpened);
    on<DialogClosed>(_onDialogClosed);
    on<KeyboardChanged>(_onKeyboardChanged);
  }

  void _startKeyboardListener(DialogModel model) {
    _keyboardSubscription = keyboardEventChannel.receiveBroadcastStream().listen((data) {
      if (data is! int) {
        Exception('channel wrong type');
      }

      /// content 剩餘高度：螢幕高度 - camera 缺口高度 - dialog header 高度 - keyboard 高度 - dialog footer 高度
      var remainingHeight =
          DeviceModel.screenHeight -
          DeviceModel.statusBarHeight -
          DeviceModel.bottomSafeAreaHeight -
          (model.titleHeight) -
          (data.toDouble() / DeviceModel.devicePixelRatio) -
          (model.footerHeight ?? 0);
      if (remainingHeight == model.fallbackHeight) {
        // do nothing
      } else if (remainingHeight < model.fallbackHeight) {
        add(KeyboardChanged(height: remainingHeight));
      } else if (remainingHeight > model.fallbackHeight) {
        add(KeyboardChanged(height: model.fallbackHeight));
      }
    });
  }

  void _stopKeyboardListener() {
    _keyboardSubscription?.cancel();
    _keyboardSubscription = null;
  }

  void _onDialogOpened(DialogOpened event, Emitter<DialogState> emit) {
    emit(DialogReady(model: event.model));
    _startKeyboardListener(event.model);
  }

  void _onDialogClosed(DialogClosed event, Emitter<DialogState> emit) {
    _stopKeyboardListener();
    emit(DialogClose());
  }

  void _onKeyboardChanged(KeyboardChanged event, Emitter<DialogState> emit) {
    if (state case DialogReady(model: final model)) {
      emit(DialogResized(model: model.copyWith(contentHeight: event.height)));
    } else if (state case DialogResized(model: final model)) {
      emit(DialogResized(model: model.copyWith(contentHeight: event.height)));
    }
  }
}
