part of 'layoutbloc_bloc.dart';

@immutable
sealed class LayoutblocState {}

final class LayoutblocInitial extends LayoutblocState {}

class DisplayLayout extends LayoutblocState {
  Map<int, MediaDetails> mediaMap;
  DisplayLayout({required this.mediaMap});
}

class DefaultScreen extends LayoutblocState {}
