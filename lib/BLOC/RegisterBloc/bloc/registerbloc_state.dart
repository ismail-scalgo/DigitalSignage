part of 'registerbloc_bloc.dart';

@immutable
class RegisterblocState {
  String? agentIdErr;
  String? nameErr;
  RegisterblocState({this.agentIdErr, this.nameErr});
}

final class RegisterblocInitial extends RegisterblocState {}

class LaunchScreen extends RegisterblocState {}

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

// class TextfieldError extends RegisterblocState {
//   String? agentIdErr;
//   String? nameErr;
//   TextfieldError({this.agentIdErr, this.nameErr});
// }
