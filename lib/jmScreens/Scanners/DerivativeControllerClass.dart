class DerivativeController {
  String scName;
  int scCode;
  String expiry;
  int cp;
  double strike;
  int lotSize;
  String date;
  double open;
  double high;
  double low;
  double close;
  int qty;
  double value;
  int trdOI;
  double pOpen;
  double pHigh;
  double pLow;
  double pClose;
  int pTrdOI;
  String desc;
  double pcntChg;
  double pcntChgAbs;
  String exchange;
  bool isAddedScrip;
  int lastticktime;

  DerivativeController(
      {this.scName,
      this.scCode,
      this.expiry,
      this.cp,
      this.strike,
      this.lotSize,
      this.date,
      this.open,
      this.high,
      this.low,
      this.close,
      this.qty,
      this.value,
      this.trdOI,
      this.pOpen,
      this.pHigh,
      this.pLow,
      this.pClose,
      this.pTrdOI,
      this.desc,
      this.pcntChg,
      this.pcntChgAbs,
      this.exchange = "D",
      this.isAddedScrip = false,
      this.lastticktime});

  factory DerivativeController.fromJson(Map<String, dynamic> json) {
    return new DerivativeController(
        scName: json['ULName'],
        scCode: json['Code'],
        expiry: json['Expiry'],
        cp: json['CP'],
        strike: json['Strike'],
        lotSize: json['LotSize'],
        date: json['Date'],
        open: json['Open'],
        high: json['High'],
        low: json['Low'],
        close: json['Close'],
        qty: json['Qty'],
        value: json['Value'],
        trdOI: json['TradeOI'],
        pOpen: json['POpen'],
        pHigh: json['PHigh'],
        pLow: json['PLow'],
        pClose: json['PClose'],
        pTrdOI: int.parse(json['PTrdOI']),
        desc: json['Desc'],
        lastticktime: json['LastTickTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      'ULName': scName,
      'Code': scCode,
      'Expiry': expiry,
      'CP': cp,
      'Strike': strike,
      'LotSize': lotSize,
      'Date': date,
      'Open': open,
      'High': high,
      'Low': low,
      'Close': close,
      'Qty': qty,
      'Value': value,
      'TradeOI': trdOI,
      'POpen': pOpen,
      'PHigh': pHigh,
      'PLow': pLow,
      'PClose': pClose,
      'PTrdOI': pTrdOI,
      'Desc': desc,
      'PcntChg': pcntChg,
      'PcntChgAbs': pcntChgAbs,
      'LastTickTime': lastticktime
    };
  }
}

class Expiry {
  String expiry;
  Expiry({this.expiry});
  factory Expiry.fromJson(Map<String, dynamic> json) {
    return new Expiry(
      expiry: json['Expiry'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'Expiry': expiry,
    };
  }
}

class CompanyName {
  String ulName;
  CompanyName({this.ulName});
  factory CompanyName.fromJson(Map<String, dynamic> json) {
    return new CompanyName(
      ulName: json['ULName'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'ULName': ulName,
    };
  }
}
