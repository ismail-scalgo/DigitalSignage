// ignore_for_file: camel_case_types

part of 'layoutbloc_bloc.dart';

@immutable
sealed class LayoutblocEvent {}

class FetchApi extends LayoutblocEvent {
  String screenCode;
  FetchApi({required this.screenCode});
}

class StartEvent extends LayoutblocEvent {
  LayoutData layoutdata;
  StartEvent({required this.layoutdata});
}

class EndEvent extends LayoutblocEvent {}

class visibleButton extends LayoutblocEvent {
  bool isvisible;
  visibleButton({required this.isvisible});
}

class ShrinkView extends LayoutblocEvent {
  bool isvisible;
  ShrinkView({required this.isvisible});
}

class CountDownEvent extends LayoutblocEvent {
  int countdown;

  CountDownEvent({required this.countdown});
}

class NoBroadCastEvent extends LayoutblocEvent {}

class DisplayBroadcastEvent extends LayoutblocEvent {
  LayoutData layoutData;

  DisplayBroadcastEvent({required this.layoutData});
}

class currentBroadCastEnds extends LayoutblocEvent {
  String current_datetime;

  currentBroadCastEnds({required this.current_datetime});
}

class FetchNextBroadcastEvent extends LayoutblocEvent {
  LayoutData previousLayout;

  FetchNextBroadcastEvent({required this.previousLayout});
}

class LogoutEvent extends LayoutblocEvent {}

class TrasnsitionEvent extends LayoutblocEvent {}
