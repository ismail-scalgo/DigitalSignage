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

class OfflineEvent extends LayoutblocEvent {}

class MediaLoadingEvent extends LayoutblocEvent {}

class TakeScreenShotEvent extends LayoutblocEvent {
  int screenshoot_id;
  TakeScreenShotEvent({required this.screenshoot_id});
}

class UploadScreenShootEvent extends LayoutblocEvent {
  Uint8List capturedimage;
  int screenshoot_id;

  UploadScreenShootEvent({required this.capturedimage,required this.screenshoot_id});
}

class DownloadFeedbackEvent extends LayoutblocEvent {
  int progress;
  bool isVisible;
  String markerText;

  DownloadFeedbackEvent(
      {required this.progress,
      required this.isVisible,
      required this.markerText});
}

 
class NoBroadcastWithoutInternetEvent extends LayoutblocEvent {

}
