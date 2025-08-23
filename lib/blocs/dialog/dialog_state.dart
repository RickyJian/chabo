part of 'dialog_bloc.dart';

sealed class DialogState extends Equatable {
  const DialogState();

  @override
  List<Object?> get props => [];
}

final class DialogClose extends DialogState {}

final class DialogReady extends DialogState {
  final DialogModel model;

  const DialogReady({required this.model});

  @override
  List<Object?> get props => [model];
}

final class DialogResized extends DialogState {
  final DialogModel model;

  const DialogResized({required this.model});

  @override
  List<Object?> get props => [model];
}
