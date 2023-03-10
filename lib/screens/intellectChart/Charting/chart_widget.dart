import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:markets/screens/intellectChart/Charting/extension/map_ext.dart';
import 'package:markets/screens/intellectChart/Charting/renderer/chart_painter.dart';
import 'package:markets/screens/intellectChart/Charting/utils/date_format_util.dart';
import 'package:markets/screens/intellectChart/Charting/xGestureDetector.dart';
import 'package:markets/util/Dataconstants.dart';

import '../../../jmScreens/orders/OrderPlacement/order_placement_screen.dart';
import '../../../model/scrip_info_model.dart';
import '../../../util/CommonFunctions.dart';
import '../../scrip_details_screen.dart';
import 'chart_style.dart';
import 'chart_translations.dart';
import 'entity/info_window_entity.dart';
import 'entity/k_line_entity.dart';
import 'entity/studies.dart';
import 'renderer/base_chart_painter.dart';

enum MainState {
  PRICE,
  MA,
  BOLL,
  SWING,
  DONCHAIN,
  VWAP,
  PRICETYP,
  STREND,
  NONE
}
enum SecondaryState { VOL, ATR, MACD, KDJ, RSI, WR, CCI, ADX, NONE }
enum RateStyle { Default, Rupees }

class TimeFormat {
  static const List<String> YEAR_MONTH_DAY = [yyyy, '-', mm, '-', dd];
  static const List<String> DAY_MONTH_YEAR = [dd, '-', mm, '-', yyyy];
  static const List<String> YEAR_MONTH_DAY_WITH_HOUR = [
    yyyy,
    '-',
    mm,
    '-',
    dd,
    ' ',
    HH,
    ':',
    nn
  ];
}

class ChartingWidget extends StatefulWidget {
  final String symbol;
  final List<KLineEntity> datas;
  final List<MainState> mainState;
  final bool volHidden;
  final SecondaryState secondaryState;
  final SecondaryState tertiaryState;
  final Function() onSecondaryTap;
  final bool isLine;
  final bool hideGrid;

  // final bool isChinese;
  final bool showNowPrice;
  final Map<String, ChartTranslations> translations;

  final List<String> timeFormat;

  //It will be called when the screen scrolls to the end，Really pull it to the end of the right side of the screen，Fake it to the end of the left side of the screen
  final Function(bool) onLoadMore;
  final List<Color> bgColor;
  final int fixedLength;
  final List<int> maDayList;
  final int flingTime;
  final double flingRatio;
  final Curve flingCurve;
  final Function(bool) isOnDrag;
  final ChartColors chartColors;
  final ChartStyle chartStyle;
  final bool scaleCanvas;
  final String chartPeriod;
  final double chartInterval;
  final ChartStudies chartStudies;
  final bool buySellButtonActivate;
  final bool lineOnTick;
  final ScripInfoModel model;
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;

  ChartingWidget(
    this.symbol,
    this.datas,
    this.chartStyle,
    this.chartColors,
    this.chartPeriod,
    this.chartInterval,
    this.chartStudies, {
    this.scaleCanvas = true,
    this.mainState, //MainState.NONE,
    this.secondaryState = SecondaryState.NONE,
    this.tertiaryState = SecondaryState.NONE,
    this.onSecondaryTap,
    this.volHidden = false,
    this.isLine = false,
    this.hideGrid = false,
    this.showNowPrice = true,
    this.translations = kChartTranslations,
    this.timeFormat = TimeFormat.DAY_MONTH_YEAR,
    this.onLoadMore,
    this.bgColor,
    this.fixedLength = 2,
    this.maDayList = const [10, 50, 200],
    this.flingTime = 600,
    this.flingRatio = 0.5,
    this.flingCurve = Curves.decelerate,
    this.isOnDrag,
    this.buySellButtonActivate,
    this.model,
    this.lineOnTick,
    this.scaffoldKey,
  });

