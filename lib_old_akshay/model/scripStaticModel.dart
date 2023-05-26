import '../model/scrip_info_model.dart';
import '../util/CommonFunctions.dart';

class ScripStaticModel {
  String name = '';
  String isecName = '';
  String series = '';
  String desc = '';

  String exch = '';
  ExchCategory exchCategory;
  int exchCode = 0;

  int tickSize = 0;
  int tickSize2 = 0;

  int expiry = 0;
  int expiry2 = 0;
  double strikePrice = 0;
  double strikePrice2 = 0;
  int cpType = 0;
  int ulToken = 0;
  int ofisType = 0;
  int ofisType2 = 0;
  int minimumLotQty = 0;
  int minimumLotQty2 = 0;
  int caLevel = 0;
  int caLevel2 = 0;

  String units = '', unit1 = '', unit2 = '';
  int unitNo = 0;
  int startTime = 0;
  int endDate = 0;
  int delStart = 0;
  int delEnd = 0;
  int tenderStart = 0;
  int tenderEnd = 0;
  int maxQty = 0;
  double factor = 0;

  double buyMargin = 0;
  double sellMargin = 0;
  int mcxTickSize = 0;
  int groupID = 0;

  int spdCode1 = 0;
  int spdCode2 = 0;
  String tradingSymbol = "";
  bool isSpread;

  String get exchName {
    switch (exch) {
      case 'N':
      case 'C':
        return 'NSE';
      case 'B':
      case 'E':
        return 'BSE';
      case 'M':
        return 'MCX';
      default:
        return '';
    }
  }

  int getTickSize(String exch, String name) {
    if (exch.toUpperCase() == 'N') {
      switch (name) {
        case 'S&P500':
        case 'INDIAVIX':
          return 25;
        case 'FTSE100':
          return 100;
        case 'DJIA':
          return 250;
        default:
          return 5;
      }
    } else if (exch.toUpperCase() == 'C')
      return 25;
    else
      return 5;
  }

  ScripStaticModel.nseDeriv(Map<String, dynamic> data, bool isSpread) {
    // //print("nseDeriv -------- $data");
    if(isSpread) {
      this.name = data["Name"];
      this.isecName = data['ISecName'];
      this.desc = data["Desc"];
      this.tradingSymbol = data["TradingSymbol"];
      this.exchCode = data["ScripCode"];
      this.exch = data["Exch"];
      this.series = 'F&O';
      this.ulToken = data["ULToken"];
      this.caLevel = data['CALevel1'];
      this.caLevel2 = data['CALevel2'];
      this.ofisType = data["OFISType1"];
      this.ofisType2 = data["OFISType2"];
      this.cpType = data["CPType"];
      this.expiry = data["ExpiryDate1"];
      this.expiry2 = data["ExpiryDate2"];
      this.strikePrice = data["StrikePrice1"].toDouble();
      this.strikePrice2 = data["StrikePrice2"].toDouble();
      this.minimumLotQty = data["MinimumLotQuantity1"];
      this.minimumLotQty2 = data["MinimumLotQuantity2"];
      this.tickSize = data["Ticksize1"];
      this.tickSize2 = data["Ticksize2"];
      this.spdCode1 = data["Spd_Code1"];
      this.spdCode2 = data["Spd_Code2"];
      this.isSpread = true;
      this.exchCategory = ExchCategory.nseFuture;
    } else {
      this.name = data["Name"];
      this.isecName = data['ISecName'];
      this.desc = data["Desc"];
      this.tradingSymbol = data["TradingSymbol"];
      this.exchCode = data["ScripCode"];
      this.exch = data["Exch"];
      this.series = 'F&O';
      this.ulToken = data["ULToken"];
      this.caLevel = data['CALevel'];
      this.ofisType = data["OFISType"];
      this.cpType = data["CPType"];
      this.expiry = data["ExpiryDate"];
      this.strikePrice = data["StrikePrice"].toDouble();
      this.minimumLotQty = data["MinimumLotQuantity"];
      this.tickSize = getTickSize(exch, name);
      this.exchCategory = CommonFunction.getExchCategory(
        this.exch,
        this.exchCode,
        this.cpType,
      );
    }
  }

