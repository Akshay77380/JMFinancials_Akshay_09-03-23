class EquityAndDerivativeIndicatorClass {
  final int scCode;
  final String fiftyTwoWeekHigh;
  final String fiftyTwoWeekLow;
  final String allTheTimeHigh;
  final String allTheTimeLow;
  final double vWap;
  final double rsi;
  final double rsiAvg;
  final double sma5;
  final double sma20;
  final double sma50;
  final double sma100;
  final double sma200;
  final double dlyVolOnLastbar;
  final double dlyVolOnNthBackbar1;
  final double dlyVolOnNthBackbar2;
  final double superTrend1;
  final double superTrend2;
  final double superTrend3;
  final double closePriceValue;
  final double priceCloseOnNthBackBar1Value;
  final double priceCloseOnNthBackBar2Value;
  final double priceCloseOnNthBackBar3Value;
  final double priceCloseOnNthBackBar4Value;
  final double priceCloseOnNthBackBar5Value;
  final double priceCloseOnNthBackBar6Value;
  final double priceCloseOnNthBackBar7Value;
  final double priceCloseOnNthBackBar8Value;
  final double priceCloseOnNthBackBar9Value;
  final String closePriceDate;
  final String priceCloseOnNthBackBar2Date;
  final String priceCloseOnNthBackBar3Date;
  final String priceCloseOnNthBackBar4Date;
  final String priceCloseOnNthBackBar5Date;
  final String priceCloseOnNthBackBar6Date;
  final String priceCloseOnNthBackBar7Date;
  final String priceCloseOnNthBackBar8Date;
  final String priceCloseOnNthBackBar9Date;
  final double wKlClosePriceValue;
  final double wKlPriceCloseOnNthBackBar1Value;
  final double wKlPriceCloseOnNthBackBar2Value;
  final double wKlPriceCloseOnNthBackBar3Value;
  final double wKlPriceCloseOnNthBackBar4Value;
  final double wKlPriceCloseOnNthBackBar5Value;
  final double wKlPriceCloseOnNthBackBar6Value;
  final double wKlPriceCloseOnNthBackBar7Value;
  final double wKlPriceCloseOnNthBackBar8Value;
  final double wKlPriceCloseOnNthBackBar9Value;
  final double yRClosePriceValue;
  final double yRPriceCloseOnNthBackBar1Value;
  final double yRPriceCloseOnNthBackBar2Value;
  final double yRPriceCloseOnNthBackBar3Value;
  final double yRPriceCloseOnNthBackBar4Value;
  final double yRPriceCloseOnNthBackBar5Value;
  final double yRPriceCloseOnNthBackBar6Value;
  final double yRPriceCloseOnNthBackBar7Value;
  final double yRPriceCloseOnNthBackBar8Value;
  final double yRPriceCloseOnNthBackBar9Value;
  final double yRPriceCloseOnNthBackBar10Value;
  final double yRPriceCloseOnNthBackBar11Value;
  final double yRPriceCloseOnNthBackBar12Value;

  final double fiveYrClosePriceValue;
  final double fiveYrPriceCloseOnNthBackBar1Value;
  final double fiveYrPriceCloseOnNthBackBar2Value;
  final double fiveYrPriceCloseOnNthBackBar3Value;
  final double fiveYrPriceCloseOnNthBackBar4Value;
  final double fiveYrPriceCloseOnNthBackBar5Value;
  final double fiveYrPriceCloseOnNthBackBar6Value;
  final double fiveYrPriceCloseOnNthBackBar7Value;
  final double fiveYrPriceCloseOnNthBackBar8Value;
  final double fiveYrPriceCloseOnNthBackBar9Value;

  final double prev1Day;
  final double prev1Month;
  final double prev6Month;
  final double prev1Year;
  final double prev2Year;
  final double prev3Year;
  final double prev4Year;
  final double prev5Year;
  final double wklyPriceLowOnNthBackbar;
  final double wklyPriceHighOnNthBackbar;

  final double wklyPriceLowOnNthBackbar1;
  final double wklyPriceHighOnNthBackbar1;

  final double dlyPriceLowOnNthBackbar1;
  final double dlyPriceLowOnNthBackbar2;
  final double dlyPriceLowOnNthBackbar3;
  final double dlyPriceLowOnNthBackbar4;
  final double dlyPriceLowOnNthBackbar5;

  final double dlyPriceHighOnNthBakcBar1;
  final double dlyPriceHighOnNthBakcBar2;
  final double dlyPriceHighOnNthBakcBar3;
  final double dlyPriceHighOnNthBackbar4;
  final double dlyPriceHighOnNthBackbar5;

  final double monPriceHighOnLastbar;
  final double monPriceHighOnNthBackbar1;

  final double monPriceLowOnLastbar;
  final double monPriceLowOnNthBackbar1;

  final double yrlPriceLowLowestinNBars6;
  final double yrlPriceHighHighestinNBars6;

  final String dlyPriceOpenOnNthBackbar9999Date;
  final double dlyPriceOpenOnNthBackbar9999;
  final double prev3Month;

  final DateTime priceCloseOnNthBackBar1Date;
  final DateTime wKlPriceCloseOnNthBackBar1Date;
  final DateTime prev1MonthDate;
  final DateTime prev3MonthDate;
  final DateTime prev6MonthDate;
  final DateTime prev1YearDate;
  final DateTime prev2YearDate;
  final DateTime prev3YearDate;
  final DateTime prev4YearDate;
  final DateTime prev5YearDate;

  EquityAndDerivativeIndicatorClass({
    this.scCode,
    this.fiftyTwoWeekHigh,
    this.fiftyTwoWeekLow,
    this.allTheTimeHigh,
    this.allTheTimeLow,
    this.closePriceDate,
    this.closePriceValue,
    this.rsi,
    this.rsiAvg,
    this.sma5,
    this.dlyVolOnLastbar,
    this.dlyVolOnNthBackbar1,
    this.sma20,
    this.sma50,
    this.sma100,
    this.sma200,
    this.vWap,
    this.superTrend1,
    this.superTrend2,
    this.superTrend3,
    this.priceCloseOnNthBackBar1Value,
    this.priceCloseOnNthBackBar2Value,
    this.priceCloseOnNthBackBar3Value,
    this.priceCloseOnNthBackBar4Value,
    this.priceCloseOnNthBackBar5Value,
    this.priceCloseOnNthBackBar6Value,
    this.priceCloseOnNthBackBar7Value,
    this.priceCloseOnNthBackBar8Value,
    this.priceCloseOnNthBackBar9Value,
    this.priceCloseOnNthBackBar1Date,
    this.priceCloseOnNthBackBar2Date,
    this.priceCloseOnNthBackBar4Date,
    this.priceCloseOnNthBackBar3Date,
    this.priceCloseOnNthBackBar5Date,
    this.priceCloseOnNthBackBar6Date,
    this.priceCloseOnNthBackBar7Date,
    this.priceCloseOnNthBackBar8Date,
    this.priceCloseOnNthBackBar9Date,
    this.wKlClosePriceValue,
    this.wKlPriceCloseOnNthBackBar1Value,
    this.wKlPriceCloseOnNthBackBar2Value,
    this.wKlPriceCloseOnNthBackBar3Value,
    this.wKlPriceCloseOnNthBackBar4Value,
    this.wKlPriceCloseOnNthBackBar5Value,
    this.wKlPriceCloseOnNthBackBar6Value,
    this.wKlPriceCloseOnNthBackBar7Value,
    this.wKlPriceCloseOnNthBackBar8Value,
    this.wKlPriceCloseOnNthBackBar9Value,
    this.yRClosePriceValue,
    this.yRPriceCloseOnNthBackBar1Value,
    this.yRPriceCloseOnNthBackBar2Value,
    this.yRPriceCloseOnNthBackBar3Value,
    this.yRPriceCloseOnNthBackBar4Value,
    this.yRPriceCloseOnNthBackBar5Value,
    this.yRPriceCloseOnNthBackBar6Value,
    this.yRPriceCloseOnNthBackBar7Value,
    this.yRPriceCloseOnNthBackBar8Value,
    this.yRPriceCloseOnNthBackBar9Value,
    this.yRPriceCloseOnNthBackBar10Value,
    this.yRPriceCloseOnNthBackBar11Value,
    this.yRPriceCloseOnNthBackBar12Value,
    this.fiveYrClosePriceValue,
    this.fiveYrPriceCloseOnNthBackBar1Value,
    this.fiveYrPriceCloseOnNthBackBar2Value,
    this.fiveYrPriceCloseOnNthBackBar3Value,
    this.fiveYrPriceCloseOnNthBackBar4Value,
    this.fiveYrPriceCloseOnNthBackBar5Value,
    this.fiveYrPriceCloseOnNthBackBar6Value,
    this.fiveYrPriceCloseOnNthBackBar7Value,
    this.fiveYrPriceCloseOnNthBackBar8Value,
    this.fiveYrPriceCloseOnNthBackBar9Value,
    this.prev1Day,
    this.prev6Month,
    this.prev1Month,
    this.prev1Year,
    this.prev2Year,
    this.prev3Year,
    this.prev4Year,
    this.prev5Year,
    this.dlyPriceLowOnNthBackbar1,
    this.wklyPriceLowOnNthBackbar,
    this.dlyPriceHighOnNthBakcBar2,
    this.dlyPriceHighOnNthBakcBar1,
    this.dlyPriceHighOnNthBakcBar3,
    this.dlyPriceHighOnNthBackbar5,
    this.dlyPriceLowOnNthBackbar4,
    this.dlyPriceLowOnNthBackbar5,
    this.dlyPriceHighOnNthBackbar4,
    this.dlyPriceLowOnNthBackbar2,
    this.dlyPriceLowOnNthBackbar3,
    this.wklyPriceHighOnNthBackbar,
    this.dlyVolOnNthBackbar2,
    this.wklyPriceLowOnNthBackbar1,
    this.wklyPriceHighOnNthBackbar1,
    this.monPriceHighOnLastbar,
    this.monPriceHighOnNthBackbar1,
    this.monPriceLowOnLastbar,
    this.monPriceLowOnNthBackbar1,
    this.yrlPriceHighHighestinNBars6,
    this.yrlPriceLowLowestinNBars6,
    this.dlyPriceOpenOnNthBackbar9999Date,
    this.dlyPriceOpenOnNthBackbar9999,
    this.prev3Month,
    this.wKlPriceCloseOnNthBackBar1Date,
    this.prev1MonthDate,
    this.prev3MonthDate,
    this.prev6MonthDate,
    this.prev1YearDate,
    this.prev2YearDate,
    this.prev3YearDate,
    this.prev4YearDate,
    this.prev5YearDate,
  });
}
