import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/ByteStruct.dart';
import 'package:markets/Connection/structHelper/IntStruct.dart';
import 'package:markets/Connection/structHelper/ObjectStruct.dart';

class RecHeader extends ObjectStruct {
  ByteStruct exch;
  IntStruct exchCode;
  IntStruct recTime;
  ByteStruct recType;

  RecHeader() {
    init();
  }

  void init() {
    this.exch = new ByteStruct(0);
    this.exchCode = new IntStruct(0);
    this.recTime = new IntStruct(0);
    this.recType = new ByteStruct(0);
    this.fields = new List<BaseStruct>.from(
        [this.exch, this.exchCode, this.recTime, this.recType]);
  }
}