  ScripStaticModel.nseCurrData(Map<String, dynamic> data) {
    // //print("nseCurrData ------------ $data");
    this.isecName = data["ISecName"];
    this.name = data["Name"];
    this.desc = data["Desc"];
    this.tradingSymbol = data["TradingSymbol"];
    this.exchCode = data["ScripCode"];
    this.exch = data["Exch"];
    this.series = 'Curr';
    this.isecName = data['ISecName'];
    this.ulToken = data["ULToken"];
    this.caLevel = data['CALevel'];
    this.ofisType = data["OFISType"];
    this.cpType = data["CPType"];
    this.expiry = data["ExpiryDate"];
    this.strikePrice = data["StrikePrice"].toDouble();
    this.minimumLotQty = data["MinimumLotQuantity"];
    this.tickSize = getTickSize(exch, name);
    this.exchCategory = CommonFunction.getExchCategory(
      this.exch,
      this.exchCode,
      this.cpType,
    );
  }

  ScripStaticModel.bseCurrData(Map<String, dynamic> data) {
    this.isecName = data["ISecName"];
    this.exch = data["Exch"];
    this.exchCode = data["ScripCode"];
    this.name = data["Name"];
    this.ulToken = data["ULToken"];
    this.desc = data["Desc"];
    this.tradingSymbol = data["TradingSymbol"];
    this.series = 'Curr';
    this.caLevel = data['CALevel'];
    this.ofisType = data["OFISType"];
    this.cpType = data["CPType"];
    this.expiry = data["ExpiryDate"];
    this.strikePrice = data["StrikePrice"].toDouble();
    this.minimumLotQty = data["MinimumLotQuantity"];
    this.tickSize = getTickSize(exch, name);
    this.exchCategory = CommonFunction.getExchCategory(
      this.exch,
      this.exchCode,
      this.cpType,
    );
  }

  ScripStaticModel.mcxData(Map<String, dynamic> data) {
    // if(data['ISecName'].toString().contains("CRUDE"))
    // //print("mcx data => $data");
    this.name = data["Name"];
    this.isecName = data['ISecName'];
    this.desc = data["Desc"];
    this.tradingSymbol = data["TradingSymbol"];
    this.exchCode = data["ScripCode"];
    this.exch = data["Exch"];
    this.series = 'F&O';
    this.ulToken = data["ULToken"];
    this.caLevel = data['CALevel'];
    this.ofisType = data["OFISType"];
    this.cpType = data["CPType"];
    this.expiry = data["ExpiryDate"];
    this.strikePrice = data["StrikePrice"].toDouble();
    this.minimumLotQty = data["MinimumLotQuantity"];
    this.units = data['Units'];
    this.unit1 = data['Units1'];
    this.unit2 = data['Units2'];
    this.unitNo = data['UnitNo'];
    this.startTime = data['Start'];
    this.endDate = data['EndDate'];
    this.delStart = data['DelStart'];
    this.delEnd = data['DelEnd'];
    this.tenderStart = data['TenderStart'];
    this.tenderEnd = data['TenderEnd'];
    this.maxQty = data['MaxSingleQty'];
    this.factor = data['Factor'].toDouble();
    this.buyMargin = data['BuyMargin'].toDouble();
    this.sellMargin = data['SellMargin'].toDouble();
    this.tickSize = getTickSize(exch, name);
    this.mcxTickSize = data['McxTickSize'];
    this.groupID = data['GroupID'];
    this.exchCategory = CommonFunction.getExchCategory(
      this.exch,
      this.exchCode,
      this.cpType,
    );
  }

  ScripStaticModel.bseEquityData(Map<String, dynamic> data) {
    // //print("bse equity data => $data");
    this.exch = data["Exch"];
    this.exchCode = data["ScripCode"];
    this.name = data["Name"];
    this.isecName = data['ISecName'];
    this.desc = data["Desc"];
    this.tradingSymbol = data["TradingSymbol"];
    this.tickSize = data['TickSize'];
    this.series = data['Series'];
    this.minimumLotQty = data["MinimumLotQty"];
    this.exchCategory = CommonFunction.getExchCategory(
      this.exch,
      this.exchCode,
    );
  }

  ScripStaticModel.nseEquityData(Map<String, dynamic> data) {
    // //print("nse equity data => $data");
    this.exch = data["Exch"];
    this.exchCode = data["ScripCode"];
    this.name = data["Name"];
    this.desc = data["Desc"];
    this.tradingSymbol = data["TradingSymbol"];
    this.tickSize = data['TickSize'];
    this.series = data['Series'];
    this.minimumLotQty = data["MinimumLotQty"];
    this.isecName = data['ISecName'];
    this.exchCategory = CommonFunction.getExchCategory(
      this.exch,
      this.exchCode,
    );
  }
}
