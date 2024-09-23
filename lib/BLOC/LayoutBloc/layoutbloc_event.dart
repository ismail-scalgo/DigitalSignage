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
