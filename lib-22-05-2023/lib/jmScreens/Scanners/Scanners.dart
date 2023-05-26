import 'dart:math';

import '../../util/CommonFunctions.dart';
import 'EquityAndDerivativeIndicatorData.dart';
import 'EquityControllerClass.dart';


class Scanners {
  bool retVal = false;

  bool redBody(EquityControllerClass data) {
    if (data.close < data.open) {
      return true;
    } else {
      return false;
    }
  }

  bool gapDown(EquityControllerClass data) {
    if (data.high < data.pLow) {
      return true;
    } else {
      return false;
    }
  }

  bool closeBelowPrevDayLow(EquityControllerClass data) {
    if (data.close < data.pLow) {
      return true;
    } else {
      return false;
    }
  }

  bool closeBelowPrevWeekLow(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.close < equityData.wklyPriceLowOnNthBackbar1) {
      return true;
    } else {
      return false;
    }
  }

  bool closeBelowPrevMonthLow(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.close < equityData.monPriceLowOnNthBackbar1) {
      return true;
    } else {
      return false;
    }
  }

  bool closeBelow5DayLow(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    double minVal = min(equityData.dlyPriceLowOnNthBackbar1,
        equityData.dlyPriceLowOnNthBackbar2);
    minVal = min(minVal, equityData.dlyPriceLowOnNthBackbar3);
    minVal = min(minVal, equityData.dlyPriceLowOnNthBackbar4);
    minVal = min(minVal, data.pLow);
    if (data.close < minVal)
      return true;
    else
      return false;

    /*if (data.close < equityData.dlyPriceLowOnNthBackbar1 &&
        data.close < equityData.dlyPriceLowOnNthBackbar2 &&
        data.close < equityData.dlyPriceLowOnNthBackbar3 &&
        data.close < equityData.dlyPriceLowOnNthBackbar4 &&
        data.close < data.pLow) {
      return true;
    } else {
      return false;
    }*/
  }

  bool priceTrendRisingLast2Days(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.close > data.pClose &&
        data.pClose > equityData.priceCloseOnNthBackBar1Value) {
      return true;
    } else {
      return false;
    }
  }

  bool priceTrendFallingLast2Days(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.close < data.pClose &&
        data.pClose < equityData.priceCloseOnNthBackBar1Value) {
      return true;
    } else {
      return false;
    }
  }

  bool doubleBottom2DaysReversal(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.low == data.pLow) {
      return true;
    } else {
      return false;
    }
  }

  bool priceDownwardReversal(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.close < data.pLow &&
            data.high < data.pHigh &&
            data.pHigh > equityData.dlyPriceHighOnNthBakcBar1 &&
            equityData.dlyPriceHighOnNthBakcBar1 >
                equityData.dlyPriceHighOnNthBakcBar2

        /*equityData.dlyPriceHighOnNthBakcBar1 >
            equityData.dlyPriceHighOnNthBakcBar2 &&
        equityData.dlyPriceHighOnNthBakcBar2 >
            equityData.dlyPriceHighOnNthBakcBar3*/
        ) {
      return true;
    } else {
      return false;
    }
  }

  bool greenBody(EquityControllerClass data) {
    if (data.close > data.open) {
      return true;
    } else {
      return false;
    }
  }

  bool gapUp(EquityControllerClass data) {
    if (data.low > data.pHigh) {
      return true;
    } else {
      return false;
    }
  }

  bool closeAbovePrevDayHigh(EquityControllerClass data) {
    if (data.close > data.pHigh) {
      return true;
    } else {
      return false;
    }
  }

  bool closeAbovePrevWeekHigh(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.close > equityData.wklyPriceHighOnNthBackbar1) {
      return true;
    } else {
      return false;
    }
  }

  bool closeAbovePrevMonthhigh(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.close > equityData.monPriceHighOnNthBackbar1) {
      return true;
    } else {
      return false;
    }
  }

  bool closeAbove5DayHigh(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    double maxVal = max(equityData.dlyPriceHighOnNthBakcBar1,
        equityData.dlyPriceHighOnNthBakcBar2);
    maxVal = max(maxVal, equityData.dlyPriceHighOnNthBakcBar3);
    maxVal = max(maxVal, equityData.dlyPriceHighOnNthBackbar4);
    maxVal = max(maxVal, data.pHigh);
    if (data.close > maxVal)
      return true;
    else
      return false;

    // if (data.close > equityData.dlyPriceHighOnNthBakcBar1 &&
    //     data.close > equityData.dlyPriceHighOnNthBakcBar2 &&
    //     data.close > equityData.dlyPriceHighOnNthBakcBar3 &&
    //     data.close > equityData.dlyPriceHighOnNthBackbar4 &&
    //     data.close > data.pHigh) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  bool doubleTop2DaysReversal(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.high == data.pHigh) {
      return true;
    } else {
      return false;
    }
  }

  bool priceUpwardReversal(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if (data.close > data.pHigh &&
            data.low > data.pLow &&
            data.pLow < equityData.dlyPriceLowOnNthBackbar1 &&
            equityData.dlyPriceLowOnNthBackbar1 <
                equityData.dlyPriceLowOnNthBackbar2

        /*equityData.dlyPriceLowOnNthBackbar1 <
            equityData.dlyPriceLowOnNthBackbar2 &&
        equityData.dlyPriceLowOnNthBackbar2 <
            equityData.dlyPriceLowOnNthBackbar3*/
        ) {
      return true;
    } else {
      return false;
    }
  }

  bool volumeRaiseAbove50(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    double value = (((data.qty - equityData.dlyVolOnLastbar) /
            equityData.dlyVolOnLastbar) *
        100);
    if (value >= 50) {
      return true;
    } else {
      return false;
    }
  }

  bool volumeRaiseAbove100(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    double value = (((data.qty - equityData.dlyVolOnLastbar) /
            equityData.dlyVolOnLastbar) *
        100);
    if (value >= 100) {
      return true;
    } else {
      return false;
    }
  }

  bool volumeRaiseAbove200(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    double value = (((data.qty - equityData.dlyVolOnLastbar) /
            equityData.dlyVolOnLastbar) *
        100);
    if (value >= 200) {
      return true;
    } else {
      return false;
    }
  }

  bool priceAboveR4(EquityControllerClass data) {
    if (((data.pClose + 7 * data.pHigh - 5 * data.pLow) / 3.0) < data.close) {
      return true;
    } else
      return false;
  }

  bool priceAboveR3(EquityControllerClass data) {
    if (data.close >
            ((2 * data.pClose + 5 * data.pHigh - 4 * data.pLow) / 3.0) &&
        data.close < ((data.pClose + 7 * data.pHigh - 5 * data.pLow) / 3.0)) {
      return true;
    } else
      return false;
  }

  bool priceAboveR2(EquityControllerClass data) {
    if (data.close > ((data.pClose + 4 * data.pHigh - 2 * data.pLow) / 3.0) &&
        data.close <
            ((2 * data.pClose + 5 * data.pHigh - 4 * data.pLow) / 3.0)) {
      return true;
    } else
      return false;
  }

  bool priceAboveR1(EquityControllerClass data) {
    if (data.close > ((2 * data.pClose + 2 * data.pHigh - data.pLow) / 3.0) &&
        data.close < ((data.pClose + 4 * data.pHigh - 2 * data.pLow))) {
      return true;
    } else
      return false;
  }

  bool priceAbovePivot(EquityControllerClass data) {
    if (data.close > ((data.pHigh + data.pLow + data.pClose) / 3) &&
        data.close < ((2 * data.pClose + 2 * data.pHigh - data.pLow) / 3.0)) {
      return true;
    } else
      return false;
  }

  bool priceBelowPivot(EquityControllerClass data) {
    if (data.close < ((data.pHigh + data.pLow + data.pClose) / 3.0) &&
        data.close > ((2 * data.pClose + 2 * data.pLow - data.pHigh) / 3.0)) {
      return true;
    } else
      return false;
  }

  bool priceBelowS1(EquityControllerClass data) {
    if (data.close < ((2 * data.pClose + 2 * data.pLow - data.pHigh) / 3.0) &&
        data.close > ((data.pClose + 4 * data.pLow - 2 * data.pHigh) / 3.0)) {
      return true;
    } else
      return false;
  }

  bool priceBelowS2(EquityControllerClass data) {
    if (data.close < ((data.pClose + 4 * data.pLow - 2 * data.pHigh) / 3.0) &&
        data.close >
            ((2 * data.pClose + 5 * data.pLow - 4 * data.pHigh) / 3.0)) {
      return true;
    } else
      return false;
  }

  bool priceBelowS3(EquityControllerClass data) {
    if (data.scCode == 9463) {
      //print('object');
    }
    if (data.close <
            ((2 * data.pClose + 5 * data.pLow - 4 * data.pHigh) / 3.0) &&
        data.close > ((data.pClose + 7 * data.pLow - 5 * data.pHigh) / 3.0)) {
      return true;
    } else
      return false;
  }

  bool priceBelowS4(EquityControllerClass data) {
    if (data.close < (data.pClose + 7 * data.pLow - 5 * data.pHigh) / 3.0) {
      return true;
    } else
      return false;
  }

  bool rSIOversold30(EquityAndDerivativeIndicatorClass equityData) {
    if (equityData.rsi < 30) {
      return true;
    } else
      return false;
  }

  bool rSIBetween30TO50(EquityAndDerivativeIndicatorClass equityData) {
    if (equityData.rsi >= 30 && equityData.rsi <= 50) {
      return true;
    } else
      return false;
  }

  bool rSIBetween50TO70(EquityAndDerivativeIndicatorClass equityData) {
    if (equityData.rsi > 50 && equityData.rsi <= 70) {
      return true;
    } else
      return false;
  }

  bool rSIOverBought70(EquityAndDerivativeIndicatorClass equityData) {
    if (equityData.rsi > 70) {
      return true;
    } else
      return false;
  }

  bool rSIAboveRSIAvg30(EquityAndDerivativeIndicatorClass equityData) {
    if (equityData.rsi > equityData.rsiAvg) {
      return true;
    } else
      return false;
  }

  bool rSIBelowRSIAvg30(EquityAndDerivativeIndicatorClass equityData) {
    if (equityData.rsi < equityData.rsiAvg) {
      return true;
    } else
      return false;
  }

  bool priceGrowth3YearBetween25TO50(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if ((((data.close - equityData.fiveYrPriceCloseOnNthBackBar5Value) /
                    equityData.fiveYrPriceCloseOnNthBackBar5Value) *
                100) >=
            25 &&
        (((data.close - equityData.fiveYrPriceCloseOnNthBackBar5Value) /
                    equityData.fiveYrPriceCloseOnNthBackBar5Value) *
                100) <
            50) {
      return true;
    } else
      return false;
  }

  bool priceGrowth3YearBetween50TO100(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if ((((data.close - equityData.fiveYrPriceCloseOnNthBackBar5Value) /
                    equityData.fiveYrPriceCloseOnNthBackBar5Value) *
                100) >=
            50 &&
        (((data.close - equityData.fiveYrPriceCloseOnNthBackBar5Value) /
                    equityData.fiveYrPriceCloseOnNthBackBar5Value) *
                100) <=
            100) {
      return true;
    } else
      return false;
  }

  bool priceGrowth3YearAbove100(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if ((((data.close - equityData.fiveYrPriceCloseOnNthBackBar5Value) /
                equityData.fiveYrPriceCloseOnNthBackBar5Value) *
            100) >
        100) {
      return true;
    } else
      return false;
  }

  bool priceGrowth1YearAbove25(EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData) {
    if ((((data.close - equityData.yRPriceCloseOnNthBackBar12Value) /
                equityData.yRPriceCloseOnNthBackBar12Value) *
            100) >
        25) {
      return true;
    } else
      return false;
  }

  bool priceAboveSuperTrend1(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.superTrend1) {
      return true;
    } else
      return false;
  }

  bool priceAboveSuperTrend2(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.superTrend2) {
      return true;
    } else
      return false;
  }

  bool priceAboveSuperTrend3(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.superTrend3) {
      return true;
    } else
      return false;
  }

  bool priceBelowSuperTrend1(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close < equityData.superTrend1) {
      return true;
    } else
      return false;
  }

  bool priceBelowSuperTrend2(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close < equityData.superTrend2) {
      return true;
    } else
      return false;
  }

  bool priceBelowSuperTrend3(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close < equityData.superTrend3) {
      return true;
    } else
      return false;
  }

  bool priceBetweenSuperTrend1and2(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.superTrend1 &&
        data.close < equityData.superTrend2) {
      return true;
    } else
      return false;
  }

  bool priceBetweenSuperTrend2and3(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.superTrend2 &&
        data.close < equityData.superTrend3) {
      return true;
    } else
      return false;
  }

  bool priceAboveSMA5(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.sma5)
      return true;
    else
      return false;
  }

  bool priceAboveSMA20(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.sma20)
      return true;
    else
      return false;
  }

  bool priceAboveSMA50(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.sma50)
      return true;
    else
      return false;
  }

  bool priceAboveSMA100(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.sma100)
      return true;
    else
      return false;
  }

  bool priceAboveSMA200(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close > equityData.sma200)
      return true;
    else
      return false;
  }

  bool priceBelowSMA5(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close < equityData.sma5)
      return true;
    else
      return false;
  }

  bool priceBelowSMA20(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close < equityData.sma20)
      return true;
    else
      return false;
  }

  bool priceBelowSMA50(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close < equityData.sma50)
      return true;
    else
      return false;
  }

  bool priceBelowSMA100(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close < equityData.sma100)
      return true;
    else
      return false;
  }

  bool priceBelowSMA200(EquityAndDerivativeIndicatorClass equityData,
      EquityControllerClass data) {
    if (data.close < equityData.sma200)
      return true;
    else
      return false;
  }

  bool openEqualToLow(EquityControllerClass data) {
    if (data.open == data.low)
      return true;
    else
      return false;
  }

  bool openEqualToHigh(EquityControllerClass data) {
    if (data.open == data.high)
      return true;
    else
      return false;
  }

