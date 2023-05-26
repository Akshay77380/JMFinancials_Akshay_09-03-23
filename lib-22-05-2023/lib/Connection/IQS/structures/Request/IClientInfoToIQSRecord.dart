import 'dart:typed_data';

import 'package:markets/Connection/IQS/structures/Request/THeaderRecord.dart';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/ByteArrStruct.dart';
import 'package:markets/Connection/structHelper/ByteStruct.dart';
import 'package:markets/Connection/structHelper/CharArrStruct.dart';
import 'package:markets/Connection/structHelper/ObjectStruct.dart';

class IClientInfoToIQSRecord extends ObjectStruct {
  THeaderRecord header;
  ByteStruct feUserIDLength;
  CharArrStruct feUserID;
  ByteStruct feUserNameLength;
  CharArrStruct feUserName;
  ByteStruct requiredNseEquity;
  ByteStruct requiredNseDeriv;
  ByteStruct requiredBseEquity;
  ByteStruct versionLength;
  CharArrStruct version;
  ByteStruct getAllBO;
  ByteStruct allScripsNseCash;
  ByteStruct allScripsNseDeriv;
  ByteStruct allScripsBseCash;
  ByteStruct allowTotalBuySellQty;
  ByteStruct requiredNseCurrency;
  ByteStruct requiredNseSLBM;
  ByteStruct requiredMcx;
  ByteStruct requiredBseFo;
  ByteStruct requiredBseCurr;
  ByteArrStruct junk;

  IClientInfoToIQSRecord() {
    init();
  }

  void init() {
    this.header = new THeaderRecord();
    this.feUserIDLength = new ByteStruct(0);
    this.feUserID = new CharArrStruct(Uint8List(15));
    this.feUserNameLength = new ByteStruct(0);
    this.feUserName = new CharArrStruct(Uint8List(30));
    this.versionLength = new ByteStruct(0);
    this.version = new CharArrStruct(Uint8List(10));
    this.getAllBO = new ByteStruct(0);
    this.requiredNseEquity = new ByteStruct(0);
    this.requiredNseDeriv = new ByteStruct(0);
    this.requiredNseCurrency = new ByteStruct(0);
    this.requiredNseSLBM = new ByteStruct(0);
    this.requiredMcx = new ByteStruct(0);
    this.requiredBseFo = new ByteStruct(0);
    this.requiredBseCurr = new ByteStruct(0);
    this.requiredBseEquity = new ByteStruct(0);
    this.allowTotalBuySellQty = new ByteStruct(0);
    this.allScripsBseCash = new ByteStruct(0);
    this.allScripsNseCash = new ByteStruct(0);
    this.allScripsNseDeriv = new ByteStruct(0);
    this.junk = new ByteArrStruct(40);
    this.fields = new List<BaseStruct>.from([
      this.header,
      this.feUserIDLength,
      this.feUserID,
      this.feUserNameLength,
      this.feUserName,
      this.requiredNseEquity,
      this.requiredNseDeriv,
      this.requiredBseEquity,
      this.versionLength,
      this.version,
      this.getAllBO,
      this.allScripsNseCash,
      this.allScripsNseDeriv,
      this.allScripsBseCash,
      this.allowTotalBuySellQty,
      this.requiredNseCurrency,
      this.requiredNseSLBM,
      this.requiredMcx,
      this.requiredBseFo,
      this.requiredBseCurr,
      this.junk
    ]);
  }
}
