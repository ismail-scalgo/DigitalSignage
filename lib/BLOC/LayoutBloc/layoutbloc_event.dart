part of 'layoutbloc_bloc.dart';

@immutable
sealed class LayoutblocEvent {}

class FetchApi extends LayoutblocEvent {}

class StartEvent extends LayoutblocEvent {
  Map<int, MediaDetails> contentsMap;
  StartEvent({required this.contentsMap});
}

class EndEvent extends LayoutblocEvent {}
