part of 'layoutbloc_bloc.dart';

@immutable
sealed class LayoutblocState {}

final class LayoutblocInitial extends LayoutblocState {}

class DisplayLayout extends LayoutblocState {
  LayoutData layoutdata;
  DisplayLayout({required this.layoutdata});
}

class DefaultScreen extends LayoutblocState {
  int countdown;
  DefaultScreen({required this.countdown});
}

class DisplayButton extends LayoutblocState {
  bool isvisible;
  DisplayButton({required this.isvisible});
}

class Minimizescreen extends LayoutblocState {
  bool isvisible;
  Minimizescreen({required this.isvisible});
}

class NoBroadcastState extends LayoutblocState {}

class TrasitionState extends LayoutblocState {}
