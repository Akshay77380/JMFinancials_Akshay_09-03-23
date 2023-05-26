import 'dart:math';

import 'package:flutter/material.dart';

import '../chart_widget.dart';
import '../entity/studies.dart';
import '../utils/number_util.dart';

import '../entity/index.dart';

// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import,camel_case_types
class DataUtil {
  static calculate(
    List<KLineEntity> dataList,
    List<StudyDef> studyList,
    /*[List<int> maDayList = const [10, 50], int n = 20, k = 2]*/
  ) {
    List<int> maDayList = [10, 50];
    List<int> emaDayList = [10, 50];
    List<int> swingDayList = [10, 50];
    List<int> rsiDayList = [14];
    List<int> wrDayList = [14];
    List<int> cciDayList = [14];
    List<int> donDayList = [];
    List<int> maOutCols = [];
    List<int> emaOutCols = [];
    List<int> swingOutCols = [];
    List<int> STOutColsList = [];
    List<int> bollOutCols = [];
    List<int> macdOutCols = [];
    List<int> atrOutCols = [];
    List<int> typOutCols = [];
    List<int> kdjOutCols = [];
    List<int> donOutCols = [];
    var d = new Map<int, List<int>>();
    for (var i = TStudyType.DSDummyFirst.index + 1;
        i < TStudyType.DSDummyLast.index;
        i++) {
      d[i] = <int>[];
    }
    List<int> n = [];
    List<int> k = [];
    List<int> STn = [];
    List<int> STk = [];
    List<int> Adxn = [];
    List<int> Adxk = [];
    List<int> macd1 = [];
    List<int> macd2 = [];
    List<int> atrDayList = [5];
    maDayList.clear();
    emaDayList.clear();
    rsiDayList.clear();
    wrDayList.clear();
    cciDayList.clear();
    List<int> ADxOutCalls = [];
    for (int i = 2; i < studyList?.length; i++) {
      if (!studyList[i].visible) continue;
      if (!studyList[i].allowed) continue;
      switch (studyList[i].mainState) {
        case MainState.PRICE:
          {}
          break;
        case MainState.MA:
        case MainState.BOLL:
        case MainState.SWING:
        case MainState.STREND:
        case MainState.PRICETYP:
        case MainState.DONCHAIN:
          {
            switch (studyList[i].studyType) {
              case TStudyType.DSDummyFirst:
                {}
                break;
              case TStudyType.STPrice:
                {}
                break;
              case TStudyType.STVolume:
                {}
                break;
              case TStudyType.STAvgS:
                {
                  for (int j = 0; j < studyList[i].parameterCnt; j++) {
                    if (studyList[i].parameters[j].paramType == "I") {
                      maDayList.add(studyList[i].parameters[j].intParam);
                      emaDayList.add(studyList[i].parameters[j].intParam);
                      maOutCols.add(studyList[i].outCols[0]);
                    }
                  }
                }
                break;
              case TStudyType.STAvgE:
                {
                  for (int j = 0; j < studyList[i].parameterCnt; j++) {
                    if (studyList[i].parameters[j].paramType == "I") {
                      maDayList.add(studyList[i].parameters[j].intParam);
                      emaDayList.add(studyList[i].parameters[j].intParam);
                      emaOutCols.add(studyList[i].outCols[0]);
                      continue;
                    }
                  }
                }
                break;
              case TStudyType.STRsi:
              case TStudyType.STWlmR:
              case TStudyType.STAdx:
                {}
                break;
              case TStudyType.DSDummyLast:
                {}
                break;
              case TStudyType.STBoll:
                {
                  n.add(studyList[i].parameters[0].intParam);
                  k.add(studyList[i].parameters[1].intParam);
                  bollOutCols.addAll(studyList[i].outCols);
                }
                break;
              case TStudyType.STDonC:
                {
                  donDayList.add(studyList[i].parameters[0].intParam);
                  donOutCols.addAll(studyList[i].outCols);
                }
                break;
              case TStudyType.STSwing:
                {
                  d[studyList[i].studyType.index].addAll(studyList[i].outCols);
                  swingDayList.add(studyList[i].parameters[0].intParam);
                  swingOutCols.addAll(studyList[i].outCols);
                }
                break;
              case TStudyType.STSuperTrend:
                {
                  d[studyList[i].studyType.index].addAll(studyList[i].outCols);
                  STn.add(studyList[i].parameters[0].intParam);
                  STk.add(studyList[i].parameters[1].intParam);
                  STOutColsList.addAll(studyList[i].outCols);
                }
                break;
              case TStudyType.STATR:
              case TStudyType.STRsi:
              case TStudyType.STWlmR:
              case TStudyType.DSDummyLast:
              case TStudyType.STMacd:
              case TStudyType.STCCI:
                {}
                break;
              case TStudyType.STVwap:
                {}
                break;
              case TStudyType.STPriceTyp:
                {
                  d[studyList[i].studyType.index].addAll(studyList[i].outCols);
                  typOutCols.addAll(studyList[i].outCols);
                }
                break;
              case TStudyType.STStochKDJ:
                d[studyList[i].studyType.index].addAll(studyList[i].outCols);
                kdjOutCols.addAll(studyList[i].outCols);
                break;
            }
          }
          break;
        case MainState.NONE:
          {}
          break;
        default:
          break;
      }
      switch (studyList[i].secondaryState) {
        case SecondaryState.VOL:
          {}
          break;
        case SecondaryState.MACD:
          {
            macd1.add(studyList[i].parameters[0].intParam);
            macd2.add(studyList[i].parameters[1].intParam);
            macdOutCols.addAll(studyList[i].outCols);
          }
          break;
        case SecondaryState.KDJ:
          {
            d[studyList[i].studyType.index].addAll(studyList[i].outCols);
            kdjOutCols.addAll(studyList[i].outCols);
          }
          break;
          break;
        case SecondaryState.RSI:
          {
            d[studyList[i].studyType.index].addAll(studyList[i].outCols);
            for (int j = 0; j < studyList[i].parameterCnt; j++) {
              if (studyList[i].parameters[j].paramType == "I") {
                rsiDayList.add(studyList[i].parameters[j].intParam);
                continue;
              }
            }
          }
          break;
        case SecondaryState.WR:
          {
            d[studyList[i].studyType.index].addAll(studyList[i].outCols);
            for (int j = 0; j < studyList[i].parameterCnt; j++) {
              if (studyList[i].parameters[j].paramType == "I") {
                wrDayList.add(studyList[i].parameters[j].intParam);
                continue;
              }
            }
          }
          break;
        case SecondaryState.CCI:
          {
            d[studyList[i].studyType.index].addAll(studyList[i].outCols);
            for (int j = 0; j < studyList[i].parameterCnt; j++) {
              if (studyList[i].parameters[j].paramType == "I") {
                cciDayList.add(studyList[i].parameters[j].intParam);
                continue;
              }
            }
          }
          break;
        case SecondaryState.ATR:
          {
            d[studyList[i].studyType.index].addAll(studyList[i].outCols);
            atrOutCols.addAll(studyList[i].outCols);
            for (int j = 0; j < studyList[i].parameterCnt; j++) {
              if (studyList[i].parameters[j].paramType == "I") {
                atrDayList.add(studyList[i].parameters[j].intParam);
                continue;
              }
            }
          }
          break;
        case SecondaryState.ADX:
          {
            d[studyList[i].studyType.index].addAll(studyList[i].outCols);
            Adxn.add(studyList[i].parameters[0].intParam);
            Adxk.add(studyList[i].parameters[1].intParam);
            ADxOutCalls.addAll(studyList[i].outCols);
          }
          break;
        case SecondaryState.NONE:
          {}
          break;
        default:
          break;
      }
      if (studyList[i].mainState == MainState.MA) {}
    }
    // maDayList.addAll(emaDayList);
    //calcMA(dataList, maDayList, maOutCols);
    int i;
    int t;

    t = maDayList.length;
    SMA(dataList, maDayList, maOutCols, t);
    EMA(dataList, emaDayList, emaOutCols, t);

    int bollLength = bollOutCols.length ~/ 3;
    /*if (bollLength == 0) {
      for (int i = 0; i < dataList.length; i++) {
        KLineEntity entity = dataList[i];
        entity.up = null;
        entity.mb = null;
        entity.dn = null;
      }
    } else*/
    {
      for (i = 0; i < bollLength; i++) {
        calcBOLL(dataList, n[i], k[i], i, bollLength);
      }
    }
    i = 0;
    calcVolumeMA(dataList);
    //calcKDJ(dataList);

    int macdLength = macdOutCols.length;
    /*if (macdLength == 0) {
      for (int i = 0; i < dataList.length; i++) {
        KLineEntity entity = dataList[i];
        entity.dif = null;
        entity.dea = null;
        entity.macd = null;
      }
    } else */
    {
      for (i = 0; i < macdLength; i++) {
        calcMACD(dataList, macd1[i], macd2[i], i, macdLength);
      }
    }

    int donLength = donOutCols.length ~/ 3;
    {
      for (i = 0; i < donLength; i++) {
        calcDonChain(dataList, donDayList[i], i, donLength);
      }
    }

    t = TStudyType.STSwing.index;
    for (int i = 0; i < d[t]?.length; i++) {
      calcSwing(dataList, swingDayList[i], swingOutCols[i], d[t]?.length);
    }

    t = TStudyType.STRsi.index;
    for (int i = 0; i < d[t]?.length; i++) {
      calcRSI(dataList, rsiDayList[i], d[t]?.length, d[t][i]);
    }
    t = TStudyType.STWlmR.index;
    for (int i = 0; i < d[t]?.length; i++) {
      calcWR(dataList, wrDayList[i], d[t]?.length, d[t][i]);
    }

    t = TStudyType.STCCI.index;
    for (int i = 0; i < d[t]?.length; i++) {
      calcCCI(dataList, cciDayList[i], d[t]?.length, d[t][i]);
    }

    t = TStudyType.STATR.index;
    for (int i = 0; i < d[t]?.length; i++) {
      calcATR(dataList, atrDayList[i], d[t]?.length, d[t][i]);
    }

    t = TStudyType.STPriceTyp.index;
    for (int i = 0; i < d[t]?.length; i++) {
      calcPriceTyp(dataList, typOutCols[i], d[t]?.length);
    }
    t = TStudyType.STStochKDJ.index;
    for (int i = 0; i < d[t]?.length; i++) {
      calcStoch(dataList);
    }

    t = TStudyType.STSuperTrend.index;
    int STrendlength = STOutColsList.length;
    for (int i = 0; i < STrendlength; i++) {
      calcSuperTrend(dataList, STn[i], STk[i], STOutColsList[i], d[t]?.length);
    }

    t = TStudyType.STAdx.index;
    int STAdxlength = (ADxOutCalls.length) ~/ 3;
    for (int i = 0; i < STAdxlength; i++) {
      calcAdx(
          dataList: dataList,
          Adx_Period: Adxn[i],
          di_period: Adxk[i],
          oC: i == 0 ? ADxOutCalls[i] : ADxOutCalls[i + 3],
          t: STAdxlength);
    }
  }

