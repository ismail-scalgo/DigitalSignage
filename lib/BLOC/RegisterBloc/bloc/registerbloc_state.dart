part of 'registerbloc_bloc.dart';

@immutable
class RegisterblocState {}

final class RegisterblocInitial extends RegisterblocState {}

class LaunchScreen extends RegisterblocState {
  String code;
  LaunchScreen({required this.code});
}

class DisplayScreenCodeState extends RegisterblocState {
  String screenCode;
  DisplayScreenCodeState({required this.screenCode});
}

class OfflineState extends RegisterblocState {}
