part of 'alarm_clock_form_bloc.dart';

sealed class AlarmClockFormState extends Equatable {
  const AlarmClockFormState();

  @override
  List<Object?> get props => [];
}

class AlarmClockFormInitial extends AlarmClockFormState {}

class AlarmClockFormLoading extends AlarmClockFormState {}

class AlarmClockFormLoaded extends AlarmClockFormState {
  final AlarmClockForm form;
  final core.AlarmClockFormErrorCode? errorCode;

  const AlarmClockFormLoaded({required this.form, this.errorCode});

  @override
  List<Object?> get props => [form];
}

class AlarmClockFormSuccess extends AlarmClockFormState {}
