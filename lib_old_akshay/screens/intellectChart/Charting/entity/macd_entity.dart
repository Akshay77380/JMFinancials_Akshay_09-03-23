import 'cci_entity.dart';
import 'kdj_entity.dart';
import 'rsi_entity.dart';
import 'rw_entity.dart';
import 'atr_entity.dart';
import 'adx_entity.dart';

mixin MACDEntity on KDJEntity, RSIEntity, WREntity, CCIEntity, ATREntity, ADXEntity {
  List<double> dea;
  List<double> dif;
  List<double> macd;
}
