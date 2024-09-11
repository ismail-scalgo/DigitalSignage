part of 'layoutbloc_bloc.dart';

@immutable
sealed class LayoutblocEvent {}

class FetchApi extends LayoutblocEvent {}

class StartEvent extends LayoutblocEvent {
  LayoutData layoutdata;
  StartEvent({required this.layoutdata});
}

class EndEvent extends LayoutblocEvent {}
