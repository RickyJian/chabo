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

  const AlarmClockFormLoaded({required this.form});

  @override
  List<Object?> get props => [form];
}