//End of Conditions

  bool scannerResult(
      EquityControllerClass data,
      EquityAndDerivativeIndicatorClass equityData,
      ScannerConditions selectedValue) {
    // if (data.scCode == 212) {
    //   //print('a');
    // }
    switch (selectedValue) {
      case ScannerConditions.RedBody:
        retVal = redBody(data);
        break;
      case ScannerConditions.GapDown:
        retVal = gapDown(data);
        break;
      case ScannerConditions.CLoseBelowPrevDayLow:
        retVal = closeBelowPrevDayLow(data);
        break;
      case ScannerConditions.CLoseBelowPrevWeekLow:
        retVal = closeBelowPrevWeekLow(data, equityData);
        break;
      case ScannerConditions.CLoseBelowPrevMonthLow:
        retVal = closeBelowPrevMonthLow(data, equityData);
        break;
      case ScannerConditions.CloseBelow5DayLow:
        retVal = closeBelow5DayLow(data, equityData);
        break;
      case ScannerConditions.PriceTrendRisingLast2Days:
        retVal = priceTrendRisingLast2Days(data, equityData);
        break;
      case ScannerConditions.PriceTrendFallingLast2Days:
        retVal = priceTrendFallingLast2Days(data, equityData);
        break;
      case ScannerConditions.DoubleBottom2DaysReversal:
        retVal = doubleBottom2DaysReversal(data, equityData);
        break;
      case ScannerConditions.PriceDownwardReversal:
        retVal = priceDownwardReversal(data, equityData);
        break;
      case ScannerConditions.GreenBody:
        retVal = greenBody(data);
        break;
      case ScannerConditions.GapUp:
        retVal = gapUp(data);
        break;
      case ScannerConditions.CloseAbovePrevDayHigh:
        retVal = closeAbovePrevDayHigh(data);
        break;
      case ScannerConditions.CloseAbovePrevWeekHigh:
        retVal = closeAbovePrevWeekHigh(data, equityData);
        break;
      case ScannerConditions.CloseAbovePrevMonthHigh:
        retVal = closeAbovePrevMonthhigh(data, equityData);
        break;
      case ScannerConditions.CloseAbove5DayHigh:
        retVal = closeAbove5DayHigh(data, equityData);
        break;
      case ScannerConditions.Doubletop2DaysReversal:
        retVal = doubleTop2DaysReversal(data, equityData);
        break;
      case ScannerConditions.PriceUpwardReversal:
        retVal = priceUpwardReversal(data, equityData);
        break;
      case ScannerConditions.VolumeRaiseAbove50:
        retVal = volumeRaiseAbove50(data, equityData);
        break;
      case ScannerConditions.VolumeRaiseAbove100:
        retVal = volumeRaiseAbove100(data, equityData);
        break;
      case ScannerConditions.VolumeRaiseAbove200:
        retVal = volumeRaiseAbove200(data, equityData);
        break;
      case ScannerConditions.PriceAboveR4:
        retVal = priceAboveR4(data);
        break;
      case ScannerConditions.PriceAboveR3:
        retVal = priceAboveR3(data);
        break;
      case ScannerConditions.PriceAboveR2:
        retVal = priceAboveR2(data);
        break;
      case ScannerConditions.PriceAboveR1:
        retVal = priceAboveR1(data);
        break;
      case ScannerConditions.PriceAbovePivot:
        retVal = priceAbovePivot(data);
        break;
      case ScannerConditions.PriceBelowPivot:
        retVal = priceBelowPivot(data);
        break;
      case ScannerConditions.PriceBelowS1:
        retVal = priceBelowS1(data);
        break;
      case ScannerConditions.PriceBelowS2:
        retVal = priceBelowS2(data);
        break;
      case ScannerConditions.PriceBelowS3:
        retVal = priceBelowS3(data);
        break;
      case ScannerConditions.PriceBelowS4:
        retVal = priceBelowS4(data);
        break;
      case ScannerConditions.RSIOverSold30:
        retVal = rSIOversold30(equityData);
        break;
      case ScannerConditions.RSIBetween30To50:
        retVal = rSIBetween30TO50(equityData);
        break;
      case ScannerConditions.RSIBetween50TO70:
        retVal = rSIBetween50TO70(equityData);
        break;
      case ScannerConditions.RSIOverBought70:
        retVal = rSIOverBought70(equityData);
        break;
      case ScannerConditions.RSIAboveRSIAvg30:
        retVal = rSIAboveRSIAvg30(equityData);
        break;
      case ScannerConditions.RSIBelowRSIAvg30:
        retVal = rSIBelowRSIAvg30(equityData);
        break;
      case ScannerConditions.PriceGrowth1YearAbove25:
        retVal = priceGrowth1YearAbove25(data, equityData);
        break;
      case ScannerConditions.PriceGrowth3YearBetween25To50:
        retVal = priceGrowth3YearBetween25TO50(data, equityData);
        break;
      case ScannerConditions.PriceGrowth3YearBetween50To100:
        retVal = priceGrowth3YearBetween50TO100(data, equityData);
        break;
      case ScannerConditions.PriceGrowth3YearAbove100:
        retVal = priceGrowth3YearAbove100(data, equityData);
        break;
      case ScannerConditions.PriceAboveSuperTrend1:
        retVal = priceAboveSuperTrend1(equityData, data);
        break;
      case ScannerConditions.PriceAboveSuperTrend2:
        retVal = priceAboveSuperTrend2(equityData, data);
        break;
      case ScannerConditions.PriceAboveSuperTrend3:
        retVal = priceAboveSuperTrend3(equityData, data);
        break;
      case ScannerConditions.PriceBelowSuperTrend1:
        retVal = priceBelowSuperTrend1(equityData, data);
        break;
      case ScannerConditions.PriceBelowSuperTrend2:
        retVal = priceBelowSuperTrend2(equityData, data);
        break;
      case ScannerConditions.PriceBelowSuperTrend3:
        retVal = priceBelowSuperTrend3(equityData, data);
        break;
      case ScannerConditions.PriceBetweenSuperTrend1and2:
        retVal = priceBetweenSuperTrend1and2(equityData, data);
        break;
      case ScannerConditions.PriceBetweenSuperTrend2and3:
        retVal = priceBetweenSuperTrend2and3(equityData, data);
        break;
      case ScannerConditions.PriceAboveSMA5:
        retVal = priceAboveSMA5(equityData, data);
        break;
      case ScannerConditions.PriceAboveSMA20:
        retVal = priceAboveSMA20(equityData, data);
        break;
      case ScannerConditions.PriceAboveSMA50:
        retVal = priceAboveSMA50(equityData, data);
        break;
      case ScannerConditions.PriceAboveSMA100:
        retVal = priceAboveSMA100(equityData, data);
        break;
      case ScannerConditions.PriceAboveSMA200:
        retVal = priceAboveSMA200(equityData, data);
        break;
      case ScannerConditions.PriceBelowSMA5:
        retVal = priceBelowSMA5(equityData, data);
        break;
      case ScannerConditions.PriceBelowSMA20:
        retVal = priceBelowSMA20(equityData, data);
        break;
      case ScannerConditions.PriceBelowSMA50:
        retVal = priceBelowSMA50(equityData, data);
        break;
      case ScannerConditions.PriceBelowSMA100:
        retVal = priceBelowSMA100(equityData, data);
        break;
      case ScannerConditions.PriceBelowSMA200:
        retVal = priceBelowSMA200(equityData, data);
        break;
      case ScannerConditions.openEqualToLow:
        retVal = openEqualToLow(data);
        break;
      case ScannerConditions.openEqualToHigh:
        retVal = openEqualToHigh(data);
        break;
    }
    return retVal;
  }
}
