part of 'registerbloc_bloc.dart';

@immutable
sealed class RegisterblocState {}

final class RegisterblocInitial extends RegisterblocState {}

class LaunchScreen extends RegisterblocState {}

class SignInScreen extends RegisterblocState {}

class DisplayRegistration extends RegisterblocState {}

class SuccessState extends RegisterblocState {}

class FailureState extends RegisterblocState {
  String message;
  FailureState({required this.message});
}

class PermissionDenied extends RegisterblocState {
  String message = "Permission Denied";
}
