part of 'registerbloc_bloc.dart';

@immutable
sealed class RegisterblocState {}

final class RegisterblocInitial extends RegisterblocState {}

class LaunchScreen extends RegisterblocState {}

class SignInScreen extends RegisterblocState {}

class DisplayRegistration extends RegisterblocState {}
