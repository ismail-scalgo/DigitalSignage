import 'dart:convert';

class screenLogModels {
  String screenCode;
  String actionAt;
  String action;
  int? broadcastId; // Nullable, since it's not always present

  screenLogModels({
    required this.screenCode,
    required this.actionAt,
    required this.action,
    this.broadcastId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['screen_code'] = screenCode;
    data['action_at'] = actionAt;
    data['action'] = action;
    if (broadcastId != null) {
      data['broadcast_id'] = broadcastId;
    }
    return data;
  }
}
