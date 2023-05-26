import '../../model/scrip_info_model.dart';
import '../../util/CommonFunctions.dart';

class EquityControllerClass {
  int scCode;
  String scName;
  String date;
  double open;
  double high;
  double low;
  double close;
  int qty;
  double value;
  double trades;
  double pOpen;
  double pHigh;
  double pLow;
  double pClose;
  String desc;
  double pcntChg;
  double pcntChgAbs;
  String exchange;
  bool isAddedScrip;
  int lastticktime;
  ScripInfoModel model;

  EquityControllerClass(
      {this.scCode,
      this.scName,
      this.date,
      this.open,
      this.high,
      this.low,
      this.close,
      this.qty,
      this.value,
      this.trades,
      this.pOpen,
      this.pHigh,
      this.pLow,
      this.pClose,
      this.desc,
      this.pcntChg,
      this.pcntChgAbs,
      this.exchange = "N",
      this.isAddedScrip = false,
      this.model,
      this.lastticktime});

  factory EquityControllerClass.fromJson(Map<String, dynamic> json) {
    return new EquityControllerClass(
        scCode: json['ScCode'],
        scName: json['ScName'],
        date: json['Date'],
        open: json['Open'],
        high: json['High'],
        low: json['Low'],
        close: json['Close'],
        qty: json['Qty'],
        value: json['Value'],
        trades: json['Trades'],
        pOpen: json['POpen'],
        pHigh: json['PHigh'],
        pLow: json['PLow'],
        pClose: json['PClose'],
        desc: json['SDescription'],
        pcntChg: json['PcntChg'],
        model: CommonFunction.getScripDataModel(
            getChartDataTime: 1,
            sendReq: true,
            exch: "N",
            exchCode: json['ScCode'],
            getNseBseMap: true),
        pcntChgAbs: json['PcntChgAbs']);
  }

  Map<String, dynamic> toMap() {
    return {
      'ScCode': scCode,
      'ScName': scName,
      'Date': date,
      'OpenPrice': open,
      'HighPrice': high,
      'LowPrice': low,
      'ClosePrice': close,
      'Qty': qty,
      'Value': value,
      'Trades': trades,
      'PrevOPen': pOpen,
      'PrevHigh': pHigh,
      'PrevLow': pLow,
      'PrevClose': pClose,
      'SDescription': desc,
      'PcntChg': pcntChg,
      'PcntChgAbs': pcntChgAbs,
      'model': model
    };
  }
}

class GroupMemberClass {
  final int scCode;
  final String groupName;

  GroupMemberClass({
    this.scCode,
    this.groupName,
  });

  factory GroupMemberClass.fromJson(Map<String, dynamic> json) {
    return new GroupMemberClass(
      scCode: json['ScCode'],
      groupName: json['GroupName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ScCode': scCode,
      'ScName': groupName,
    };
  }
}
