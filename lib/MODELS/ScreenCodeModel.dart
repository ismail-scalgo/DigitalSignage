class FetchScreenCodeModel {
  String? screenCode;
  String? secretKey;

  FetchScreenCodeModel({this.screenCode, this.secretKey});

  FetchScreenCodeModel.fromJson(Map<String, dynamic> json) {
    screenCode = json['screen_code'];
    secretKey = json['secret_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['screen_code'] = this.screenCode;
    data['secret_key'] = this.secretKey;
    return data;
  }
}