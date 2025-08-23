part of 'dialog_bloc.dart';

sealed class DialogEvent extends Equatable {
  const DialogEvent();

  @override
  List<Object?> get props => [];
}

final class DialogOpened extends DialogEvent {
  final DialogModel model;

  const DialogOpened({required this.model});

  @override
  List<Object?> get props => [model];
}

final class KeyboardChanged extends DialogEvent {
  final double height;

  const KeyboardChanged({required this.height});

  @override
  List<Object?> get props => [height];
}

final class DialogClosed extends DialogEvent {}
