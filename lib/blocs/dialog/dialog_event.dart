part of 'dialog_bloc.dart';

sealed class DialogEvent extends Equatable {
  const DialogEvent();

  @override
  List<Object?> get props => [];
}

final class DialogOpened extends DialogEvent {
  final DialogModel model;
  final String? formId;

  const DialogOpened({required this.model, this.formId});

  @override
  List<Object?> get props => [model, formId];
}

final class KeyboardChanged extends DialogEvent {
  final double height;

  const KeyboardChanged({required this.height});

  @override
  List<Object?> get props => [height];
}

final class DialogClosed extends DialogEvent {}
