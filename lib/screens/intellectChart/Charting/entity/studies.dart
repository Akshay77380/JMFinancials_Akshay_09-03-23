//Create a class having properties/attribtutes of all indicators including price and volume.

import 'dart:core';
import 'package:flutter/material.dart';
import '../chart_widget.dart';

class ChartStudies {
  List<StudyDef> defaultstudyList = [];
  List<StudyDef> studyList = [];
  // List<StudyModal> adjacentNodes = [];

  ChartStudies() {
    init();
  }
  List<StudyDef> init() {
    // defaultstudyList = _getStudies();
    defaultstudyList = List.castFrom(_getStudies());
    return defaultstudyList;
  }

  List<StudyDef> _getStudies() {
    Studies s = Studies();
    s.studyDefList.clear();
    s.init();

    return s.studyDefList;
  }

  StudyDef getStudyByIndex(int index) {
    for (int i = 0; i < this.studyList.length; i++) {
      if (this.studyList[i].studyType.index == index) return this.studyList[i];
    }
  }
}

class Studies {
  List<StudyDef> studyDefList = [];
  // List<StudyModal> adjacentNodes = [];

  Studies();

  void init() {
    if (studyDefList.length != 0) return;
    for (int i = (TStudyType.DSDummyFirst).index;
        i <= (TStudyType.DSDummyLast).index;
        i++) {
      studyDefList.add(null);
    }

    studyDefList[TStudyType.DSDummyFirst.index] = _createDummyDef();
    studyDefList[TStudyType.STPrice.index] = _createPriceOHLCDef();
    studyDefList[TStudyType.STVolume.index] = _createVolumeDef();
    studyDefList[TStudyType.STAvgS.index] = _createAvgSimpleDef();
    studyDefList[TStudyType.STAvgE.index] = _createAvgExpoDef();
    studyDefList[TStudyType.STBoll.index] = _createBollDef();
    studyDefList[TStudyType.STCCI.index] = _createCCIDef();
    studyDefList[TStudyType.STATR.index] = _createATRDef();
    studyDefList[TStudyType.STMacd.index] = _createMACDDef();
    studyDefList[TStudyType.STRsi.index] = _createRSIDef();
    studyDefList[TStudyType.STWlmR.index] = _createWilliamRDef();
    studyDefList[TStudyType.STSwing.index] = _createDummyDef();
    studyDefList[TStudyType.STVwap.index] = _createDummyDef();
    studyDefList[TStudyType.STPriceTyp.index] = _createPTypDef();
    studyDefList[TStudyType.STStochKDJ.index] =
        _createDummyDef(); //_createStochKDJDef();
    studyDefList[TStudyType.STDonC.index] = _createDonchainDef();
    studyDefList[TStudyType.STSuperTrend.index] = _createSuperTrend();
    studyDefList[TStudyType.STAdx.index] = _createAdx();
    studyDefList[TStudyType.DSDummyLast.index] = _createDummyDef();
  }

