// ignore_for_file: must_be_immutable

part of 'registerbloc_bloc.dart';

@immutable
sealed class RegisterblocEvent {}

class RegisterUser extends RegisterblocEvent {
  RequestModel request;
  RegisterUser({required this.request});
}

class LoginUser extends RegisterblocEvent {}

class ShowSignIn extends RegisterblocEvent {}

class ShowRegister extends RegisterblocEvent {}
