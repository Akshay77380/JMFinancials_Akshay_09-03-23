import '../entity/k_entity.dart';

class KLineEntity extends KEntity {
  double open;
  double high;
  double low;
  double close;
  double vol;
  int trade;
  double value;
  double amount;
  double change;
  double ratio;
  int time;

  KLineEntity.fromCustom(
      {this.amount,
      this.open,
      this.close,
      this.change,
      this.ratio,
      this.time,
      this.high,
      this.low,
      this.vol,
      this.trade,
      this.value});

  KLineEntity.fromJson(Map<String, dynamic> json) {
    open = json['open']?.toDouble() ?? 0;
    high = json['high']?.toDouble() ?? 0;
    low = json['low']?.toDouble() ?? 0;
    close = json['close']?.toDouble() ?? 0;
    vol = json['vol']?.toDouble() ?? 0;
    amount = json['amount']?.toDouble() ?? 0;
    int tempTime = json['time']?.toInt();
    //Compatible with Huobi Data
    if (tempTime == null) {
      tempTime = json['id']?.toInt() ?? 0;
      tempTime = tempTime * 1000;
    } else {
      tempTime = json['time']?.toInt() ?? 0;
      tempTime = tempTime * 1000;
    }
    time = tempTime;
    datetime = tempTime;
    ratio = json['ratio']?.toDouble() ?? 0;
    change = json['change']?.toDouble() ?? 0;
    trade = json['tr']?.toDouble() ?? 0;
    value = json['u']?.toDouble() ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['open'] = this.open;
    data['close'] = this.close;
    data['high'] = this.high;
    data['low'] = this.low;
    data['vol'] = this.vol;
    data['amount'] = this.amount;
    data['ratio'] = this.ratio;
    data['change'] = this.change;
    return data;
  }

  @override
  String toString() {
    return 'MarketModel{open: $open, high: $high, low: $low, close: $close, vol: $vol, time: $time, amount: $amount, ratio: $ratio, change: $change}';
  }
}
