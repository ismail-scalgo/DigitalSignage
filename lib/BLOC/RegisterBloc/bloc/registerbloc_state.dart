part of 'registerbloc_bloc.dart';

@immutable
class RegisterblocState {
  String? agentIdErr;
  String? nameErr;
  String? screenCodeErr;
  RegisterblocState({this.agentIdErr, this.nameErr, this.screenCodeErr});
}

final class RegisterblocInitial extends RegisterblocState {}

class LaunchScreen extends RegisterblocState {
  String code;
  LaunchScreen({required this.code});
}

class SignInScreen extends RegisterblocState {}

class DisplayRegistration extends RegisterblocState {}

class SuccessState extends RegisterblocState {}

class FailureState extends RegisterblocState {
  String message;
  FailureState({required this.message});
}

class loginFailureState extends RegisterblocState {
  String message;
  loginFailureState({required this.message});
}

class PermissionDenied extends RegisterblocState {
  String message = "Permission Denied";
  // PlatformType currentPlatformType;
  // PermissionDenied({ required this.currentPlatformType});
}

class RegisterLoadingState extends RegisterblocState {}

class LoginLoadingState extends RegisterblocState {}

class DisplayNewScreenCode extends RegisterblocState {
  String screenCode;
  DisplayNewScreenCode({required this.screenCode});
}

class DisplayOldScreenCode extends RegisterblocState {
  String screenCode;
  DisplayOldScreenCode({required this.screenCode});
}
