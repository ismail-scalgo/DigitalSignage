// ignore_for_file: must_be_immutable

part of 'registerbloc_bloc.dart';

@immutable
sealed class RegisterblocEvent {}

class RegisterUser extends RegisterblocEvent {
  RequestModel request;
  RegisterUser({required this.request});
}

class LoginUser extends RegisterblocEvent {
  String screenCode;
  LoginUser({required this.screenCode});
}

class GetScreenCode extends RegisterblocEvent {
  GetScreenCode();
}

class DisplayScreenCode extends RegisterblocEvent {
  String screenCode;
  DisplayScreenCode({required this.screenCode});
}

class LaunchSignage extends RegisterblocEvent {
  String screenCode;
  LaunchSignage({required this.screenCode});
}

class ConnectSocket extends RegisterblocEvent {
  String screenCode;
  ConnectSocket({required this.screenCode});
}

class OfflineEvent extends RegisterblocEvent {}

class CheckDeviceStatusEvent extends RegisterblocEvent {}

class InterNetStatusEvent extends RegisterblocEvent {}