  StudyDef _createDummyDef() {
    StudyDef id = StudyDef(
      TStudyType.DSDummyFirst,
      MainState.NONE,
      SecondaryState.NONE,
      "", //sName
      "", //lName
      0, //category
      4, //inColCnt
      [], //inCols
      1, //outColCnt
      [], //outCols
      [""], //outColName
      false, //onPriceSG
      false, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSDummyFirst], //drawStyle
      1, //colorCnt
      [Colors.black], //colors
      0, //parameterCnt
      [], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      false, //allowed
      false, //visible
      -1, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createPriceOHLCDef() {
    StudyDef id = StudyDef(
      TStudyType.STPrice,
      MainState.PRICE,
      SecondaryState.NONE,
      "Price", //sName
      "Price OHLC", //lName
      0, //category
      4, //inColCnt
      [], //inCols
      3, //outColCnt
      [], //outCols
      ["O", "H", "L", "C"], //outColName
      true, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSCandle], //drawStyle
      3, //colorCnt
      [Color(0xff089981), Color(0xffff3333), Color(0xff171b26)], //colors
      0, //parameterCnt
      [], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible
      0, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createVolumeDef() {
    StudyDef id = StudyDef(
      TStudyType.STVolume,
      MainState.NONE,
      SecondaryState.VOL,
      "VOL", //sName
      "Volume", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [], //outCols
      ["Qty"], //outColName
      false, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSVolume], //drawStyle
      2, //colorCnt
      [Color(0xFF74a662), Color(0xffC7372F)], //colors
      0, //parameterCnt
      [], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      1, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createAvgSimpleDef() {
    String p1 = "Avg Type";
    String p2 = "Avg Period";
    StudyDef id = StudyDef(
      TStudyType.STAvgS,
      MainState.MA,
      SecondaryState.NONE,
      "SMA", //sName
      "Average Simple", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [0], //outCols
      ["SMA"], //outColName
      true, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      1, //colorCnt
      [Color(0xFF0080FF)], //colors
      1, //parameterCnt
      [
        TStudyParameterRecord(
          p2.length, //this.paramNameLength,
          p2, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          10, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        )
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      0, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createAvgExpoDef() {
    //String p1 = "Avg Type";
    String p2 = "Avg Period";
    StudyDef id = StudyDef(
      TStudyType.STAvgE,
      MainState.MA,
      SecondaryState.NONE,
      "EMA", //sName
      "Average Exponential", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [1], //outCols
      ["EMA"], //outColName
      true, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      1, //colorCnt
      [Color(0xFF0080FF)], //colors
      1, //parameterCnt
      [
        TStudyParameterRecord(
          p2.length, //this.paramNameLength,
          p2, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          10, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        )
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible//extraLevel2
      0, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createSwingStudyDef() {
    String p1 = "Rev %";

    StudyDef id = StudyDef(
      TStudyType.STSwing,
      MainState.SWING,
      SecondaryState.NONE,
      "Swing", //sName
      "Swing", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [1], //outCols
      ["Sw"], //outColName
      true, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      1, //colorCnt
      [Color(0xFFFF8000)], //colors
      1, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          3, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        )
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible//extraLevel2
      0, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createBollDef() {
    String p1 = "Avg Period";
    String p2 = "Std Dev";
    StudyDef id = StudyDef(
      TStudyType.STBoll,
      MainState.BOLL,
      SecondaryState.NONE,
      "Boll", //sName
      "Bollinger Bands", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      3, //outColCnt
      [0, 1, 2], //outCols
      ["BoU", "BoM", "BoL"], //outColName
      true, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine3], //drawStyle
      3, //colorCnt
      [Color(0xff009B00), Color(0xff8080C0), Color(0xffFF8000)], //colors
      2, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          14, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
        TStudyParameterRecord(
          p2.length, //this.paramNameLength,
          p2, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          2, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        )
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible//extraLevel2
      0, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createATRDef() {
    String p1 = "ATR Period";
    StudyDef id = StudyDef(
      TStudyType.STATR,
      MainState.NONE,
      SecondaryState.ATR,
      "ATR", //sName
      "Average True Range", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [0], //outCols
      ["AT"], //outColName
      false, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      -0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      1, //colorCnt
      [Color(0xff4caf50)], //colors
      1, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          5, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      2, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createMACDDef() {
    String p1 = "Short Period";
    String p2 = "Long Period";
    StudyDef id = StudyDef(
      TStudyType.STMacd,
      MainState.NONE,
      SecondaryState.MACD,
      "MACD", //sName
      "MACD", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [0], //outCols
      ["MACD" /*, "RsiAvg"*/], //outColName
      false, //onPriceSG
      true, //useInScale
      true, //zeroBase
      1, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      1, //colorCnt
      [Color(0xFF0080FF)], //colors
      2, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          12, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
        TStudyParameterRecord(
          p2.length, //this.paramNameLength,
          p2, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          26, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      0, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createCCIDef() {
    String p1 = "CCI Period";
    StudyDef id = StudyDef(
      TStudyType.STCCI,
      MainState.NONE,
      SecondaryState.CCI,
      "CCI", //sName
      "Commodity Channel Index", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [0], //outCols
      ["CC"], //outColName
      false, //onPriceSG
      true, //useInScale
      false, //zeroBase
      1, //overBSLines
      100.0, //overBLevel
      -100.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      1, //colorCnt
      [Color(0xffFF8000)], //colors
      1, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          20, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      2, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createRSIDef() {
    String p1 = "Rsi Period";
    // String p2 = "Avg Type";
    // String p3 = "Avg Period";
    StudyDef id = StudyDef(
      TStudyType.STRsi,
      MainState.NONE,
      SecondaryState.RSI,
      "RSI", //sName
      "Relative Strength Index", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [0], //outCols
      ["RSI" /*, "RsiAvg"*/], //outColName
      false, //onPriceSG
      true, //useInScale
      false, //zeroBase
      1, //overBSLines
      70.0, //overBLevel
      30.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      1, //colorCnt
      [Color(0xFFFF8000)], //colors
      1, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          14, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
        /*TStudyParameterRecord(
          p2.length, //this.paramNameLength,
          p2, //this.paramName,
          "C", //this.paramType,
          "E", //this.charParam,
          10, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
        TStudyParameterRecord(
          p3.length, //this.paramNameLength,
          p3, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          9, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        )*/
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      2, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createWilliamRDef() {
    String p1 = "%R Period";
    String p2 = "Avg Type";
    String p3 = "Avg Period";
    StudyDef id = StudyDef(
      TStudyType.STWlmR,
      MainState.NONE,
      SecondaryState.WR,
      "WlmR", //sName
      "Williams %R", //lName
      0, //category
      3, //inColCnt
      [], //inCols
      1, //outColCnt
      [0], //outCols
      ["WR", "Avg"], //outColName
      false, //onPriceSG
      true, //useInScale
      false, //zeroBase
      1, //overBSLines
      -20.0, //overBLevel
      -80.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine2], //drawStyle
      2, //colorCnt
      [
        // Color.fromARGB(255, 214, 03, 162),
        Color.fromRGBO(230, 15, 90, 1),
        Color(0xff7e57c2)
      ], //colors
      1, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          14, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
        /*TStudyParameterRecord(
          p2.length, //this.paramNameLength,
          p2, //this.paramName,
          "C", //this.paramType,
          "S", //this.charParam,
          0, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
        TStudyParameterRecord(
          p3.length, //this.paramNameLength,
          p3, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          10, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        )*/
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible//extraLevel2
      3, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createVWAPDef() {
    StudyDef id = StudyDef(
      TStudyType.STVwap,
      MainState.VWAP,
      SecondaryState.NONE,
      "VWAP", //sName
      "Volume-Weighted Average Price (VWAP)", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [0], //outCols
      ["VWAP"], //outColName
      true, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      1, //colorCnt
      [Color(0xFFFF8000)], //colors
      0, //parameterCnt
      [], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      0, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createPTypDef() {
    StudyDef id = StudyDef(
      TStudyType.STPriceTyp,
      MainState.PRICETYP,
      SecondaryState.NONE,
      "Typ", //sName
      "Price - Typical", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [0], //outCols
      ["Typ"], //outColName
      true, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      2, //colorCnt
      [Color(0xFF952EE8), Color(0xFF952EE8)], //colors
      0, //parameterCnt
      [], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      0, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createStochKDJDef() {
    StudyDef id = StudyDef(
      TStudyType.STStochKDJ,
      MainState.NONE,
      SecondaryState.KDJ,
      "Stoch", //sName
      "Stochastics", //lName
      0, //category
      3, //inColCnt
      [], //inCols
      3, //outColCnt
      [0, 1, 2], //outCols
      ["%K", "%D", "%J"], //outColName
      false, //onPriceSG
      false, //useInScale
      false, //zeroBase
      1, //overBSLines
      80, //overBLevel
      20, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine3], //drawStyle
      1, //colorCnt
      [Color(0xffFF8000), Color(0xff0080FF), Color(0xffEB0F5A)], //colors
      0, //parameterCnt
      [], //parameters
      true, //extraLevels
      100, //extraLevel1
      -100, //extraLevel2
      false, //allowed
      false, //visible
      -1, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createDonchainDef() {
    String p1 = "Look Back Bars";
    StudyDef id = StudyDef(
      TStudyType.STDonC,
      MainState.DONCHAIN,
      SecondaryState.NONE,
      "DChan", //sName
      "Donchian Channel", //lName
      0, //category
      3, //inColCnt
      [], //inCols
      3, //outColCnt
      [0, 1, 2], //outCols
      ["DC-Up", "DC-Lw", "DC-Md"], //outColName
      false, //onPriceSG
      false, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine3], //drawStyle
      3, //colorCnt
      [Color(0xff009B00), Color(0xff0080FF), Color(0xffEB0F5A)], //colors
      1, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          10, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible
      -1, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createSuperTrend() {
    String p1 = "Factor";
    String p2 = "Avg Period";
    StudyDef id = StudyDef(
      TStudyType.STSuperTrend,
      MainState.STREND,
      SecondaryState.NONE,
      "STrend", //sName
      "Super Trend", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      1, //outColCnt
      [0], //outCols
      ["STrend"], //outColName
      false, //onPriceSG
      true, //useInScale
      false, //zeroBase
      0, //overBSLines
      0.0, //overBLevel
      -0.0, //overSLevel
      1, //drawStyleCnt
      [TDrawStyle.DSLine1], //drawStyle
      2, //colorCnt
      [Color(0xff26A69A), Color(0xffef5350)], //colors
      2, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          3, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
        TStudyParameterRecord(
          p2.length, //this.paramNameLength,
          p2, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          10, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      2, //subGraphIndex
      "", //displayText
    );
    return id;
  }

  StudyDef _createAdx() {
    String p1 = "DI Period";
    String p2 = "Adx Period";
    StudyDef id = StudyDef(
      TStudyType.STAdx,
      MainState.NONE,
      SecondaryState.ADX,
      "ADX", //sName
      "Directional Moving Index", //lName
      0, //category
      1, //inColCnt
      [], //inCols
      3, //outColCnt
      [0, 1, 2], //outCols
      ["+DI", "-DI", "ADX"], //outColName
      false, //onPriceSG
      true, //useInScale
      false, //zeroBase
      1, //overBSLines
      70.0, //overBLevel
      30.0, //overSLevel
      1, //d
      [TDrawStyle.DSLine1], //drawStyle
      3, //colorCnt
      [Color(0xff4caf50), Color(0xff0080FF), Color(0xffCC0000)], //colors
      2, //parameterCnt
      [
        TStudyParameterRecord(
          p1.length, //this.paramNameLength,
          p1, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          14, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
        TStudyParameterRecord(
          p2.length, //this.paramNameLength,
          p2, //this.paramName,
          "I", //this.paramType,
          "", //this.charParam,
          14, //this.intParam,
          0.0, //this.singleParam,
          false, //this.boolParam,
          0, //this.dateParam
          true,
        ),
      ], //parameters
      false, //extraLevels
      0.0, //extraLevel1
      0.0, //extraLevel2
      true, //allowed
      true, //visible //extraLevel2
      2, //subGraphIndex
      "", //displayText
    );
    return id;
  }
}

class StudyDef {
  TStudyType studyType;
  MainState mainState;
  SecondaryState secondaryState;
  String sName;
  String lName;
  int category;
  int inColCnt;
  List<int> inCols;
  int outColCnt;
  List<int> outCols;
  List<String> outColName;
  bool onPriceSG;
  bool useInScale;
  bool zeroBase;
  int overBSLines;
  double overBLevel;
  double overSLevel;
  int drawStyleCnt;
  List<TDrawStyle> drawStyle;
  int colorCnt;
  List<Color> colors;
  int parameterCnt;
  List<TStudyParameterRecord> parameters;
  bool extraLevels;
  double extraLevel1;
  double extraLevel2;
  bool allowed;
  bool visible;
  int subGraphIndex;
  String displayText;

  StudyDef(
      this.studyType,
      this.mainState,
      this.secondaryState,
      this.sName,
      this.lName,
      this.category,
      this.inColCnt,
      this.inCols,
      this.outColCnt,
      this.outCols,
      this.outColName,
      this.onPriceSG,
      this.useInScale,
      this.zeroBase,
      this.overBSLines,
      this.overBLevel,
      this.overSLevel,
      this.drawStyleCnt,
      this.drawStyle,
      this.colorCnt,
      this.colors,
      this.parameterCnt,
      this.parameters,
      this.extraLevels,
      this.extraLevel1,
      this.extraLevel2,
      this.allowed,
      this.visible,
      this.subGraphIndex,
      this.displayText) {
    List<TStudyParameterRecord> p2 = [...this.parameters];
    this.parameters = [];
    for (int i = 0; i < p2.length; i++) {
      this.parameters.add(new TStudyParameterRecord(
          p2[i].paramNameLength,
          p2[i].paramName,
          p2[i].paramType,
          p2[i].charParam,
          p2[i].intParam,
          p2[i].singleParam,
          p2[i].boolParam,
          p2[i].dateParam,
          p2[i].display));
    }
    List<int> inCols2 = [...this.inCols];
    this.inCols = [];
    for (int i = 0; i < inCols2.length; i++) {
      this.inCols.add(inCols2[i]);
    }
    List<int> outCols2 = [...this.outCols];
    this.outCols = [];
    for (int i = 0; i < outCols2.length; i++) {
      this.outCols.add(outCols2[i]);
    }
    List<String> outColName2 = [...this.outColName];
    this.outColName = [];
    for (int i = 0; i < outColName2.length; i++) {
      this.outColName.add(outColName2[i]);
    }
    List<TDrawStyle> drawStyle2 = [...this.drawStyle];
    this.drawStyle = [];
    for (int i = 0; i < drawStyle2.length; i++) {
      this.drawStyle.add(drawStyle2[i]);
    }
    List<Color> colors2 = [...this.colors];
    this.colors = [];
    for (int i = 0; i < colors2.length; i++) {
      this.colors.add(colors2[i]);
    }

    switch (this.mainState) {
      case MainState.PRICE:
        {}
        break;
      case MainState.MA:
      case MainState.SWING:
      case MainState.DONCHAIN:
        {
          for (int i = 0; i < this.parameterCnt; i++) {
            if (this.parameters[i].paramType != "I") continue;
            this.displayText =
                "${this.outColName[0]}(${this.parameters[i].intParam}) ";
            break;
          }
        }
        break;
      case MainState.BOLL:
        {
          String ot = "(";
          for (int i = 0; i < this.parameterCnt; i++) {
            if (this.parameters[i].paramType != "I") continue;
            ot += "${this.parameters[i].intParam},";
            // this.displayText =
            //     "${this.outColName[0]}(${this.parameters[i].intParam})";
          }
          ot = ot.substring(0, ot.length - 1);
          ot += ")";
          this.displayText = "BB$ot ";
        }
        break;
      case MainState.STREND:
        {
          String ot = "(";
          for (int i = 0; i < this.parameterCnt; i++) {
            if (this.parameters[i].paramType != "I") continue;
            ot += "${this.parameters[i].intParam},";
            // this.displayText =
            //     "${this.outColName[0]}(${this.parameters[i].intParam})";
          }
          ot = ot.substring(0, ot.length - 1);
          ot += ")";
          this.displayText = "${this.outColName[0]}$ot ";
        }
        break;
      case MainState.NONE:
        {}
        break;
      case MainState.VWAP:
        {}
        break;
      case MainState.PRICETYP:
        {
          this.displayText = "${this.outColName[0]} ";
        }
        break;
    }
    switch (this.secondaryState) {
      case SecondaryState.MACD:
        {
          String ot = "(";
          for (int i = 0; i < this.parameterCnt; i++) {
            if (this.parameters[i].paramType != "I") continue;
            ot += "${this.parameters[i].intParam},";
            // this.displayText =
            //     "${this.outColName[0]}(${this.parameters[i].intParam})";
          }
          ot = ot.substring(0, ot.length - 1);
          ot += ")";
          this.displayText = "Macd$ot ";
        }
        break;
      case SecondaryState.VOL:
      case SecondaryState.ATR:
      case SecondaryState.KDJ:
      case SecondaryState.RSI:
      case SecondaryState.WR:
      case SecondaryState.CCI:
        if (this.parameterCnt != 0) {
          for (int i = 0; i < this.parameterCnt; i++) {
            if (this.parameters[i].paramType != "I") continue;
            this.displayText =
                "${this.outColName[0]}(${this.parameters[i].intParam}) ";
            break;
          }
        } else {
          this.displayText = this.sName;
        }
        break;
      case SecondaryState.NONE:
        break;
      case SecondaryState.ADX:
        {
          String ot = "(";
          for (int i = 0; i < this.parameterCnt; i++) {
            if (this.parameters[i].paramType != "I") continue;
            ot += "${this.parameters[i].intParam},";
            // this.displayText =
            //     "${this.outColName[0]}(${this.parameters[i].intParam})";
          }
          ot = ot.substring(0, ot.length - 1);
          ot += ")";
          this.displayText = "ADX $ot ";
        }
        break;
    }
  }
  StudyDef.clone(StudyDef studyDef)
      : this(
            studyDef.studyType,
            studyDef.mainState,
            studyDef.secondaryState,
            studyDef.sName,
            studyDef.lName,
            studyDef.category,
            studyDef.inColCnt,
            studyDef.inCols,
            studyDef.outColCnt,
            studyDef.outCols,
            studyDef.outColName,
            studyDef.onPriceSG,
            studyDef.useInScale,
            studyDef.zeroBase,
            studyDef.overBSLines,
            studyDef.overBLevel,
            studyDef.overSLevel,
            studyDef.drawStyleCnt,
            studyDef.drawStyle,
            studyDef.colorCnt,
            studyDef.colors,
            studyDef.parameterCnt,
            studyDef.parameters,
            studyDef.extraLevels,
            studyDef.extraLevel1,
            studyDef.extraLevel2,
            studyDef.allowed,
            studyDef.visible,
            studyDef.subGraphIndex,
            studyDef.displayText);
}

enum TStudyType {
  DSDummyFirst,
  STPrice,
  STVolume,
  STAvgS,
  STAvgE,
  STBoll,
  STDonC,
  STVwap,
  STPriceTyp,
  STMacd,
  STCCI,
  STATR,
  STRsi,
  STStochKDJ,
  STWlmR,
  STSwing,
  STSuperTrend,
  STAdx,
  DSDummyLast
}

enum TDrawStyle {
  DSDummyFirst,
  DSPriceBar,
  DSCandle,
  DSVolume,
  DSLine1,
  DSLine2,
  DSLine3,
  DSDummyLast
}

class TStudyParameterRecord {
  int paramNameLength;
  String paramName;
  String paramType;
  String charParam;
  int intParam;
  double singleParam;
  bool boolParam;
  int dateParam;
  bool display;
  TStudyParameterRecord(
      this.paramNameLength,
      this.paramName,
      this.paramType,
      this.charParam,
      this.intParam,
      this.singleParam,
      this.boolParam,
      this.dateParam,
      this.display);
}

class TStudyParameterRecord2 {
  String paramName;
  String charParam;
  int intParam;
  TStudyParameterRecord2(
    String pparamName,
    String pcharParam,
    int pintParam,
  ) {
    this.paramName = pparamName;
    this.charParam = pcharParam;
    this.intParam = pintParam;
  }
}