  @override
  _KChartWidgetState createState() => _KChartWidgetState();
}

class _KChartWidgetState extends State<ChartingWidget>
    with TickerProviderStateMixin {
  double mScaleX = 0.5, mScrollX = 0.0, mSelectX = 0.0, mSelectY = 0.0;
  double lastScalePadding = 0, contentPadding = 1;
  StreamController<InfoWindowEntity> mInfoWindowStream;
  double mWidth = 0;
  AnimationController _controller;
  Animation<double> aniX;
  String lastEventName = 'Tap on screen';

  // double getMinScrollX() {
  //   return mScaleX;
  // }

  double _lastScale = 0.5;
  bool isScale = false,
      isDrag = false,
      isLongPress = false,
      // lineOnTick = false,
      isLongPress2 = false,
      isScalePadding = false;
  bool _hideGrid = false;
  TextEditingController _qtyContoller;
  TextEditingController _limitController;

  @override
  void initState() {
    _qtyContoller = TextEditingController();
    _limitController = TextEditingController();
    super.initState();
    mInfoWindowStream = StreamController<InfoWindowEntity>();
    _hideGrid = widget.hideGrid;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mWidth = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    mInfoWindowStream?.close();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.datas != null && widget.datas.isEmpty) {
      mScrollX = mSelectX = mSelectY = 0.0;
      mScaleX = 1.0;
    }
    // return ChartingGestureWidget();
    //Complete drawing of chart.
    bool notchPhone;
    bool landscape =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    notchPhone = (landscape) ? IphoneHasNotch.hasNotchLandScape : false;
    int wAdjust = (notchPhone && landscape) ? 100 : 0;
    final _painter = ChartPainter(
        widget.symbol,
        widget.chartStyle,
        widget.chartColors,
        false,
        widget.chartPeriod,
        widget.chartInterval,
        0 /*this.contentPadding*/,
        datas: widget.datas,
        chartStudies: widget.chartStudies,
        scaleX: mScaleX,
        scrollX: mScrollX,
        selectX: mSelectX,
        selectY: mSelectY,
        isLongPass: isLongPress,
        isLongPass2: isLongPress2,
        mainState: widget.mainState,
        volHidden: widget.volHidden,
        secondaryState: widget.secondaryState,
        tertiaryState: widget.tertiaryState,
        isLine: widget.isLine,
        hideGrid: _hideGrid,
        //widget.hideGrid,
        showNowPrice: widget.showNowPrice,
        sink: mInfoWindowStream?.sink,
        bgColor: widget.bgColor,
        fixedLength: widget.fixedLength,
        maDayList: widget.maDayList,
        buySellButtonActivate: widget.buySellButtonActivate,
        lineOnTick: widget.lineOnTick);
    return XGestureDetector(
      doubleTapTimeConsider: 300,
      longPressTimeConsider: 350,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onLongPressEnd: onLongPressEnd,
      onMoveStart: onMoveStart,
      onMoveEnd: onMoveEnd,
      onMoveUpdate: onMoveUpdate,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      bypassTapEventOnDoubleTap: false,
      // buySellButtonActivate: widget.buySellButtonActivate,
      child: Listener(
        onPointerDown: (e) {
          isLongPress = false;
          isLongPress2 = false;
          // double x = e.position.dx.round().toDouble();
          // double y = (e.position.dy).round().toDouble();
          // //print(
          //     'result.put("onDown  ",  ${e.timeStamp.inMilliseconds}, ${e.pointer}, new Point<double>($x, $y}));');
        },
        onPointerMove: (e) {
          if (widget.buySellButtonActivate == false) {
            if (isScale || isLongPress) return;
            mScrollX = (e.delta.dx / mScaleX + mScrollX)
                .clamp(0.0, ChartPainter.maxScrollX)
                .toDouble();
            notifyChanged();
          }
        },
        onPointerUp: (e) {},
        onPointerCancel: (e) {
          // double x = e.position.dx.round().toDouble();
          // double y = (e.position.dy).round().toDouble();
          // //print(
          //     'result.put("onCancel",  ${e.timeStamp.inMilliseconds}, ${e.pointer}, new Point<double>($x, $y}));');
        },
        child: GestureDetector(
          onTapUp: (details) {
            isLongPress = false;
            // if(Dataconstants.chartTickByTick==true) {
            //   lineOnTick = !lineOnTick ;
            //    mSelectX = details.localPosition.dx;   //ssss
            //    mSelectY = details.localPosition.dy;
            //
            //  }
            // isLongPress2 = true;

            // if (widget.onSecondaryTap != null &&
            //     _painter.isInSecondaryRect(details.localPosition)) {
            //   widget.onSecondaryTap();
            // }
            ///-------------Buy Sell Button logic---------------  ssss
            if (widget.buySellButtonActivate == true) {
              var index = _painter.calculateSelectedX(mSelectX);
              KLineEntity point = _painter.getItem(index);
              if (mSelectX == 0.0) {
                mSelectX = 180.0;
              }
              if (mSelectY == 0.0) {
                mSelectY = 255.0;
              }
              var dx = details.localPosition.dx; //ssss
              var dy = details.localPosition.dy;
              var buyMdx1 = mSelectX + 12;
              var buyMdx2 = mSelectX + 80;
              var sellMdx1 = mSelectX - 12;
              var sellMdx2 = mSelectX - 80;
              var mdy1 = mSelectY - 15;
              var mdy2 = mSelectY - 45;
              double displayPoint = mSelectY - 0;
              double yPixel = _painter.getYPixel(displayPoint);

              if ((buyMdx1 <= dx && dx <= buyMdx2) &&
                  (mdy1 >= dy && dy >= mdy2)) {
                /// -----Buy logic-----

                Dataconstants.isFromChart = true;
                // Dataconstants.buySellPointColor=true;
                Dataconstants.ltpTickByTick = yPixel;
                // Dataconstants.defaultBuySellChartSetting=false;
                // orderNavigate(false,yPixel);
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>
                        CommonFunction.alertDiealougeForChart(
                          Dataconstants.theme,
                          1,
                          _limitController,
                          1,
                          _qtyContoller,
                          context,
                          yPixel,
                          widget.model,
                          true,
                          widget.scaffoldKey,
                        ));
                //print("buy success");
              } else if ((sellMdx1 >= dx && dx >= sellMdx2) &&
                  (mdy1 >= dy && dy >= mdy2)) {
                /// ------Sell logic---------
                Dataconstants.isFromChart = true;
                Dataconstants.ltpTickByTick = yPixel;
                // Dataconstants.defaultBuySellChartSetting=false;
                // if(!Dataconstants.defaultBuySellChartSetting)
                {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          CommonFunction.alertDiealougeForChart(
                            Dataconstants.theme,
                            1,
                            _limitController,
                            1,
                            _qtyContoller,
                            context,
                            yPixel,
                            widget.model,
                            false,
                            widget.scaffoldKey,
                          ));
                  Dataconstants.drawLineOnBuySell.add(true);
                }

                // orderNavigate(true,yPixel);
                //print("sell success");
              } else {
                //print("condition not satisfied");
              }
            }
          },
          onHorizontalDragDown: (details) {
            _stopAnimation();
            _onDragChanged(true);
          },
          onHorizontalDragUpdate: (details) {
            if (widget.buySellButtonActivate == true) {
              mSelectX = details.localPosition.dx;
              mSelectY = details.localPosition.dy;
              notifyChanged();
            }
            // if (isScale || isLongPress) return;
            // //mScrollX = (details.primaryDelta / mScaleX + mScrollX)
            // mScrollX = (details.delta.dx / mScaleX + mScrollX)
            //     .clamp(0.0, ChartPainter.maxScrollX)
            //     .toDouble();
            // notifyChanged();
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (widget.buySellButtonActivate == false) {
              var velocity = details.velocity.pixelsPerSecond.dx;
              _onFling(velocity);
            }
          },
          onHorizontalDragCancel: () => _onDragChanged(false),
          /*onScaleStart: (_) {
            isScale = true;
          },
          onSecondaryLongPressMoveUpdate: (details) {
            // //print('onSecondaryLongPressMoveUpdate');
          },
          onScaleUpdate: (details) {
            // //print('scale: ' + details.scale.toString() + '\n\n');
            if (isDrag || isLongPress) {
              // //print('pinch prevented');
              return;
            }
            mScaleX =
                (_lastScale * details.scale).clamp(0.2, 2.2); //.clamp(0.5, 2.2);
            // //print(mScaleX);
            notifyChanged();
          },
          onScaleEnd: (_) {
            isScale = false;
            _lastScale = mScaleX;
          },*/
          onLongPressStart: (details) {
            if (isScalePadding) return;
            isLongPress = true;
            isLongPress2 = false;
            /*if (mSelectX != details.localPosition.dx)*/
            {
              mSelectX = details.localPosition.dx; //ssss
              mSelectY = details.localPosition.dy;
              // notifyChanged();
            }
          },
          onLongPressMoveUpdate: (details) {
            /*if (mSelectX != details.localPosition.dx)*/ {
              mSelectX = details.localPosition.dx;
              mSelectY = details.localPosition.dy;
              notifyChanged();
            }
          },
          onLongPressEnd: (details) {
            // isLongPress = false;
            mInfoWindowStream.sink.add(null);
            notifyChanged();
          },
          onDoubleTap: () {
            _hideGrid = !_hideGrid;
            notifyChanged();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: <Widget>[
                  CustomPaint(
                    size: Size(
                        /*double.infinity*/
                        MediaQuery.of(context).size.width -
                            wAdjust /*-
                            60*/
                        ,
                        double.infinity),
                    painter: _painter,
                  ),
                ],
              ),
              /*Container(
                width: 60,
                child: CustomPaint(
                  size: Size(
                      /*double.infinity*/ 50, // MediaQuery.of(context).size.width,
                      double.infinity),
                  painter: _painterScale,
                ),
              ),*/
              /*Expanded(
                flex: 1,
                child: PriceColumn(
                  low: Global.chartLow, // 37500.00,
                  high: Global.chartHigh, //40000.00,
                  priceScale: 500,
                  width: 350.00,
                  chartHeight:
                      (MediaQuery.of(context).orientation == Orientation.portrait)
                          ? MediaQuery.of(context).size.height * 0.64
                          : MediaQuery.of(context).size.height * 0.48, //530.00,
                  lastCandleclose: Global.chartVisibleClose, //38075.3,
                  // onScale: (delta) {},
                  additionalVerticalPadding: 0.0,
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  /// ssss
  void orderNavigate(
    bool isSellButton,
    double close,
  ) {
    if (!CommonFunction.isTradingAllowed(widget.model.exchCategory)) return;
    if (widget.model.exchCategory == ExchCategory.nseEquity ||
        widget.model.exchCategory == ExchCategory.bseEquity ||
        widget.model.exchCategory == ExchCategory.nseFuture ||
        widget.model.exchCategory == ExchCategory.nseOptions ||
        widget.model.exchCategory == ExchCategory.mcxFutures ||
        widget.model.exchCategory == ExchCategory.currenyFutures ||
        widget.model.exchCategory == ExchCategory.currenyOptions) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return OrderPlacementScreen(
              model: widget.model,
              orderType: ScripDetailType.none,
              isBuy: !isSellButton,
              selectedExch: widget.model.exch,
              stream: Dataconstants.pageController.stream,
            );
          },
        ),
      );
    }
    // if (widget.model.exchCategory == ExchCategory.nseEquity ||
    //     widget.model.exchCategory == ExchCategory.bseEquity) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return EquityOrderScreen(
    //           reportCalledFrom: Dataconstants.reportCalledFrom,
    //           model: widget.model,
    //           isBuy: !isSellButton,
    //           // close:close,
    //         );
    //       },
    //     ),
    //   );
    // }
    // else if (widget.model.exchCategory == ExchCategory.nseFuture) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return FutureOrderScreen(
    //           reportCalledFrom: Dataconstants.reportCalledFrom,
    //           model: widget.model,
    //           isBuy: !isSellButton,
    //           // close:close,
    //         );
    //       },
    //     ),
    //   );
    // }
    // else if (widget.model.exchCategory == ExchCategory.nseOptions) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return OptionOrderScreen(
    //           reportCalledFrom: Dataconstants.reportCalledFrom,
    //           model: widget.model,
    //           isBuy: !isSellButton,
    //           // close:close,
    //         );
    //       },
    //     ),
    //   );
    // }
    // else if (widget.model.exchCategory == ExchCategory.mcxFutures) {
    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //     return CommodityOrderScreen(
    //       reportCalledFrom: Dataconstants.reportCalledFrom,
    //       model: widget.model,
    //       isBuy: !isSellButton,
    //       // close:close,
    //     );
    //   }));
    // }
    else if (widget.model.exchCategory == ExchCategory.mcxOptions) {
      CommonFunction.showBasicToast(
          'The current version does not support trading in this segment.');
    }
    // else if (widget.model.exchCategory == ExchCategory.currenyFutures ||
    //     widget.model.exchCategory == ExchCategory.currenyOptions) {
    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    //     return CurencyOrderScreen(
    //       reportCalledFrom: Dataconstants.reportCalledFrom,
    //       model: widget.model,
    //       isBuy: !isSellButton,
    //       // close:close,
    //     );
    //   }));
    // }
    else
      CommonFunction.showBasicToast(
          'The current version does not support trading in this segment.');
  }

  void _stopAnimation({bool needNotify = true}) {
    if (_controller != null && _controller.isAnimating) {
      _controller.stop();
      _onDragChanged(false);
      if (needNotify) {
        notifyChanged();
      }
    }
  }

  void _onDragChanged(bool isOnDrag) {
    // isDrag = isOnDrag;
    if (widget.isOnDrag != null) {
      widget.isOnDrag(isDrag);
    }
  }

  //horizontal drag end event.
  void _onFling(double x) {
    // return;
    if (isLongPress || isLongPress2) return;
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.flingTime), vsync: this);
    aniX = null;
    aniX = Tween<double>(begin: mScrollX, end: x * widget.flingRatio + mScrollX)
        .animate(CurvedAnimation(
            parent: _controller.view, curve: widget.flingCurve));
    aniX.addListener(() {
      mScrollX = aniX.value;
      if (mScrollX <= 0) {
        mScrollX = 0;
        if (widget.onLoadMore != null) {
          widget.onLoadMore(true);
        }
        _stopAnimation();
      } else if (mScrollX >= ChartPainter.maxScrollX) {
        mScrollX = ChartPainter.maxScrollX;
        if (widget.onLoadMore != null) {
          widget.onLoadMore(false);
        }
        _stopAnimation();
      }
      notifyChanged();
    });
    aniX.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _onDragChanged(false);
        notifyChanged();
      }
    });
    _controller.forward();
  }

  void notifyChanged() => setState(() {});

  List<String> infos;

  Widget _buildInfoDialog() {
    return StreamBuilder<InfoWindowEntity>(
        stream: mInfoWindowStream?.stream,
        builder: (context, snapshot) {
          if (!isLongPress ||
              !isLongPress2 ||
              widget.isLine == true ||
              !snapshot.hasData ||
              snapshot.data?.kLineEntity == null) return Container();
          KLineEntity entity = snapshot.data.kLineEntity;
          double upDown = entity.change ?? entity.close - entity.open;
          double upDownPercent = entity.ratio ?? (upDown / entity.open) * 100;
          infos = [
            getDate(entity.time),
            entity.open.toStringAsFixed(widget.fixedLength),
            entity.high.toStringAsFixed(widget.fixedLength),
            entity.low.toStringAsFixed(widget.fixedLength),
            entity.close.toStringAsFixed(widget.fixedLength),
            "${upDown > 0 ? "+" : ""}${upDown.toStringAsFixed(widget.fixedLength)}",
            "${upDownPercent > 0 ? "+" : ''}${upDownPercent.toStringAsFixed(2)}%",
            entity.amount.toInt().toString()
          ];
          return Container(
            margin: EdgeInsets.only(
                left: snapshot.data.isLeft
                    ? 4
                    : (mWidth - 60) - (mWidth - 60) / 3 - 4,
                top: 25),
            width: (mWidth - 60) / 3,
            decoration: BoxDecoration(
                color: widget.chartColors.selectFillColor,
                border: Border.all(
                    color: widget.chartColors.selectBorderColor, width: 0.5)),
            child: ListView.builder(
              padding: EdgeInsets.all(4),
              itemCount: infos.length,
              itemExtent: 14.0,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // final translations = widget.isChinese
                //     ? kChartTranslations['zh_CN']
                //     : widget.translations.of(context);
                final translations = widget.translations.of(context);

                return _buildItem(
                  infos[index],
                  translations.byIndex(index),
                );
              },
            ),
          );
        });
  }

  Widget _buildItem(String info, String infoName) {
    Color color = widget.chartColors.infoWindowNormalColor;
    if (info.startsWith("+"))
      color = widget.chartColors.infoWindowUpColor;
    else if (info.startsWith("-"))
      color = widget.chartColors.infoWindowDnColor;
    else
      color = widget.chartColors.infoWindowNormalColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Text("$infoName",
                style: TextStyle(
                    color: widget.chartColors.infoWindowTitleColor,
                    fontSize: 10.0))),
        Text(info, style: TextStyle(color: color, fontSize: 10.0)),
      ],
    );
  }

  String getDate(int date) => dateFormat(
      DateTime.fromMillisecondsSinceEpoch(
          date ?? DateTime.now().millisecondsSinceEpoch),
      widget.timeFormat);

  void onScaleEnd() {
    setLastEventName('onScaleEnd');
    // //print('onScaleEnd');

    isScale = false;
    isScalePadding = false;
    _lastScale = mScaleX;
  }

  void onScaleUpdate(ScaleEvent event) {
    setLastEventName('onScaleUpdate');
    // //print(
    //     'onScaleUpdate - changedFocusPoint:  ${event.focalPoint} ; scale: ${event.scale} ;Rotation: ${event.rotationAngle}');
    double scaleVal;
    double a;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    if (mediaQueryData.orientation == Orientation.portrait)
      a = 65;
    else
      a = 30;
    if (mediaQueryData.size.width - 50.0 < event.focalPoint.dx) {
      scaleVal = event.scale.clamp(0.1, 9.0);
      if (lastScalePadding == scaleVal) return;
      isScalePadding = true;
      if (lastScalePadding > scaleVal)
        this.contentPadding = min(this.contentPadding + 1.5, a);
      else
        this.contentPadding = max(this.contentPadding - 1.5, 1);

      lastScalePadding = scaleVal;
      // //print('scale ${this.contentPadding}');
      notifyChanged();
      return;
    }
    if (isDrag || isLongPress || isLongPress2 || isScalePadding) {
      // //print('pinch prevented');
      return;
    }
    mScaleX = (_lastScale * event.scale).clamp(0.06, 2.2); //.clamp(0.5, 2.2);
    // //print(mScaleX);
    notifyChanged();
  }

  void onScaleStart(initialFocusPoint) {
    setLastEventName('onScaleStart');
    // //print('onScaleStart - initialFocusPoint: $initialFocusPoint');

    isScale = true;
  }

  void onMoveUpdate(MoveEvent event) {
    setLastEventName('onMoveUpdate');
    // //print('onMoveUpdate - pos: ${event.localPos} delta: ${event.delta}');

    // if (isLongPress) {
    //   /*if (mSelectX != event.localPos.dx)*/ {
    //     mSelectX = event.localPos.dx;
    //     mSelectY = event.localPos.dy;
    //     notifyChanged();
    //   }
    // }
  }

  void onMoveEnd(localPos) {
    setLastEventName('onMoveEnd');
    // //print('onMoveEnd - pos: $localPos');
  }

  void onMoveStart(localPos) {
    setLastEventName('onMoveStart');
    // //print('onMoveStart - pos: $localPos');
  }

  void onLongPress(TapEvent event) {
    setLastEventName('onLongPress');

    // //print('onLongPress - pos: ${event.localPos}');

    // isLongPress = true;
    // if (mSelectX != event.position.dx) {
    //   mSelectX = event.position.dx;
    //   mSelectY = event.position.dy;
    //   notifyChanged();
    // }
  }

  void onLongPressEnd() {
    setLastEventName('onLongPressEnd');
    // //print('onLongPressEnd');

    // isLongPress = false;
    // mInfoWindowStream.sink.add(null);
    // notifyChanged();
  }

  void onDoubleTap(event) {
    setLastEventName('onDoubleTap');
    // //print('onDoubleTap - pos: ' + event.localPos.toString());
  }

  void onTap(event) {
    setLastEventName('onTap');
    // //print('onTap - pos: ' + event.localPos.toString());
  }

  void setLastEventName(String eventName) {
    setState(() {
      lastEventName = eventName;
    });
  }
}

