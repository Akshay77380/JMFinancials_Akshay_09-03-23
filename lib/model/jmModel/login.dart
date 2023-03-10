// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

LoginJson LoginFromJson(String str) => LoginJson.fromJson(json.decode(str));

String LoginToJson(LoginJson data) => json.encode(data.toJson());

class LoginJson {
  LoginJson({
    this.status,
    this.message,
    this.watchlistFlag,
    this.errorcode,
    this.data,
  });

  bool status;
  dynamic message;
  dynamic errorcode;
  Data data;
  String watchlistFlag;

  factory LoginJson.fromJson(Map<String, dynamic> json) => LoginJson(
        status: json["status"],
        message: json["message"],
        watchlistFlag: json["watchlist_flag"],
        errorcode: json["errorcode"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "watchlist_flag": watchlistFlag,
        "errorcode": errorcode,
        "data": data.toJson(),
      };
}

class Data {
  Data({this.jwtToken, this.refreshToken, this.feedToken, this.userMsg});

  String jwtToken;
  String refreshToken;
  dynamic feedToken;
  String userMsg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(jwtToken: json["jwtToken"], refreshToken: json["refreshToken"], feedToken: json["feedToken"], userMsg: json["Usermsg"]);

  Map<String, dynamic> toJson() => {"jwtToken": jwtToken, "refreshToken": refreshToken, "feedToken": feedToken, "Usermsg": userMsg};
}