  static calcMA(
      List<KLineEntity> dataList, List<int> maDayList, List<int> maOutCols) {
    List<double> ma = List<double>.filled(maDayList.length, 0);

    if (dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        KLineEntity entity = dataList[i];
        final closePrice = entity.close;
        entity.maValueList = List<double>.filled(maDayList.length, 0);
        for (int j = 0; j < maDayList.length; j++) {
          ma[j] += closePrice;
          if (i == maDayList[j] - 1) {
            entity.maValueList[j] = ma[j] / maDayList[j];
          } else if (i >= maDayList[j]) {
            ma[j] -= dataList[i - maDayList[j]].close;
            entity.maValueList[j] = ma[j] / maDayList[j];
          } else {
            entity.maValueList[j] = 0;
          }
        }
      }
    }
  }

  static SMA(List<KLineEntity> dataList, List<int> maDayList,
      List<int> maOutCols, int t,
      {bool isTemp = false}) {
    if (!isTemp) {
      List<double> ma = List<double>.filled(maDayList.length, 0);
      if (dataList.isNotEmpty) {
        for (int i = 0; i < dataList.length; i++) {
          KLineEntity entity = dataList[i];
          final closePrice = entity.close;
          if (entity.maValueList == null || entity.maValueList.length != t)
            entity.maValueList = List<double>.filled(t, 0);
          for (int j = 0; j < maOutCols.length; j++) {
            ma[j] += closePrice;
            if (i == maDayList[maOutCols[j]] - 1) {
              entity.maValueList[maOutCols[j]] =
                  ma[j] / maDayList[maOutCols[j]];
            } else if (i >= maDayList[maOutCols[j]]) {
              ma[j] -= dataList[i - maDayList[maOutCols[j]]].close;
              entity.maValueList[maOutCols[j]] =
                  ma[j] / maDayList[maOutCols[j]];
            } else {
              entity.maValueList[maOutCols[j]] = 0;
            }
          }
        }
      }
    }
    if (isTemp) {
      List<double> ma = List<double>.filled(maDayList.length, 0);

      if (dataList.isNotEmpty) {
        for (int i = 1; i < dataList.length; i++) {
          KLineEntity entity = dataList[0];
          final closePrice = entity.tempATR[i];
          if (dataList[0].tempMAValueList == null)
            dataList[0].tempMAValueList =
                List<double>.filled(dataList.length, 0);
          if (dataList[0].tempMAValueList?.length != dataList.length)
            dataList[0].tempMAValueList =
                List<double>.filled(dataList.length, 0);
          for (int j = 0; j < maOutCols.length; j++) {
            ma[j] += closePrice;
            if (i == maDayList[maOutCols[j]] - 1) {
              dataList[0].tempMAValueList[i] = ma[j] / maDayList[maOutCols[j]];
            } else if (i >= maDayList[maOutCols[j]]) {
              ma[j] -= entity.tempATR[i - maDayList[maOutCols[j]]];
              dataList[0].tempMAValueList[i] = ma[j] / maDayList[maOutCols[j]];
            } else {
              dataList[0].tempMAValueList[i] = 0;
            }
          }
        }
      }
    }
  }

  static EMA(List<KLineEntity> dataList, List<int> maDayList,
      List<int> maOutCols, int t) {
    List<double> ma = List<double>.filled(maDayList.length, 0);
    //double ema = 0;
    List<double> ema = List<double>.filled(maDayList.length, 0);
    if (dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        KLineEntity entity = dataList[i];
        final closePrice = entity.close;
        if (entity.maValueList == null || entity.maValueList.length != t)
          entity.maValueList = List<double>.filled(t, 0);
        for (int j = 0; j < maOutCols.length; j++) {
          ma[j] = closePrice;
          if (i == 0) {
            ema[j] = ma[j];
            entity.maValueList[maOutCols[j]] = ema[j];
          } else {
            ema[j] = ema[j] *
                    (maDayList[maOutCols[j]] - 1) /
                    (maDayList[maOutCols[j]] + 1) +
                closePrice * 2 / (maDayList[maOutCols[j]] + 1);
            entity.maValueList[maOutCols[j]] = ema[j];
          }
        }
      }
    }
  }
  /*static EMA(
      List<KLineEntity> dataList, List<int> maDayList, List<int> maOutCols) {
    List<double> ma = List<double>.filled(maDayList.length, 0);

    if (dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        KLineEntity entity = dataList[i];
        final closePrice = entity.close;
        if (entity.maValueList == null)
          entity.maValueList = List<double>.filled(maDayList.length, 0);
        for (int j = 0; j < maOutCols.length; j++) {
          ma[j] += closePrice;
          if (i == maDayList[maOutCols[j]] - 1) {
            entity.maValueList[maOutCols[j]] = ma[j] / maDayList[maOutCols[j]];
          } else if (i >= maDayList[maOutCols[j]]) {
            ma[j] -= dataList[i - maDayList[maOutCols[j]]].close;
            entity.maValueList[maOutCols[j]] = ma[j] / maDayList[maOutCols[j]];
          } else {
            entity.maValueList[maOutCols[j]] = 0;
          }
        }
      }
    }
  }*/

  static void calcBOLL(
      List<KLineEntity> dataList, int n, int k, int bollId, int t) {
    _calcBOLLMA(n, dataList);
    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      if (entity.up == null || entity.up.length != t)
        entity.up = List<double>.filled(t, 0);
      if (entity.mb == null || entity.mb.length != t)
        entity.mb = List<double>.filled(t, 0);
      if (entity.dn == null || entity.dn.length != t)
        entity.dn = List<double>.filled(t, 0);
      if (i >= n) {
        double md = 0;
        for (int j = i - n + 1; j <= i; j++) {
          double c = dataList[j].close;
          double m = entity.BOLLMA;
          double value = c - m;
          md += value * value;
        }
        md = md / (n - 1);
        md = sqrt(md);
        entity.mb[bollId] = entity.BOLLMA;
        entity.up[bollId] = entity.mb[bollId] + k * md;
        entity.dn[bollId] = entity.mb[bollId] - k * md;
      }
    }
  }

  static void _calcBOLLMA(int day, List<KLineEntity> dataList) {
    double ma = 0;
    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      ma += entity.close;
      if (i == day - 1) {
        entity.BOLLMA = ma / day;
      } else if (i >= day) {
        ma -= dataList[i - day].close;
        entity.BOLLMA = ma / day;
      } else {
        entity.BOLLMA = null;
      }
    }
  }

  static void calcDonChain(List<KLineEntity> dataList, int n, int dcId, int t) {
    for (int i = 0; i < n - 1; i++) {
      KLineEntity entity = dataList[i];
      if (entity.dcUp == null || entity.dcUp.length != t)
        entity.dcUp = List<double>.filled(t, 0);
      if (entity.dcMd == null || entity.dcMd.length != t)
        entity.dcMd = List<double>.filled(t, 0);
      if (entity.dcLw == null || entity.dcLw.length != t)
        entity.dcLw = List<double>.filled(t, 0);
    }

    for (int i = n - 1; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      if (entity.dcUp == null || entity.dcUp.length != t)
        entity.dcUp = List<double>.filled(t, 0);
      if (entity.dcMd == null || entity.dcMd.length != t)
        entity.dcMd = List<double>.filled(t, 0);
      if (entity.dcLw == null || entity.dcLw.length != t)
        entity.dcLw = List<double>.filled(t, 0);

      double HiVal, LoVal;
      KLineEntity e = dataList[i - n + 1];
      HiVal = e.high;
      LoVal = e.low;

      for (int j = i - n + 2; j <= i; j++) {
        e = dataList[j];
        if (e.high > HiVal) {
          HiVal = e.high;
        }
        if (e.low < LoVal) {
          LoVal = e.low;
        }
      }
      entity.dcUp[dcId] = HiVal;
      entity.dcLw[dcId] = LoVal;
      entity.dcMd[dcId] = (HiVal + LoVal) / 2;
    }
  }

  static void calcMACD(
      List<KLineEntity> dataList, int p1, int p2, int oC, int t) {
    double ema12 = 0;
    double ema26 = 0;
    double dif = 0;
    double dea = 0;
    double macd = 0;

    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      final closePrice = entity.close;
      if (entity.dif == null || entity.dif.length != t)
        entity.dif = List<double>.filled(t, 0);
      if (entity.dea == null || entity.dea.length != t)
        entity.dea = List<double>.filled(t, 0);
      if (entity.macd == null || entity.macd.length != t)
        entity.macd = List<double>.filled(t, 0);
      if (i == 0) {
        ema12 = closePrice;
        ema26 = closePrice;
      } else {
        // ema12 = ema12 * 11 / 13 + closePrice * 2 / 13;
        // ema26 = ema26 * 25 / 27 + closePrice * 2 / 27;
        ema12 = ema12 * (p1 - 1) / (p1 + 1) + closePrice * 2 / (p1 + 1);
        ema26 = ema26 * (p2 - 1) / (p2 + 1) + closePrice * 2 / (p2 + 1);
      }

      dif = ema12 - ema26;
      dea = dea * 8 / 10 + dif * 2 / 10;
      macd = (dif - dea) * 2;
      entity.dif[oC] = dif;
      entity.dea[oC] = dea;
      entity.macd[oC] = macd;
    }
  }

  static void calcVolumeMA(List<KLineEntity> dataList) {
    double volumeMa5 = 0;
    double volumeMa10 = 0;

    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entry = dataList[i];

      volumeMa5 += entry.vol;
      volumeMa10 += entry.vol;

      if (i == 4) {
        entry.MA5Volume = (volumeMa5 / 5);
      } else if (i > 4) {
        volumeMa5 -= dataList[i - 5].vol;
        entry.MA5Volume = volumeMa5 / 5;
      } else {
        entry.MA5Volume = 0;
      }

      if (i == 9) {
        entry.MA10Volume = volumeMa10 / 10;
      } else if (i > 9) {
        volumeMa10 -= dataList[i - 10].vol;
        entry.MA10Volume = volumeMa10 / 10;
      } else {
        entry.MA10Volume = 0;
      }
    }
  }

  static void calcRSI(List<KLineEntity> dataList, int period, int t, int oC) {
    double rsi;
    double rsiABSEma = 0;
    double rsiMaxEma = 0;
    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      if (entity.rsi == null || entity.rsi.length != t)
        entity.rsi = List<double>.filled(t, 0);
      final double closePrice = entity.close;
      if (i == 0) {
        rsi = 0;
        rsiABSEma = 0;
        rsiMaxEma = 0;
      } else {
        double Rmax = max(0, closePrice - dataList[i - 1].close.toDouble());
        double RAbs = (closePrice - dataList[i - 1].close.toDouble()).abs();

        rsiMaxEma = (Rmax + (period - 1) * rsiMaxEma) / period;
        rsiABSEma = (RAbs + (period - 1) * rsiABSEma) / period;
        rsi = (rsiMaxEma / rsiABSEma) * 100;
      }
      if (i < period - 1) rsi = 0.0;
      if (rsi != null && rsi.isNaN) rsi = null;
      entity.rsi[oC] = rsi;
    }
  }

  static void calcKDJ(List<KLineEntity> dataList) {
    var preK = 50.0;
    var preD = 50.0;
    final tmp = dataList.first;
    tmp.k = preK;
    tmp.d = preD;
    tmp.j = 50.0;
    for (int i = 5; i < dataList.length; i++) {
      final entity = dataList[i];
      final n = max(0, i - 8);
      var low = entity.low;
      var high = entity.high;
      for (int j = n; j < i; j++) {
        final t = dataList[j];
        if (t.low < low) {
          low = t.low;
        }
        if (t.high > high) {
          high = t.high;
        }
      }
      final cur = entity.close;
      var rsv = (cur - low) * 100.0 / (high - low);
      rsv = rsv.isNaN ? 0 : rsv;
      final k = (2 * preK + rsv) / 3.0;
      final d = (2 * preD + k) / 3.0;
      final j = 3 * k - 2 * d;
      preK = k;
      preD = d;
      entity.k = k;
      entity.d = d;
      entity.j = j;
    }
  }

  static void calcStoch(List<KLineEntity> dataList) {
    var preK = 0.0;
    var preD = 0.0;
    final tmp = dataList.first;
    tmp.k = preK;
    tmp.d = preD;
    tmp.j = 0.0;
    int KPrd = 5, KSlowPrd = 3;
    for (int i = 0 + KPrd - 1; i < dataList.length; i++) {
      final entity = dataList[i];
      final n = max(0, i - KPrd);
      var low = entity.low;
      var high = entity.high;
      for (int j = n; j < i; j++) {
        final t = dataList[j];
        if (t.low < low) {
          low = t.low;
        }
        if (t.high > high) {
          high = t.high;
        }
      }

      final cur = entity.close;
      if (preK == 0) {
        preK = (cur - low);
        preD = (high - low);
      }
      var rsv = (cur - low) * 100.0 / (high - low);
      rsv = rsv.isNaN ? 0 : rsv;
      final k = rsv;
      //(2 * preK + rsv) / 3.0;
      final d = rsv;
      //(2 * preD + k) / 3.0;
      final j = rsv; //3 * k - 2 * d;
      preK = k;
      preD = d;
      entity.k = k;
      entity.d = d;
      entity.j = j;
    }
  }

  static void calcWR(List<KLineEntity> dataList, int period, int t, int oC) {
    double r;
    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      if (entity.r == null || entity.r.length != t)
        entity.r = List<double>.filled(t, 0);
      int startIndex = i - period;
      if (startIndex < 0) {
        startIndex = 0;
      }
      double max14 = double.minPositive;
      double min14 = double.maxFinite;
      for (int index = startIndex; index <= i; index++) {
        max14 = max(max14, dataList[index].high);
        min14 = min(min14, dataList[index].low);
      }
      if (i < period - 1) {
        entity.r[oC] = -10;
      } else {
        r = -100 * (max14 - dataList[i].close) / (max14 - min14);
        if (r.isNaN) {
          entity.r[oC] = -10.0; //null
        } else {
          entity.r[oC] = r;
        }
      }
    }
  }

  static void calcCCI(List<KLineEntity> dataList, int count, int t, int oC) {
    final size = dataList.length;
    //final count = 14;
    for (int i = 0; i < size; i++) {
      final kline = dataList[i];
      if (kline.cci == null || kline.cci.length != t)
        kline.cci = List<double>.filled(t, 0);
      final tp = (kline.high + kline.low + kline.close) / 3;
      final start = max(0, i - count + 1);
      var amount = 0.0;
      var len = 0;
      for (int n = start; n <= i; n++) {
        amount += (dataList[n].high + dataList[n].low + dataList[n].close) / 3;
        len++;
      }
      final ma = amount / len;
      amount = 0.0;
      for (int n = start; n <= i; n++) {
        amount +=
            (ma - (dataList[n].high + dataList[n].low + dataList[n].close) / 3)
                .abs();
      }
      final md = amount / len;
      kline.cci[oC] = ((tp - ma) / 0.015 / md);
      if (kline.cci[oC].isNaN) {
        kline.cci[oC] = 0.0;
      }
    }
  }

  static void calcATR(List<KLineEntity> dataList, int period, int t, int oC,
      {bool isTemp = false}) {

    if (!isTemp) {
      final size = dataList.length;
      //List<double> ma = List<double>.filled(0, 0);
      for (int i = 0; i < 1; i++) {
        final kline = dataList[i];
        if (kline.atr == null || kline.atr.length != t)
          kline.atr = List<double>.filled(t, 0);
      }
      for (int i = 1; i < size; i++) {
        final kline = dataList[i];
        if (kline.atr == null || kline.atr.length != t)
          kline.atr = List<double>.filled(t, 0);
        double HL, CH, CL, Dif;
        HL = dataList[i].high - dataList[i].low;
        CH = (dataList[i - 1].close - dataList[i].low).abs();
        CL = (dataList[i - 1].close - dataList[i].high).abs();
        Dif = max(HL, CH);
        kline.atr[oC] = max(Dif, CL);
      }
    }
    if (isTemp) {
      final size = dataList.length;
      // List<double> ma = List<double>.filled(0, 0);
      if (dataList[0].tempATR == null)
        dataList[0].tempATR = List<double>.filled(size, 0);
      if (dataList[0].tempATR?.length != size)
        dataList[0].tempATR = List<double>.filled(size, 0);

      for (int i = 1; i < size; i++) {
        // final kline = dataList[i];
        double HL, CH, CL, Dif;
        HL = dataList[i].high - dataList[i].low;
        CH = (dataList[i - 1].close - dataList[i].low).abs();
        CL = (dataList[i - 1].close - dataList[i].high).abs();
        Dif = max(HL, CH);
        dataList[0].tempATR[i] = max(Dif, CL);
        // var s = kline.tempATR;
      }
    }
  }

  static void calcSwing(
      List<KLineEntity> dataList, int swingDayList, int oC, int t) {
    List<double> _tempList = List.filled(dataList.length, 0);

    int StartBar, EndBar, InColH, InColL, InColC, OutCol, PrevTurnBar;
    double PrevTurn = dataList[0].close, RevPcnt, RevFactor1, RevFactor2;
    String SwingDir;

    PrevTurnBar = StartBar;
    SwingDir = 'U';
    RevPcnt = 3;
    RevFactor1 = (1.00 - RevPcnt / 100.0);
    RevFactor2 = (1.00 + RevPcnt / 100.0);

    if (dataList[0].swing == null || dataList[0].swing.length != t)
      dataList[0].swing = List<double>.filled(t, 0);

    dataList[0].swing[oC] = -1;

    _tempList[0] = -1;
    for (int i = 1; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      if (entity.swing == null || entity.swing.length != t)
        entity.swing = List<double>.filled(t, 0);

      entity.swing[oC] = 0;
      //First Condition
      if ((SwingDir == 'U') && (dataList[i].high >= PrevTurn)) {
        PrevTurn = dataList[i].high;
        PrevTurnBar = i;
      }
      //Second Condition
      else if ((SwingDir == 'U') &&
          (dataList[i].high < RevFactor1 * PrevTurn)) {
        SwingDir = 'D';
        entity.swing[oC] = 1;
        _tempList[PrevTurnBar] = dataList[PrevTurnBar].swing[oC] = 1.0;
        PrevTurn = dataList[i].low;
        PrevTurnBar = i;
      }
      //Third Condition
      else if ((SwingDir == 'D') && (dataList[i].low <= PrevTurn)) {
        PrevTurn = dataList[i].low;
        PrevTurnBar = i;
      }
      //Fourth Condition
      else if ((SwingDir == 'D') && (dataList[i].low > RevFactor2 * PrevTurn)) {
        SwingDir = 'U';
        entity.swing[oC] = -1;
        _tempList[PrevTurnBar] = dataList[PrevTurnBar].swing[oC] = -1.0;
        PrevTurn = dataList[i].high;
        PrevTurnBar = i;
      }
    }

    if (SwingDir == 'D')
      _tempList[PrevTurnBar] = dataList[PrevTurnBar].swing[oC] = -2;
    else
      _tempList[PrevTurnBar] = dataList[PrevTurnBar].swing[oC] = 2;
  }

  static void calcPriceTyp(List<KLineEntity> dataList, int oC, int t) {
    for (int i = 0; i < dataList.length; i++) {
      KLineEntity entity = dataList[i];
      if (entity.priceTyp == null || entity.priceTyp.length != t)
        entity.priceTyp = List<double>.filled(t, 0);
      entity.priceTyp[oC] = (entity.close + entity.high + entity.low) / 3.0;
    }
  }

  static void calcSuperTrend(
      List<KLineEntity> dataList, int Factor, int AvgPeriod, int oC, int t) {
    double prevUpperValue, preLowerValue, currUpperValue, currLowerValue;
    int prevTrendValue, currTrendValue;

    //CAL ATR
    calcATR(dataList, AvgPeriod, t, oC, isTemp: true);
    //CAL SMA
    SMA(dataList, [AvgPeriod], [0], t, isTemp: true);

    //CAL superTrend

    for (int i = AvgPeriod; i < dataList.length; i++) {
      dataList[0].tempATR[i] = (dataList[i].high + dataList[i].low) / 2.0;
    }

    prevTrendValue = 1;
    prevUpperValue = dataList[0].tempATR[AvgPeriod] +
        Factor * dataList[0].tempMAValueList[AvgPeriod];
    preLowerValue = dataList[0].tempATR[AvgPeriod] -
        Factor * dataList[0].tempMAValueList[AvgPeriod];

    for (int i = 0; i < AvgPeriod + 1; i++) {
      if (dataList[i].supertrend == null ||
          dataList[i].supertrend.length != t) {
        dataList[i].supertrend = List<double>.filled(t, 0);
      }
    }

    for (int i = AvgPeriod + 1; i < dataList.length; i++) {
      if (dataList[i].supertrend == null ||
          dataList[i].supertrend.length != t) {
        dataList[i].supertrend = List<double>.filled(t, 0);
      }

      currUpperValue =
          dataList[0].tempATR[i] + Factor * dataList[0].tempMAValueList[i];
      currLowerValue =
          dataList[0].tempATR[i] - Factor * dataList[0].tempMAValueList[i];

      if (dataList[i].close > prevUpperValue)
        currTrendValue = 1;
      else if (dataList[i].close < preLowerValue)
        currTrendValue = -1;
      else
        currTrendValue = prevTrendValue;

      dataList[i].supertrend[oC] = currUpperValue;

      if ((currTrendValue < 0) && (prevTrendValue > 0)) {
        dataList[i].supertrend[oC] = currUpperValue;
      } else if ((currTrendValue > 0) && (prevTrendValue < 0)) {
        dataList[i].supertrend[oC] = currLowerValue;
      } else if (currTrendValue > 0) {
        currLowerValue = max(currLowerValue, preLowerValue);
        dataList[i].supertrend[oC] = currLowerValue;
      } else if (currTrendValue < 0) {
        currUpperValue = min(currUpperValue, prevUpperValue);
        dataList[i].supertrend[oC] = currUpperValue;
      }

      preLowerValue = currLowerValue;
      prevUpperValue = currUpperValue;
      prevTrendValue = currTrendValue;
    }
  }

  static void calcAdx(
      {List<KLineEntity> dataList,
      int di_period = 4,
      int Adx_Period = 4,
      int oC = 0,
      int t = 1}) {
    int StartBar, EndBar, InColH, InColL, InColC, OutCol1, OutCol2, OutCol3;
    int TempCol1, TempCol2, TempCol3;
    int DIPrd, DXPrd;
    double HL, CH, CL;
    double PositiveDM1, NegetiveDM1, PDMx, NDMx, TRx, DXSum;
    double FactorDI;

    EndBar = dataList.length;
    StartBar = 0;
    DIPrd = di_period;
    DXPrd = Adx_Period;

    List<List<double>> tmparray = List.generate(
        3, (i) => List.filled(dataList.length, 0),
        growable: false);
    TempCol1 = 0;
    TempCol2 = 1;
    TempCol3 = 2;

    KLineEntity kLineEntity;
    KLineEntity kLineEntity1;
    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i].Adxup == null || dataList[i].Adxup.length != t)
        dataList[i].Adxup = List<double>.filled(t, 0);
      if (dataList[i].Adxmb == null || dataList[i].Adxmb.length != t)
        dataList[i].Adxmb = List<double>.filled(t, 0);
      if (dataList[i].Adxdn == null || dataList[i].Adxdn.length != t)
        dataList[i].Adxdn = List<double>.filled(t, 0);
    }

    //CAL ADx
    if (StartBar + DIPrd <= EndBar) {
      //FIRST FOR LOOP
      for (int i = StartBar + 1; i < EndBar; i++) {
        kLineEntity = dataList[i];
        kLineEntity1 = dataList[i - 1];
        kLineEntity.Adxup[oC] = 0;
        kLineEntity.Adxmb[oC] = 0;
        kLineEntity.Adxdn[oC] = 0;

        HL = kLineEntity.high - kLineEntity.low;
        CL = (kLineEntity1.close - kLineEntity.low).abs();
        CH = (kLineEntity1.close - kLineEntity.high).abs();
        kLineEntity.Adxdn[oC] = max(CL, max(HL, CH));

        PositiveDM1 = kLineEntity.high - kLineEntity1.high;
        NegetiveDM1 = kLineEntity1.low - kLineEntity.low;

        if ((PositiveDM1 > 0) && (PositiveDM1 > NegetiveDM1))
          kLineEntity.Adxup[oC] = PositiveDM1;
        else if ((NegetiveDM1 > 0) && (PositiveDM1 < NegetiveDM1))
          kLineEntity.Adxmb[oC] = NegetiveDM1;
      }

      PDMx = 0.00;
      NDMx = 0.00;
      TRx = 0.00;

      //SECOND FOR LOOP
      for (int i = StartBar + 1; i < StartBar + DIPrd - 1; i++) {
        kLineEntity = dataList[i];

        /* if (kLineEntity.Adxup == null)
          kLineEntity.Adxup = List<double>.filled(t, 0);
        if (kLineEntity.Adxmb == null)
          kLineEntity.Adxmb = List<double>.filled(t, 0);
        if (kLineEntity.Adxdn == null)
          kLineEntity.Adxdn = List<double>.filled(t, 0);*/

        PDMx += kLineEntity.Adxup[oC];
        NDMx += kLineEntity.Adxmb[oC];
        TRx += kLineEntity.Adxdn[oC];
      }

      tmparray[TempCol1][StartBar + DIPrd - 1] = PDMx;
      tmparray[TempCol2][StartBar + DIPrd - 1] = NDMx;
      tmparray[TempCol3][StartBar + DIPrd - 1] = TRx;

      FactorDI = (DIPrd - 1.0) / DIPrd;

      //THIRD FOR LOOP
      for (int i = StartBar + DIPrd; i < EndBar; i++) {
        kLineEntity = dataList[i];

        /*if (kLineEntity.Adxup == null)
          kLineEntity.Adxup = List<double>.filled(t, 0);
        if (kLineEntity.Adxmb == null)
          kLineEntity.Adxmb = List<double>.filled(t, 0);
        if (kLineEntity.Adxdn == null)
          kLineEntity.Adxdn = List<double>.filled(t, 0);*/

        tmparray[TempCol1][i] =
            FactorDI * tmparray[TempCol1][i - 1] + kLineEntity.Adxup[oC];
        tmparray[TempCol2][i] =
            FactorDI * tmparray[TempCol2][i - 1] + kLineEntity.Adxmb[oC];
        tmparray[TempCol3][i] =
            FactorDI * tmparray[TempCol3][i - 1] + kLineEntity.Adxdn[oC];
      }

      //FOURTH FOR LOOP
      for (int i = StartBar + DIPrd; i < EndBar; i++) {
        kLineEntity = dataList[i];

        /* if (kLineEntity.Adxup == null)
          kLineEntity.Adxup = List<double>.filled(t, 0);
        if (kLineEntity.Adxmb == null)
          kLineEntity.Adxmb = List<double>.filled(t, 0);
        if (kLineEntity.Adxdn == null)
          kLineEntity.Adxdn = List<double>.filled(t, 0);
*/
        if (tmparray[TempCol3][i] > 0.01) {
          kLineEntity.Adxup[oC] =
              100.0 * (tmparray[TempCol1][i] / tmparray[TempCol3][i]);
          kLineEntity.Adxmb[oC] =
              100.0 * (tmparray[TempCol2][i] / tmparray[TempCol3][i]);
        } else {
          kLineEntity.Adxup[oC] = 0.00;
          kLineEntity.Adxmb[oC] = 0.00;
        }

        if (kLineEntity.Adxup[oC] + kLineEntity.Adxmb[oC] > 0.01)
          kLineEntity.Adxdn[oC] = 100.0 *
              (kLineEntity.Adxup[oC] - kLineEntity.Adxmb[oC]).abs() /
              (kLineEntity.Adxup[oC] + kLineEntity.Adxmb[oC]);
        else
          kLineEntity.Adxdn[oC] = 0.00;

        // var s = kLineEntity.Adxdn[oC];
      }

      //Average
      if (StartBar + DIPrd + DXPrd <= EndBar) {
        DXSum = 0.00;
        for (int i = StartBar + DIPrd; i < StartBar + DIPrd + DXPrd - 1; i++) {
          kLineEntity = dataList[i];
          kLineEntity1 = dataList[i - 1];

          DXSum += kLineEntity.Adxdn[oC];
        }
        dataList[StartBar + DIPrd + DXPrd - 1].Adxdn[oC] = DXSum / DXPrd;

        for (int i = StartBar + DIPrd + DXPrd; i < EndBar; i++) {
          kLineEntity = dataList[i];
          kLineEntity1 = dataList[i - 1];
          kLineEntity.Adxdn[oC] =
              ((DXPrd - 1) * kLineEntity1.Adxdn[oC] + kLineEntity.Adxdn[oC]) /
                  DXPrd;

          // var s = kLineEntity.Adxdn[oC];
        }
      }

      for (int i = 0; i < di_period; i++) {
        kLineEntity = dataList[i];
        kLineEntity.Adxdn[oC] = 0;
        kLineEntity.Adxmb[oC] = 0;
        kLineEntity.Adxup[oC] = 0;
      }

      var s = dataList;
    }
  }
}
