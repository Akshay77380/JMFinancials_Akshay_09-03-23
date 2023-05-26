// To parse this JSON data, do
//
//     final eventsDate = eventsDateFromJson(jsonString);

import 'dart:convert';

EventsDate eventsDateFromJson(String str) => EventsDate.fromJson(json.decode(str));

String eventsDateToJson(EventsDate data) => json.encode(data.toJson());

class EventsDate {
  EventsDate({
       this.success,
       this.data,
       this.status,
       this.message,
       this.responsecode,
  });

  bool success;
  List<Datum> data;
  String status;
  String message;
  String responsecode;

  factory EventsDate.fromJson(Map<String, dynamic> json) => EventsDate(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    status: json["status"],
    message: json["message"],
    responsecode: json["responsecode"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status": status,
    "message": message,
    "responsecode": responsecode,
  };
}

class Datum {
  Datum({
       this.coCode,
       this.scCode,
    this.symbol,
       this.coName,
       this.isin,
       this.currentPrice,
       this.pricediff,
       this.perChange,
       this.tradeDate,
       this.bookCloserDate,
       this.agenda,
       this.exchange,
       this.companyLongName,
  });

  double coCode;
  String scCode;
  String symbol;
  String coName;
  String isin;
  double currentPrice;
  double pricediff;
  double perChange;
  DateTime tradeDate;
  DateTime bookCloserDate;
  Agenda agenda;
  Exchange exchange;
  String companyLongName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    coCode: json["co_code"],
    scCode: json["sc_code"],
    symbol: json["symbol"],
    coName: json["co_name"],
    isin: json["isin"],
    currentPrice: json["CurrentPrice"]?.toDouble(),
    pricediff: json["Pricediff"]?.toDouble(),
    perChange: json["PerChange"]?.toDouble(),
    tradeDate: DateTime.parse(json["TradeDate"]),
    bookCloserDate: DateTime.parse(json["BookCloserDate"]),
    agenda: agendaValues.map[json["agenda"]],
    exchange: exchangeValues.map[json["Exchange"]],
    companyLongName: json["CompanyLongName"],
  );

  Map<String, dynamic> toJson() => {
    "co_code": coCode,
    "sc_code": scCode,
    "symbol": symbol,
    "co_name": coName,
    "isin": isin,
    "CurrentPrice": currentPrice,
    "Pricediff": pricediff,
    "PerChange": perChange,
    "TradeDate": tradeDate.toIso8601String(),
    "BookCloserDate": bookCloserDate.toIso8601String(),
    "agenda": agendaValues.reverse[agenda],
    "Exchange": exchangeValues.reverse[exchange],
    "CompanyLongName": companyLongName,
  };
}

enum Agenda { ANNUAL_GENERAL_MEETING }

final agendaValues = EnumValues({
  "Annual General Meeting": Agenda.ANNUAL_GENERAL_MEETING
});

enum Exchange { BSE }

final exchangeValues = EnumValues({
  "BSE": Exchange.BSE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
