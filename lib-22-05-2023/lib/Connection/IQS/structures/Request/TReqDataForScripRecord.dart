import 'package:markets/Connection/IQS/structures/Request/THeaderRecord.dart';
import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/ByteStruct.dart';
import 'package:markets/Connection/structHelper/CharStruct.dart';
import 'package:markets/Connection/structHelper/IntStruct.dart';
import 'package:markets/Connection/structHelper/ObjectStruct.dart';

class TReqDataForScripRecord extends ObjectStruct {
  THeaderRecord header;
  CharStruct exch;
  CharStruct exchType;
  IntStruct code;
  ByteStruct addToList;

  TReqDataForScripRecord() {
    init();
  }

  void init() {
    this.header = new THeaderRecord();
    this.exch = new CharStruct(' '.codeUnitAt(0));
    this.exchType = new CharStruct(' '.codeUnitAt(0));
    this.code = new IntStruct(0);
    this.addToList = new ByteStruct(0);
    this.fields = new List<BaseStruct>.from(
        [this.header, this.exch, this.exchType, this.code, this.addToList]);
  }
}