class IphoneHasNotch {
  /// Returns true in case it is iPhone & it has notch.
  static bool get hasNotch {
    if (Platform.isIOS &&
        (ui.window.physicalSize.height.toInt() == 812 ||
            ui.window.physicalSize.height.toInt() == 812 * 2 ||
            ui.window.physicalSize.height.toInt() == 812 * 3 ||
            ui.window.physicalSize.height.toInt() == 896 ||
            ui.window.physicalSize.height.toInt() == 896 * 2 ||
            ui.window.physicalSize.height.toInt() == 896 * 3 ||
            // iPhone 12 pro
            ui.window.physicalSize.height.toInt() == 844 ||
            ui.window.physicalSize.height.toInt() == 844 * 2 ||
            ui.window.physicalSize.height.toInt() == 844 * 3 ||
            // Iphone 12 pro max
            ui.window.physicalSize.height.toInt() == 926 ||
            ui.window.physicalSize.height.toInt() == 926 * 2 ||
            ui.window.physicalSize.height.toInt() == 926 * 3)) {
      return true;
    } else {
      return false;
    }
  }

  static bool get hasNotchLandScape {
    if (Platform.isIOS &&
        (ui.window.physicalSize.width.toInt() == 812 ||
            ui.window.physicalSize.width.toInt() == 812 * 2 ||
            ui.window.physicalSize.width.toInt() == 812 * 3 ||
            ui.window.physicalSize.width.toInt() == 896 ||
            ui.window.physicalSize.width.toInt() == 896 * 2 ||
            ui.window.physicalSize.width.toInt() == 896 * 3 ||
            // iPhone 12 pro
            ui.window.physicalSize.width.toInt() == 844 ||
            ui.window.physicalSize.width.toInt() == 844 * 2 ||
            ui.window.physicalSize.width.toInt() == 844 * 3 ||
            // Iphone 12 pro max
            ui.window.physicalSize.width.toInt() == 926 ||
            ui.window.physicalSize.width.toInt() == 926 * 2 ||
            ui.window.physicalSize.width.toInt() == 926 * 3)) {
      return true;
    } else {
      return false;
    }
  }

  static bool get isIOS {
    if (Platform.isIOS)
      return true;
    else
      return false;
  }
}
