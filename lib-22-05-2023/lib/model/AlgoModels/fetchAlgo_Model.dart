// To parse this JSON data, do
//
//     final fetchAlgo = fetchAlgoFromJson(jsonString);

import 'dart:convert';

FetchAlgo fetchAlgoFromJson(String str) => FetchAlgo.fromJson(json.decode(str));

String fetchAlgoToJson(FetchAlgo data) => json.encode(data.toJson());

class FetchAlgo {
  FetchAlgo({
    this.listItem,
    this.popupMsg,
    this.allowCreate,
  });

  List<ListItem> listItem;
  String popupMsg;
  bool allowCreate;

  factory FetchAlgo.fromJson(Map<String, dynamic> json) => FetchAlgo(
    listItem: json["ListItem"] == null ? [] : List<ListItem>.from(json["ListItem"].map((x) => ListItem.fromJson(x))),
    popupMsg: json["PopupMsg"],
    allowCreate: json["AllowCreate"],
  );

  Map<String, dynamic> toJson() => {
    "ListItem": listItem == null ? [] : List<dynamic>.from(listItem.map((x) => x.toJson())),
    "PopupMsg": popupMsg,
    "AllowCreate": allowCreate,
  };
}

class ListItem {
  ListItem({
    this.algoId,
    this.algoName,
    this.algoPhrase,
    this.algoType,
    this.algoSegment,
    this.algoParam,
  });

  int algoId;
  String algoName;
  String  algoPhrase;
  String  algoType;
  String algoSegment;
  List<AlgoParam> algoParam;

  factory ListItem.fromJson(Map<String, dynamic> json) => ListItem(
    algoId: json["AlgoID"],
    algoName: json["AlgoName"],
    algoPhrase: json["AlgoPhrase"],
    algoType: json["AlgoType"],
    algoSegment: json["AlgoSegment"],
    algoParam: json["AlgoParam"] == null ? [] : List<AlgoParam>.from(json["AlgoParam"].map((x) => AlgoParam.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "AlgoID": algoId,
    "AlgoName": algoName,
    "AlgoPhrase": algoPhrase,
    "AlgoType": algoType,
    "AlgoSegment": algoSegment,
    "AlgoParam": algoParam == null ? [] : List<dynamic>.from(algoParam.map((x) => x.toJson())),
  };
}

class AlgoParam {
  AlgoParam({
    this.algoId,
    this.paramName,
    this.paramType,
    this.paramValueInt,
    this.paramValueFloat,
    this.paramValueString,
    this.requestKey,
    this.displayKey,
  });

  int algoId;
  String paramName;
  String paramType;
  int paramValueInt;
  double paramValueFloat;
  String paramValueString;
  String requestKey;
  String displayKey;

  factory AlgoParam.fromJson(Map<String, dynamic> json) => AlgoParam(
    algoId: json["AlgoID"],
    paramName: json["ParamName"],
    paramType: json["ParamType"],
    paramValueInt: json["ParamValueInt"],
    paramValueFloat: json["ParamValueFloat"],
    paramValueString: json["ParamValueString"],
    requestKey: json["requestKey"],
    displayKey: json["displayKey"],
  );

  Map<String, dynamic> toJson() => {
    "AlgoID": algoId,
    "ParamName": paramName,
    "ParamType": paramType,
    "ParamValueInt": paramValueInt,
    "ParamValueFloat": paramValueFloat,
    "ParamValueString": paramValueString,
    "requestKey": requestKey,
    "displayKey": displayKey,
  };
}
