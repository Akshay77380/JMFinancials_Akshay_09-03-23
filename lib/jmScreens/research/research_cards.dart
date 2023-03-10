import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markets/jmScreens/ScriptInfo/ScriptInfo.dart';
import 'package:markets/model/scrip_info_model.dart';
import 'package:markets/screens/scrip_details_screen.dart';
import 'package:markets/style/theme.dart';
import 'package:markets/util/CommonFunctions.dart';
import 'package:markets/util/Dataconstants.dart';
import 'package:markets/widget/watchlist_picker_card.dart';
import '../../model/jmModel/researchCalls.dart';
import '../../util/Utils.dart';
import '../orders/OrderPlacement/order_placement_screen.dart';

class ResearchCards {}

/* Research Trading Card */
class TradingCard extends StatefulWidget {
  final ResearchCallsDatum data;
  final bool isScripDetailResearch;

  TradingCard({this.data, this.isScripDetailResearch});

  @override
  State<TradingCard> createState() => _TradingCardState();
}

class _TradingCardState extends State<TradingCard> {
  bool showBottomLine;
  bool added;
  List<int> pos = [-1, -1, -1, -1];

  void seeIfAdded(ScripInfoModel scrip) async {
    bool added;
    List<int> pos = [-1, -1, -1, -1];
    for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
      pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
    }
    added = pos.any((element) => element > -1);
    if (!added) {
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) => WatchListPickerCard(scrip),
      );
      if (result != null && result['added'] == 1) {
        setState(() {
          added = true;
        });
        pos[result['watchListId']] = Dataconstants.marketWatchListeners[result['watchListId']].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
        CommonFunction.showSnackBar(
          context: context,
          text: 'Added ${scrip.name} to ${Dataconstants.marketWatchListeners[result['watchListId']].watchListName}',
          duration: const Duration(milliseconds: 1500),
        );
      } else if (result != null && result['added'] == 2) {
        CommonFunction.showSnackBar(
          context: context,
          text: 'Cannot add more than ${Dataconstants.maxWatchlistCount} scrips to Watchlist',
          color: Colors.red,
          duration: const Duration(milliseconds: 1500),
        );
      }
    } else {
      setState(() {
        added = false;
      });
      for (int i = 0; i < pos.length; i++) {
        if (pos[i] > -1) {
          CommonFunction.showSnackBar(
            context: context,
            text: 'Removed ${Dataconstants.marketWatchListeners[i].watchList[pos[i]].name} from ${Dataconstants.marketWatchListeners[i].watchListName}',
            color: Colors.black,
            duration: const Duration(milliseconds: 1500),
          );
          Dataconstants.marketWatchListeners[i].removeFromWatchListIndex(pos[i]);
        }
      }
      pos = [-1, -1, -1, -1];
    }
  }

  void navigateTrading({bool isBuy, ThemeData theme}) {
    showModalBottomSheet<void>(
      backgroundColor: theme.cardColor,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => OrderPlacementBottomSheet(segment: "Trading ${widget.data.calltype}", stockName: widget.data.header, isBuy: isBuy, currentModel: widget.data.model),
    );
  }

  @override
  void initState() {
    super.initState();
    // Dataconstants.iqsClient.sendLTPRequest(
    //   widget.data.model,
    //   true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    widget.data.profitPotential = 0.0;
    /* Check if call is closed to show grey card with remark */
    if (widget.data.status.toUpperCase() == 'CLOSED')
      showBottomLine = true;
    else
      showBottomLine = false;
    added = false;
    if (widget.data.model != null) {
      for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
        pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == widget.data.model.exch && element.exchCode == widget.data.model.exchCode);
      }
      added = pos.any((element) => element > -1);
      // //print('this scrip is already added $added');
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7)),
                color: showBottomLine ? theme.cardColor.withOpacity(0.2) : theme.cardColor,
              ),
              child: Column(
                children: [
                  // if (widget.isScripDetailResearch)
                  //   Align(
                  //     alignment: Alignment.topLeft,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(7),
                  //       ),
                  //       child: CustomPaint(
                  //         painter: Chevron(),
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 25),
                  //           child: Text(
                  //             "Trading",
                  //             style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                              backgroundColor: theme.cardColor,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) => DraggableScrollableSheet(
                                maxChildSize: 0.5,
                                initialChildSize: 0.45,
                                expand: false,
                                builder: (context, controller) => Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Center(
                                        child: FractionallySizedBox(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 7),
                                            height: 5,
                                            decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(5)),
                                          ),
                                          widthFactor: 0.25,
                                        ),
                                      ),
                                      Container(
                                          // height: 250,
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                            color: theme.cardColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            widget.data.model.desc,
                                                            style: TextStyle(fontSize: 12),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            widget.data.header,
                                                            style: TextStyle(fontSize: 10),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          // Text(
                                                          //   "${widget.data.header}",
                                                          // ),
                                                          // SizedBox(
                                                          //   height: 5,
                                                          // ),
                                                          RichText(
                                                              text: TextSpan(children: [
                                                            TextSpan(text: "Stock Code :", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                            TextSpan(text: " ${widget.data.model.exchName.toString()}", style: TextStyle(fontSize: 10, color: Colors.grey))
                                                          ]))
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        children: [
                                                          Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
                                                            // SizedBox(
                                                            //   width: 65,
                                                            // ),
                                                            Observer(
                                                              builder: (_) => Text(
                                                                '₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(2) : widget.data.model.prevDayClose.toStringAsFixed(2) : widget.data.model.close.toStringAsFixed(2)} ',
                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color),
                                                              ),
                                                            ),
                                                            Observer(
                                                              builder: (_) => Text(
                                                                widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: widget.data.model.percentChange > 0
                                                                      ? Utils.brightGreenColor
                                                                      : widget.data.model.percentChange < 0
                                                                          ? Utils.brightRedColor
                                                                          : theme.textTheme.bodyText1.color,
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Align(
                                                            alignment: Alignment.centerRight,
                                                            child: RichText(
                                                              textAlign: TextAlign.center,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(text: '${widget.data.insertiontime}', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                                  TextSpan(text: widget.data.calltype, style: TextStyle(color: Colors.blue, fontSize: 10)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  child: Text(
                                                    widget.data.internalremark,
                                                    maxLines: 5,
                                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Target Price",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(text: '₹ ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                              TextSpan(text: '${double.parse(widget.data.targetprice)}', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Profit Potential",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Observer(builder: (_) {
                                                          double profitPotential;
                                                          widget.data.model.close == 0.00
                                                              ? widget.data.model.prevDayClose == 0.00
                                                                  ? widget.data.buysell.toUpperCase() == "BUY"
                                                                      ? profitPotential =
                                                                          ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) / double.parse(widget.data.price)) * 100
                                                                      : profitPotential =
                                                                          ((double.parse(widget.data.price) - double.parse(widget.data.targetprice)) / double.parse(widget.data.price)) * 100
                                                                  : widget.data.buysell.toUpperCase() == "BUY"
                                                                      ? profitPotential =
                                                                          ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) / widget.data.model.prevDayClose) * 100
                                                                      : profitPotential =
                                                                          ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) / widget.data.model.prevDayClose) * 100
                                                              : widget.data.buysell.toUpperCase() == "BUY"
                                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.close) / widget.data.model.close) * 100
                                                                  : profitPotential = ((widget.data.model.close - double.parse(widget.data.targetprice)) / widget.data.model.close) * 100;
                                                          widget.data.profitPotential = profitPotential;
                                                          return Text('${profitPotential.toStringAsFixed(2)}%', style: TextStyle(color: theme.textTheme.bodyText1.color));
                                                        }),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Time Period",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text(widget.data.validity),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Stop Loss",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text("₹ ${double.parse(widget.data.stoploss)}"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Entry Price",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(text: '\u{20B9} ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                              TextSpan(text: "${double.parse(widget.data.price)}", style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Status",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        Text(widget.data.status),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Call Type",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text("${widget.data.calltype}"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                ),
                                                // if (widget.data.callType == 'MMNT')
                                                //   SizedBox(
                                                //     height: 5,
                                                //   ),
                                                // if (widget.data.callType == 'MMNT')
                                                //   Align(
                                                //     alignment: Alignment.centerLeft,
                                                //     child: InkWell(
                                                //       onTap: () {
                                                //         //TODO : Report download
                                                //         // CommonFunction.launchURL("https://www.icicidirect.com/mailimages/Momentum_Picks.pdf");
                                                //       },
                                                //       child: Row(
                                                //         mainAxisSize: MainAxisSize.max,
                                                //         mainAxisAlignment: MainAxisAlignment.center,
                                                //         children: [
                                                //           IconButton(
                                                //             icon: SvgPicture.asset(
                                                //               "assets/images/research/pdf.svg",
                                                //               height: 15,
                                                //             ),
                                                //             iconSize: 20,
                                                //             onPressed: () {},
                                                //           ),
                                                //           Text(
                                                //             // "Download PDF",
                                                //             "Download Report",
                                                //             style: TextStyle(
                                                //               color: Color(0xFFD75B1F),
                                                //             ),
                                                //           )
                                                //         ],
                                                //       ),
                                                //     ),
                                                //   ),
                                              ],
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: ButtonTheme(
                                            minWidth: 280.0,
                                            height: 30.0,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                navigateTrading(isBuy: widget.data.buysell.toUpperCase() == "BUY" ? true : false, theme: theme);
                                              },
                                              child: Text(widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell", style: TextStyle(color: Colors.white)),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.data.model.desc,
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            widget.data.header,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          // Text(
                                          //   widget.data.header,
                                          //   style: TextStyle(fontWeight: FontWeight.w500),
                                          // ),
                                          // SizedBox(
                                          //   height: 3,
                                          // ),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(text: widget.data.insertiontime, style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                TextSpan(text: " | ", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                                TextSpan(text: widget.data.calltype.toString(), style: TextStyle(color: Color(0xff03A9F5), fontSize: 10)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Observer(
                                        builder: (_) => Text(
                                          "₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(2) : widget.data.model.prevDayClose.toStringAsFixed(2) : widget.data.model.close.toStringAsFixed(2)}",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Observer(
                                        builder: (_) => Text(
                                          widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: widget.data.model.percentChange > 0
                                                ? Utils.brightGreenColor
                                                : widget.data.model.percentChange < 0
                                                    ? Utils.brightRedColor
                                                    : theme.textTheme.bodyText1.color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration:
                                        BoxDecoration(color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.white : Color(0xff2E4052), borderRadius: BorderRadius.all(Radius.circular(4))),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Profit Potential",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                          ),
                                        ),
                                        SizedBox(height: 1),
                                        Observer(builder: (_) {
                                          double profitPotential;
                                          widget.data.model.close == 0.00
                                              ? widget.data.model.prevDayClose == 0.00
                                                  ? widget.data.buysell.toUpperCase() == "BUY"
                                                      ? profitPotential = ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) / double.parse(widget.data.price)) * 100
                                                      : profitPotential = ((double.parse(widget.data.price) - double.parse(widget.data.targetprice)) / double.parse(widget.data.price)) * 100
                                                  : widget.data.buysell.toUpperCase() == "BUY"
                                                      ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) / widget.data.model.prevDayClose) * 100
                                                      : profitPotential = ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) / widget.data.model.prevDayClose) * 100
                                              : widget.data.buysell.toUpperCase() == "BUY"
                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.close) / widget.data.model.close) * 100
                                                  : profitPotential = ((widget.data.model.close - double.parse(widget.data.targetprice)) / widget.data.model.close) * 100;
                                          widget.data.profitPotential = profitPotential;
                                          return Text('${profitPotential.toStringAsFixed(2)}%',
                                              style: theme.textTheme.bodyText1.copyWith(
                                                fontSize: 16,
                                                color: profitPotential > 0 ? Utils.brightGreenColor : Utils.brightRedColor,
                                              ));
                                        }),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Target Price",
                                        style: TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                      SizedBox(height: 2),
                                      Text('₹ ${double.parse(widget.data.targetprice).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Stop Loss",
                                        style: TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                      SizedBox(height: 2),
                                      Text("₹ ${double.parse(widget.data.stoploss).toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // InkWell(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(50)),
                              //   child: SvgPicture.asset(
                              //     ThemeConstants.themeMode.value ==
                              //             ThemeMode.light
                              //         ? "assets/images/research/share_light.svg"
                              //         : "assets/images/research/share.svg",
                              //     // height: 15,
                              //   ),
                              //   onTap: () {
                              //     Share.share(
                              //         'Hey check out this Research Idea from ICICIdirect https://google.com');
                              //   },
                              // ),
                              // SizedBox(
                              //   width: 20,
                              // ),
                              // InkWell(
                              //   borderRadius: BorderRadius.all(Radius.circular(50)),
                              //   child: Icon(
                              //     added ? Icons.bookmark : Icons.bookmark_border_outlined,
                              //     color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff7B7B7B) : Color(0xffF1F1F1),
                              //     size: 22,
                              //   ),
                              //   onTap: () => seeIfAdded(widget.data.model),
                              // ),
                              Spacer(),
                              MaterialButton(
                                height: 26,
                                minWidth: 65,
                                color: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                onPressed: () {
                                  navigateTrading(isBuy: widget.data.buysell.toUpperCase() == "BUY" ? true : false, theme: theme);
                                },
                                child: Text(
                                  widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell",
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showBottomLine)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: showBottomLine ? 0 : 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7)),
                    color: showBottomLine ? theme.cardColor.withOpacity(0.6) : theme.cardColor,
                  ),
                ),
              ),
          ],
        ),
        if (showBottomLine)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)),
              color: theme.cardColor,
            ),
            child: Text(
              widget.data.statusdescreption,
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

/* Research Investment Card */
class InvestmentCard extends StatefulWidget {
  final ResearchCallsDatum data;
  final bool isScripDetailResearch;

  InvestmentCard({this.data, this.isScripDetailResearch});

  @override
  State<InvestmentCard> createState() => _InvestmentCardState();
}

class _InvestmentCardState extends State<InvestmentCard> {
  bool showBottomLine;
  bool added;

  // double targetAchieved;
  List<int> pos = [-1, -1, -1, -1];

  void seeIfAdded(ScripInfoModel scrip) async {
    bool added;
    List<int> pos = [-1, -1, -1, -1];
    for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
      pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
    }
    added = pos.any((element) => element > -1);
    if (!added) {
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) => WatchListPickerCard(scrip),
      );
      if (result != null && result['added'] == 1) {
        setState(() {
          added = true;
        });
        pos[result['watchListId']] = Dataconstants.marketWatchListeners[result['watchListId']].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
        CommonFunction.showSnackBar(
          context: context,
          text: 'Added ${scrip.name} to ${Dataconstants.marketWatchListeners[result['watchListId']].watchListName}',
          duration: const Duration(milliseconds: 1500),
        );
      } else if (result != null && result['added'] == 2) {
        CommonFunction.showSnackBar(
          context: context,
          text: 'Cannot add more than ${Dataconstants.maxWatchlistCount} scrips to Watchlist',
          color: Colors.red,
          duration: const Duration(milliseconds: 1500),
        );
      }
    } else {
      setState(() {
        added = false;
      });
      for (int i = 0; i < pos.length; i++) {
        if (pos[i] > -1) {
          CommonFunction.showSnackBar(
            context: context,
            text: 'Removed ${Dataconstants.marketWatchListeners[i].watchList[pos[i]].name} from ${Dataconstants.marketWatchListeners[i].watchListName}',
            color: Colors.black,
            duration: const Duration(milliseconds: 1500),
          );
          Dataconstants.marketWatchListeners[i].removeFromWatchListIndex(pos[i]);
        }
      }
      pos = [-1, -1, -1, -1];
    }
  }

  void navigateInvest({bool isBuy, ThemeData theme}) {
    showModalBottomSheet<void>(
      backgroundColor: theme.cardColor,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => OrderPlacementBottomSheet(segment: "Investment", stockName: widget.data.header, isBuy: isBuy, currentModel: widget.data.model),
    );
  }

  @override
  void initState() {
    super.initState();
    // Dataconstants.iqsClient.sendLTPRequest(
    //   widget.data.model,
    //   true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    if (widget.data.status.toUpperCase() == 'CLOSED')
      showBottomLine = true;
    else
      showBottomLine = false;
    widget.data.profitPotential = 0.0;
    added = false;
    if (widget.data.model != null) {
      for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
        pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == widget.data.model.exch && element.exchCode == widget.data.model.exchCode);
      }
      added = pos.any((element) => element > -1);
      // //print('this scrip is already added $added');
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7)),
                color: showBottomLine ? theme.cardColor.withOpacity(0.2) : theme.cardColor,
              ),
              child: Column(
                children: [
                  // if (widget.isScripDetailResearch)
                  //   Align(
                  //     alignment: Alignment.topLeft,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(7),
                  //       ),
                  //       child: CustomPaint(
                  //         painter: Chevron(),
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 25),
                  //           child: Text(
                  //             "Investment",
                  //             style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet<void>(
                              backgroundColor: theme.cardColor,
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) => DraggableScrollableSheet(
                                maxChildSize: 0.5,
                                initialChildSize: 0.45,
                                expand: false,
                                builder: (context, controller) => Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Center(
                                        child: FractionallySizedBox(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(vertical: 7),
                                            height: 5,
                                            decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(5)),
                                          ),
                                          widthFactor: 0.25,
                                        ),
                                      ),
                                      Container(
                                          // height: 250,
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                            color: theme.cardColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisSize: MainAxisSize.max,
                                                        children: [
                                                          Text(
                                                            widget.data.model.desc,
                                                            style: TextStyle(fontSize: 12),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            widget.data.header,
                                                            style: TextStyle(fontSize: 10),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          // Text(
                                                          //   "${widget.data.header}",
                                                          // ),
                                                          // SizedBox(
                                                          //   height: 5,
                                                          // ),
                                                          RichText(
                                                              text: TextSpan(children: [
                                                            TextSpan(text: "Stock Code :", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                            TextSpan(text: " ${widget.data.model.exchName}", style: TextStyle(fontSize: 10, color: Colors.grey))
                                                          ]))
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Column(
                                                        children: [
                                                          Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
                                                            // SizedBox(
                                                            //   width: 65,
                                                            // ),
                                                            Observer(
                                                              builder: (_) => Text(
                                                                '₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(2) : widget.data.model.prevDayClose.toStringAsFixed(2) : widget.data.model.close.toStringAsFixed(2)} ',
                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color),
                                                              ),
                                                            ),
                                                            Observer(
                                                              builder: (_) => Text(
                                                                widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: widget.data.model.percentChange > 0
                                                                      ? Utils.brightGreenColor
                                                                      : widget.data.model.percentChange < 0
                                                                          ? Utils.brightRedColor
                                                                          : theme.textTheme.bodyText1.color,
                                                                ),
                                                              ),
                                                            ),
                                                          ]),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Align(
                                                            alignment: Alignment.centerRight,
                                                            child: RichText(
                                                              textAlign: TextAlign.center,
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(text: '${widget.data.insertiontime} ', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                                  TextSpan(text: "${widget.data.calltype}", style: TextStyle(color: Colors.blue, fontSize: 10)),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  child: Text(
                                                    widget.data.internalremark,
                                                    maxLines: 5,
                                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Target Price",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(text: '₹ ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                              TextSpan(text: '${widget.data.targetprice}', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Profit Potential",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Observer(builder: (_) {
                                                          double profitPotential;
                                                          widget.data.model.close == 0.00
                                                              ? widget.data.model.prevDayClose == 0.00
                                                                  ? widget.data.buysell.toUpperCase() == "BUY"
                                                                      ? profitPotential =
                                                                          ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) / double.parse(widget.data.price)) * 100
                                                                      : profitPotential = ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) / widget.data.model.prevDayClose) * 100
                                                                  : widget.data.buysell.toUpperCase() == "BUY"
                                                                      ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) / widget.data.model.prevDayClose) * 100
                                                                      : profitPotential = ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) / widget.data.model.prevDayClose) * 100
                                                              : widget.data.buysell.toUpperCase() == "BUY"
                                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.close) / widget.data.model.close) * 100
                                                                  : profitPotential = ((widget.data.model.close - double.parse(widget.data.targetprice)) / widget.data.model.close) * 100;
                                                          widget.data.profitPotential = profitPotential;
                                                          return Text('${profitPotential.toStringAsFixed(2)} %', style: TextStyle(color: theme.textTheme.bodyText1.color));
                                                        }),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Time Period",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text("${widget.data.validity}"),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Stop Loss",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text(widget.data.stoploss),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Entry Price",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(text: '\u{20B9} ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                              TextSpan(text: "${widget.data.price}", style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Status",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        Text(widget.data.status),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "Call Type",
                                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text("${widget.data.calltype}"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: InkWell(
                                                    onTap: () {
                                                      //TODO : Report download
                                                      // CommonFunction.launchURL("${widget.data.link1}");
                                                    },
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        IconButton(
                                                          icon: SvgPicture.asset(
                                                            "assets/images/research/pdf.svg",
                                                            height: 15,
                                                          ),
                                                          iconSize: 20,
                                                          onPressed: () {},
                                                        ),
                                                        Text(
                                                          // "Download PDF",
                                                          "Download Report",
                                                          style: TextStyle(
                                                            color: Color(0xFFD75B1F),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      Align(
                                          alignment: Alignment.bottomCenter,
                                          child: ButtonTheme(
                                            minWidth: 280.0,
                                            height: 30.0,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                                backgroundColor: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                navigateInvest(isBuy: widget.data.buysell.toUpperCase() == "BUY" ? true : false, theme: theme);
                                              },
                                              child: Text(widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell", style: TextStyle(color: Colors.white)),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.data.model.desc,
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            widget.data.header,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          // Text(
                                          //   widget.data.header,
                                          //   style: TextStyle(fontWeight: FontWeight.w500),
                                          // ),
                                          // SizedBox(
                                          //   height: 3,
                                          // ),
                                          RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(text: widget.data.insertiontime, style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                TextSpan(text: " | ", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                                TextSpan(text: widget.data.calltype, style: TextStyle(color: Color(0xff03A9F5), fontSize: 10)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Observer(
                                        builder: (_) => Text(
                                          "₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(2) : widget.data.model.prevDayClose.toStringAsFixed(2) : widget.data.model.close.toStringAsFixed(2)}",
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Observer(
                                        builder: (_) => Text(
                                          widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: widget.data.model.percentChange > 0
                                                ? Utils.brightGreenColor
                                                : widget.data.model.percentChange < 0
                                                    ? Utils.brightRedColor
                                                    : theme.textTheme.bodyText1.color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration:
                                        BoxDecoration(color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.white : Color(0xff2E4052), borderRadius: BorderRadius.all(Radius.circular(4))),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Profit Potential",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 11,
                                          ),
                                        ),
                                        SizedBox(height: 1),
                                        Observer(builder: (_) {
                                          double profitPotential;
                                          widget.data.model.close == 0.00
                                              ? widget.data.model.prevDayClose == 0.00
                                                  ? widget.data.buysell.toUpperCase() == "BUY"
                                                      ? profitPotential = ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) / double.parse(widget.data.price)) * 100
                                                      : profitPotential = ((double.parse(widget.data.price) - double.parse(widget.data.targetprice)) / double.parse(widget.data.price)) * 100
                                                  : widget.data.buysell.toUpperCase() == "BUY"
                                                      ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) / widget.data.model.prevDayClose) * 100
                                                      : profitPotential = ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) / widget.data.model.prevDayClose) * 100
                                              : widget.data.buysell.toUpperCase() == "BUY"
                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.close) / widget.data.model.close) * 100
                                                  : profitPotential = ((widget.data.model.close - double.parse(widget.data.targetprice)) / widget.data.model.close) * 100;
                                          widget.data.profitPotential = profitPotential;
                                          return Text('${profitPotential.toStringAsFixed(2)}%',
                                              style: theme.textTheme.bodyText1.copyWith(
                                                fontSize: 16,
                                                color: profitPotential > 0 ? Utils.brightGreenColor : Utils.brightRedColor,
                                              ));
                                        }),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Target Price",
                                        style: TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                      SizedBox(height: 2),
                                      Text('₹ ${double.parse(widget.data.targetprice).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Stop Loss",
                                        style: TextStyle(color: Colors.grey, fontSize: 11),
                                      ),
                                      SizedBox(height: 2),
                                      Text(widget.data.stoploss, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.15,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Divider(
                                thickness: 1,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // InkWell(
                              //   borderRadius: BorderRadius.all(Radius.circular(50)),
                              //   child: SvgPicture.asset(
                              //     ThemeConstants.themeMode.value == ThemeMode.light
                              //         ? "assets/images/research/share_light.svg"
                              //         : "assets/images/research/share.svg",
                              //     // height: 15,
                              //   ),
                              //   onTap: () {
                              //     Share.share(
                              //         'Hey check out this Research Idea from ICICIdirect https://google.com');
                              //   },
                              // ),
                              // SizedBox(
                              //   width: 20,
                              // ),
                              // InkWell(
                              //   borderRadius: BorderRadius.all(Radius.circular(50)),
                              //   child: Icon(
                              //     added ? Icons.bookmark : Icons.bookmark_border_outlined,
                              //     color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff7B7B7B) : Color(0xffF1F1F1),
                              //     size: 22,
                              //   ),
                              //   onTap: () => seeIfAdded(currentModel),
                              // ),
                              Spacer(),
                              MaterialButton(
                                height: 26,
                                minWidth: 65,
                                color: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                onPressed: () {
                                  navigateInvest(isBuy: widget.data.buysell.toUpperCase() == "BUY" ? true : false, theme: theme);
                                },
                                child: Text(
                                  widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell",
                                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (showBottomLine)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: showBottomLine ? 0 : 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7)),
                    color: showBottomLine ? theme.cardColor.withOpacity(0.6) : theme.cardColor,
                  ),
                ),
              ),
          ],
        ),
        if (showBottomLine)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)),
              color: theme.cardColor,
            ),
            child: Text(
              widget.data.statusdescreption,
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

/* Research FNO Card */
class FutureOptionsCard extends StatefulWidget {
  final ResearchCallsDatum data;
  final bool isScripDetailResearch;

  FutureOptionsCard({this.data, this.isScripDetailResearch});

  @override
  State<FutureOptionsCard> createState() => _FutureOptionsCardState();
}

class _FutureOptionsCardState extends State<FutureOptionsCard> {
  bool showBottomLine;
  bool added;
  List<int> pos = [-1, -1, -1, -1];
  String optionType, productType;

  void seeIfAdded(ScripInfoModel scrip) async {
    bool added;
    List<int> pos = [-1, -1, -1, -1];
    for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
      pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
    }
    added = pos.any((element) => element > -1);
    if (!added) {
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) => WatchListPickerCard(scrip),
      );
      if (result != null && result['added'] == 1) {
        setState(() {
          added = true;
        });
        pos[result['watchListId']] = Dataconstants.marketWatchListeners[result['watchListId']].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
        CommonFunction.showSnackBar(
          context: context,
          text: 'Added ${scrip.name} to ${Dataconstants.marketWatchListeners[result['watchListId']].watchListName}',
          duration: const Duration(milliseconds: 1500),
        );
      } else if (result != null && result['added'] == 2) {
        CommonFunction.showSnackBar(
          context: context,
          text: 'Cannot add more than ${Dataconstants.maxWatchlistCount} scrips to Watchlist',
          color: Colors.red,
          duration: const Duration(milliseconds: 1500),
        );
      }
    } else {
      setState(() {
        added = false;
      });
      for (int i = 0; i < pos.length; i++) {
        if (pos[i] > -1) {
          CommonFunction.showSnackBar(
            context: context,
            text: 'Removed ${Dataconstants.marketWatchListeners[i].watchList[pos[i]].name} from ${Dataconstants.marketWatchListeners[i].watchListName}',
            color: Colors.black,
            duration: const Duration(milliseconds: 1500),
          );
          Dataconstants.marketWatchListeners[i].removeFromWatchListIndex(pos[i]);
        }
      }
      pos = [-1, -1, -1, -1];
    }
  }

  void navigateFnO() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return OrderPlacementScreen(
            model: widget.data.model,
            orderType: ScripDetailType.none,
            isBuy: widget.data.buysell.toUpperCase() == "BUY" ? true : false,
            selectedExch: widget.data.model.exch,
            stream: Dataconstants.pageController.stream,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Dataconstants.iqsClient.sendLTPRequest(
    //   widget.data.model,
    //   true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    widget.data.profitPotential = 0.0;
    if (widget.data.status.toUpperCase() == 'CLOSED')
      showBottomLine = true;
    else
      showBottomLine = false;
    added = false;
    if (widget.data.model != null) {
      for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
        pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == widget.data.model.exch && element.exchCode == widget.data.model.exchCode);
      }
      added = pos.any((element) => element > -1);
      // //print('this scrip is already added $added');
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7)),
                color: showBottomLine ? theme.cardColor.withOpacity(0.2) : theme.cardColor,
              ),
              child: Column(
                children: [
                  // if (widget.isScripDetailResearch)
                  //   Align(
                  //     alignment: Alignment.topLeft,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(7),
                  //       ),
                  //       child: CustomPaint(
                  //         painter: Chevron(),
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 25),
                  //           child: Text(
                  //             "Future & Options",
                  //             style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          backgroundColor: theme.cardColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) => DraggableScrollableSheet(
                            maxChildSize: 0.6,
                            initialChildSize: 0.5,
                            expand: false,
                            builder: (context, controller) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Center(
                                    child: FractionallySizedBox(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 7),
                                        height: 5,
                                        decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(5)),
                                      ),
                                      widthFactor: 0.25,
                                    ),
                                  ),
                                  Container(
                                      // height: 250,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        widget.data.model.desc,
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        widget.data.header,
                                                        style: TextStyle(fontSize: 10),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      // Text(
                                                      //   "${widget.data.header}",
                                                      // ),
                                                      // SizedBox(
                                                      //   height: 5,
                                                      // ),
                                                      RichText(
                                                          text: TextSpan(children: [
                                                        TextSpan(text: "Stock Code :", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                        TextSpan(text: " ${widget.data.model.desc.toString()}", style: TextStyle(fontSize: 10, color: Colors.grey))
                                                      ]))
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    children: [
                                                      Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
                                                        // SizedBox(
                                                        //   width: 65,
                                                        // ),
                                                        Observer(
                                                          builder: (_) => Text(
                                                            '₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(2) : widget.data.model.prevDayClose.toStringAsFixed(2) : widget.data.model.close.toStringAsFixed(2)} ',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color),
                                                          ),
                                                        ),
                                                        Observer(
                                                          builder: (_) => Text(
                                                            widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: widget.data.model.percentChange > 0
                                                                  ? Utils.brightGreenColor
                                                                  : widget.data.model.percentChange < 0
                                                                      ? Utils.brightRedColor
                                                                      : theme.textTheme.bodyText1.color,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(text: '${widget.data.insertiontime}', style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                              TextSpan(text: widget.data.calltype, style: TextStyle(color: Colors.blue, fontSize: 10)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Text(
                                                widget.data.internalremark,
                                                maxLines: 5,
                                                style: TextStyle(fontSize: 10, color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Target Price",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(text: '₹ ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                          TextSpan(text: '${double.parse(widget.data.targetprice)}', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Profit Potential",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Observer(builder: (_) {
                                                      double profitPotential;
                                                      widget.data.model.close == 0.00
                                                          ? widget.data.model.prevDayClose == 0.00
                                                              ? widget.data.buysell.toUpperCase() == "BUY"
                                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) * widget.data.model.minimumLotQty)
                                                                  : profitPotential = ((double.parse(widget.data.price) - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty)
                                                              : widget.data.buysell.toUpperCase() == "BUY"
                                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) * widget.data.model.minimumLotQty)
                                                                  : profitPotential = ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty)
                                                          : widget.data.buysell.toUpperCase() == "BUY"
                                                              ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.close) * widget.data.model.minimumLotQty)
                                                              : profitPotential = ((widget.data.model.close - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty);
                                                      widget.data.profitPotential = profitPotential;
                                                      return Text('₹ ${profitPotential.toStringAsFixed(0)}', style: TextStyle(color: theme.textTheme.bodyText1.color));
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Time Period",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text(widget.data.validity),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Stop Loss",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text("₹ ${double.parse(widget.data.stoploss)}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Entry Price",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(text: '\u{20B9} ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                          TextSpan(text: '${double.parse(widget.data.price)}', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Status",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    Text(widget.data.status),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Call Type",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text(widget.data.calltype),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                // if (widget.data.callType == "FUT")
                                                //   Column(
                                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                                //     children: [
                                                //       Text(
                                                //         "Margin Rqd",
                                                //         style: TextStyle(color: Colors.grey, fontSize: 12),
                                                //       ),
                                                //       SizedBox(height: 1),
                                                //       RichText(
                                                //         text: TextSpan(
                                                //           children: [
                                                //             TextSpan(text: '₹ ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                //             TextSpan(
                                                //                 text: widget.data.callType == 'FUT' ? CommonFunction.currencyFormat(snapshot.data['Normal']) : '0.0',
                                                //                 style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                //           ],
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // if (widget.data.callType == "FUT")
                                                //   SizedBox(
                                                //     width: 10,
                                                //   ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "View",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    Text("NA"),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Lot Size",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text("${widget.data.model.minimumLotQty}")
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      )),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ButtonTheme(
                                        minWidth: 280.0,
                                        height: 30.0,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            navigateFnO();
                                          },
                                          child: Text(widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell", style: TextStyle(color: Colors.white)),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.data.model.desc,
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        widget.data.header,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      // Text(
                                      //   widget.data.header,
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // SizedBox(
                                      //   height: 3,
                                      // ),
                                      // Text(
                                      //   widget.data.model.desc,
                                      //   style: TextStyle(fontSize: 10, color: Colors.grey),
                                      // ),
                                      // SizedBox(
                                      //   height: 3,
                                      // ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: widget.data.insertiontime, style: TextStyle(fontSize: 10, color: Colors.grey)),
                                            TextSpan(text: " | ", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                            TextSpan(text: widget.data.calltype.toString(), style: TextStyle(color: Color(0xff03A9F5), fontSize: 10)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Observer(
                                    builder: (_) => Text(
                                      "₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(2) : widget.data.model.prevDayClose.toStringAsFixed(2) : widget.data.model.close.toStringAsFixed(2)}",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Observer(
                                    builder: (_) => Text(
                                      widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: widget.data.model.percentChange > 0
                                            ? Utils.brightGreenColor
                                            : widget.data.model.percentChange < 0
                                                ? Utils.brightRedColor
                                                : theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration:
                                    BoxDecoration(color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.white : Color(0xff2E4052), borderRadius: BorderRadius.all(Radius.circular(4))),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Profit Potential",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Observer(builder: (_) {
                                      double profitPotential;
                                      widget.data.model.close == 0.00
                                          ? widget.data.model.prevDayClose == 0.00
                                              ? widget.data.buysell.toUpperCase() == "BUY"
                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) * widget.data.model.minimumLotQty)
                                                  : profitPotential = ((double.parse(widget.data.price) - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty)
                                              : widget.data.buysell.toUpperCase() == "BUY"
                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) * widget.data.model.minimumLotQty)
                                                  : profitPotential = ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty)
                                          : widget.data.buysell.toUpperCase() == "BUY"
                                              ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.close) * widget.data.model.minimumLotQty)
                                              : profitPotential = ((widget.data.model.close - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty);
                                      widget.data.profitPotential = profitPotential;
                                      return Text('₹ ${profitPotential.toStringAsFixed(0)}',
                                          style: theme.textTheme.bodyText1.copyWith(
                                            fontSize: 16,
                                            color: profitPotential > 0 ? Utils.brightGreenColor : Utils.brightRedColor,
                                          ));
                                    }),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Target Price",
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                  SizedBox(height: 2),
                                  Text('₹ ${double.parse(widget.data.targetprice).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stop Loss",
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                  SizedBox(height: 2),
                                  Text("₹ ${double.parse(widget.data.stoploss).toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // InkWell(
                                //   borderRadius:
                                //       BorderRadius.all(Radius.circular(50)),
                                //   child: SvgPicture.asset(
                                //     ThemeConstants.themeMode.value ==
                                //             ThemeMode.light
                                //         ? "assets/images/research/share_light.svg"
                                //         : "assets/images/research/share.svg",
                                //     // height: 15,
                                //   ),
                                //   onTap: () {
                                //     Share.share(
                                //         'Hey check out this Research Idea from ICICIdirect https://google.com');
                                //   },
                                // ),
                                // SizedBox(
                                //   width: 20,
                                // ),
                                // InkWell(
                                //   borderRadius: BorderRadius.all(Radius.circular(50)),
                                //   child: Icon(
                                //     added ? Icons.bookmark : Icons.bookmark_border_outlined,
                                //     color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff7B7B7B) : Color(0xffF1F1F1),
                                //     size: 22,
                                //   ),
                                //   onTap: () => seeIfAdded(widget.data.model),
                                // ),
                                Spacer(),
                                MaterialButton(
                                  height: 26,
                                  minWidth: 65,
                                  color: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                  onPressed: () {
                                    navigateFnO();
                                  },
                                  child: Text(
                                    widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell",
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showBottomLine)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: showBottomLine ? 0 : 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7)),
                    color: showBottomLine ? theme.cardColor.withOpacity(0.6) : theme.cardColor,
                  ),
                ),
              ),
          ],
        ),
        if (showBottomLine)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)),
              color: theme.cardColor,
            ),
            child: Text(
              widget.data.statusdescreption,
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

/* Research Currency Card */
class CurrencyCard extends StatefulWidget {
  final ResearchCallsDatum data;
  final bool isScripDetailResearch;

  CurrencyCard({this.data, this.isScripDetailResearch});

  @override
  State<CurrencyCard> createState() => _CurrencyCardState();
}

class _CurrencyCardState extends State<CurrencyCard> {
  bool showBottomLine;
  bool added;
  List<int> pos = [-1, -1, -1, -1];

  void seeIfAdded(ScripInfoModel scrip) async {
    bool added;
    List<int> pos = [-1, -1, -1, -1];
    for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
      pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
    }
    added = pos.any((element) => element > -1);
    if (!added) {
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) => WatchListPickerCard(scrip),
      );
      if (result != null && result['added'] == 1) {
        setState(() {
          added = true;
        });
        pos[result['watchListId']] = Dataconstants.marketWatchListeners[result['watchListId']].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
        CommonFunction.showSnackBar(
          context: context,
          text: 'Added ${scrip.name} to ${Dataconstants.marketWatchListeners[result['watchListId']].watchListName}',
          duration: const Duration(milliseconds: 1500),
        );
      } else if (result != null && result['added'] == 2) {
        CommonFunction.showSnackBar(
          context: context,
          text: 'Cannot add more than ${Dataconstants.maxWatchlistCount} scrips to Watchlist',
          color: Colors.red,
          duration: const Duration(milliseconds: 1500),
        );
      }
    } else {
      setState(() {
        added = false;
      });
      for (int i = 0; i < pos.length; i++) {
        if (pos[i] > -1) {
          CommonFunction.showSnackBar(
            context: context,
            text: 'Removed ${Dataconstants.marketWatchListeners[i].watchList[pos[i]].name} from ${Dataconstants.marketWatchListeners[i].watchListName}',
            color: Colors.black,
            duration: const Duration(milliseconds: 1500),
          );
          Dataconstants.marketWatchListeners[i].removeFromWatchListIndex(pos[i]);
        }
      }
      pos = [-1, -1, -1, -1];
    }
  }

  void navigateCurr() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return OrderPlacementScreen(
            model: widget.data.model,
            orderType: ScripDetailType.none,
            isBuy: widget.data.buysell.toUpperCase() == "BUY" ? true : false,
            selectedExch: widget.data.model.exch,
            stream: Dataconstants.pageController.stream,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Dataconstants.iqsClient.sendLTPRequest(
    //   widget.data.model,
    //   true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    widget.data.profitPotential = 0.0;
    if (widget.data.status.toUpperCase() == 'CLOSED')
      showBottomLine = true;
    else
      showBottomLine = false;
    added = false;
    if (widget.data.model != null) {
      for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
        pos[i] = Dataconstants.marketWatchListeners[i].watchList
            .indexWhere((element) => element.exch == widget.data.model.exch && element.exchCode == widget.data.model.exchCode);
      }
      added = pos.any((element) => element > -1);
      // //print('this scrip is already added $added');
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7)),
                color: showBottomLine ? theme.cardColor.withOpacity(0.2) : theme.cardColor,
              ),
              child: Column(
                children: [
                  // if (widget.isScripDetailResearch)
                  //   Align(
                  //     alignment: Alignment.topLeft,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(7),
                  //       ),
                  //       child: CustomPaint(
                  //         painter: Chevron(),
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 25),
                  //           child: Text(
                  //             "Future & Options",
                  //             style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          backgroundColor: theme.cardColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) => DraggableScrollableSheet(
                            maxChildSize: 0.6,
                            initialChildSize: 0.45,
                            expand: false,
                            builder: (context, controller) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Center(
                                    child: FractionallySizedBox(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 7),
                                        height: 5,
                                        decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(5)),
                                      ),
                                      widthFactor: 0.25,
                                    ),
                                  ),
                                  Container(
                                    // height: 250,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        widget.data.model.desc,
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        widget.data.header,
                                                        style: TextStyle(fontSize: 10),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      // Text(
                                                      //   "${widget.data.header}",
                                                      // ),
                                                      // SizedBox(
                                                      //   height: 5,
                                                      // ),
                                                      RichText(
                                                          text: TextSpan(children: [
                                                            TextSpan(text: "Stock Code :", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                            TextSpan(text: " ${widget.data.model.desc.toString()}", style: TextStyle(fontSize: 10, color: Colors.grey))
                                                          ]))
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    children: [
                                                      Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
                                                        // SizedBox(
                                                        //   width: 65,
                                                        // ),
                                                        Observer(
                                                          builder: (_) => Text(
                                                            '₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(4) : widget.data.model.prevDayClose.toStringAsFixed(4) : widget.data.model.close.toStringAsFixed(4)} ',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color),
                                                          ),
                                                        ),
                                                        Observer(
                                                          builder: (_) => Text(
                                                            widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: widget.data.model.percentChange > 0
                                                                  ? Utils.brightGreenColor
                                                                  : widget.data.model.percentChange < 0
                                                                  ? Utils.brightRedColor
                                                                  : theme.textTheme.bodyText1.color,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text: '${widget.data.insertiontime}',
                                                                  style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                              TextSpan(text: widget.data.calltype, style: TextStyle(color: Colors.blue, fontSize: 10)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Text(
                                                widget.data.internalremark,
                                                maxLines: 5,
                                                style: TextStyle(fontSize: 10, color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Target Price",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(text: '₹ ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                          TextSpan(
                                                              text: '${double.parse(widget.data.targetprice)}',
                                                              style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Profit Potential",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Observer(builder: (_) {
                                                      double profitPotential;
                                                      widget.data.model.close == 0.00
                                                          ? widget.data.model.prevDayClose == 0.00
                                                          ? widget.data.buysell.toUpperCase() == "BUY"
                                                          ? profitPotential = ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) *
                                                          widget.data.model.minimumLotQty *
                                                          1000)
                                                          : profitPotential = ((double.parse(widget.data.price) - double.parse(widget.data.targetprice)) *
                                                          widget.data.model.minimumLotQty *
                                                          1000)
                                                          : widget.data.buysell.toUpperCase() == "BUY"
                                                          ? profitPotential =
                                                      ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) * widget.data.model.minimumLotQty * 1000)
                                                          : profitPotential =
                                                      ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty * 1000)
                                                          : widget.data.buysell.toUpperCase() == "BUY"
                                                          ? profitPotential =
                                                      ((double.parse(widget.data.targetprice) - widget.data.model.close) * widget.data.model.minimumLotQty * 1000)
                                                          : profitPotential =
                                                      ((widget.data.model.close - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty * 1000);
                                                      widget.data.profitPotential = profitPotential;
                                                      return Text('₹ ${profitPotential.toStringAsFixed(0)}', style: TextStyle(color: theme.textTheme.bodyText1.color));
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Time Period",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text(widget.data.validity),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Stop Loss",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text("₹ ${double.parse(widget.data.stoploss)}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Entry Price",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(text: '\u{20B9} ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                          TextSpan(
                                                              text: '${double.parse(widget.data.price)}',
                                                              style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Status",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    Text(widget.data.status),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Call Type",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text("${widget.data.calltype}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                // Column(
                                                //   crossAxisAlignment:
                                                //       CrossAxisAlignment
                                                //           .start,
                                                //   children: [
                                                //     Text(
                                                //       "Margin Rqd",
                                                //       style: TextStyle(
                                                //           color: Colors
                                                //               .grey,
                                                //           fontSize: 12),
                                                //     ),
                                                //     SizedBox(height: 1),
                                                //     RichText(
                                                //       text: TextSpan(
                                                //         children: [
                                                //           TextSpan(
                                                //               text:
                                                //                   '₹ ',
                                                //               style: TextStyle(
                                                //                   color: theme
                                                //                       .textTheme
                                                //                       .bodyText1
                                                //                       .color)),
                                                //           TextSpan(
                                                //               text: CommonFunction.currencyFormat(
                                                //                   snapshot.data[
                                                //                       'Intraday']),
                                                //               style: TextStyle(
                                                //                   color: theme
                                                //                       .textTheme
                                                //                       .bodyText1
                                                //                       .color)),
                                                //         ],
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                // SizedBox(
                                                //   width: 10,
                                                // ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "View",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    Text("NA"),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Lot Size",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text("${widget.data.model.minimumLotQty * 1000}")
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      )),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ButtonTheme(
                                        minWidth: 280.0,
                                        height: 30.0,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            navigateCurr();
                                          },
                                          child: Text(widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell", style: TextStyle(color: Colors.white)),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.data.model.desc,
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        widget.data.header,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      // Text(
                                      //   widget.data.header,
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // SizedBox(
                                      //   height: 3,
                                      // ),
                                      // Text(
                                      //   widget.data.model.desc,
                                      //   style: TextStyle(fontSize: 10, color: Colors.grey),
                                      // ),
                                      // SizedBox(
                                      //   height: 3,
                                      // ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: widget.data.insertiontime, style: TextStyle(fontSize: 10, color: Colors.grey)),
                                            TextSpan(text: " | ", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                            TextSpan(text: widget.data.calltype.toString(), style: TextStyle(color: Color(0xff03A9F5), fontSize: 10)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Observer(
                                    builder: (_) => Text(
                                      "₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(4) : widget.data.model.prevDayClose.toStringAsFixed(4) : widget.data.model.close.toStringAsFixed(4)}",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Observer(
                                    builder: (_) => Text(
                                      widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: widget.data.model.percentChange > 0
                                            ? Utils.brightGreenColor
                                            : widget.data.model.percentChange < 0
                                                ? Utils.brightRedColor
                                                : theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration:
                                    BoxDecoration(color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.white : Color(0xff2E4052), borderRadius: BorderRadius.all(Radius.circular(4))),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Profit Potential",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Observer(builder: (_) {
                                      double profitPotential;
                                      widget.data.model.close == 0.00
                                          ? widget.data.model.prevDayClose == 0.00
                                              ? widget.data.buysell.toUpperCase() == "BUY"
                                                  ? profitPotential =
                                                      ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) * widget.data.model.minimumLotQty * 1000)
                                                  : profitPotential =
                                                      ((double.parse(widget.data.price) - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty * 1000)
                                              : widget.data.buysell.toUpperCase() == "BUY"
                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) * widget.data.model.minimumLotQty * 1000)
                                                  : profitPotential = ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty * 1000)
                                          : widget.data.buysell.toUpperCase() == "BUY"
                                              ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.close) * widget.data.model.minimumLotQty * 1000)
                                              : profitPotential = ((widget.data.model.close - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty * 1000);
                                      widget.data.profitPotential = profitPotential;
                                      return Text('₹ ${profitPotential.toStringAsFixed(0)}',
                                          style: theme.textTheme.bodyText1.copyWith(
                                            fontSize: 16,
                                            color: profitPotential > 0 ? Utils.brightGreenColor : Utils.brightRedColor,
                                          ));
                                    }),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Target Price",
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                  SizedBox(height: 2),
                                  Text('₹ ${double.parse(widget.data.targetprice).toStringAsFixed(4)}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stop Loss",
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                  SizedBox(height: 2),
                                  Text("₹ ${double.parse(widget.data.stoploss).toStringAsFixed(4)}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // InkWell(
                                //   borderRadius:
                                //       BorderRadius.all(Radius.circular(50)),
                                //   child: SvgPicture.asset(
                                //     ThemeConstants.themeMode.value ==
                                //             ThemeMode.light
                                //         ? "assets/images/research/share_light.svg"
                                //         : "assets/images/research/share.svg",
                                //     // height: 15,
                                //   ),
                                //   onTap: () {
                                //     Share.share(
                                //         'Hey check out this Research Idea from ICICIdirect https://google.com');
                                //   },
                                // ),
                                // SizedBox(
                                //   width: 20,
                                // ),
                                // InkWell(
                                //   borderRadius: BorderRadius.all(Radius.circular(50)),
                                //   child: Icon(
                                //     added ? Icons.bookmark : Icons.bookmark_border_outlined,
                                //     color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff7B7B7B) : Color(0xffF1F1F1),
                                //     size: 22,
                                //   ),
                                //   onTap: () => seeIfAdded(widget.data.model),
                                // ),
                                Spacer(),
                                MaterialButton(
                                  height: 26,
                                  minWidth: 65,
                                  color: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                  onPressed: () {
                                    navigateCurr();
                                  },
                                  child: Text(
                                    widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell",
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showBottomLine)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: showBottomLine ? 0 : 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7)),
                    color: showBottomLine ? theme.cardColor.withOpacity(0.6) : theme.cardColor,
                  ),
                ),
              ),
          ],
        ),
        if (showBottomLine)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)),
              color: theme.cardColor,
            ),
            child: Text(
              widget.data.statusdescreption,
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

/* Research Commodity Card */
class CommodityCard extends StatefulWidget {
  final ResearchCallsDatum data;
  final bool isScripDetailResearch;

  CommodityCard({this.data, this.isScripDetailResearch});

  @override
  State<CommodityCard> createState() => _CommodityCardState();
}

class _CommodityCardState extends State<CommodityCard> {
  bool showBottomLine;
  bool added;
  List<int> pos = [-1, -1, -1, -1];

  void seeIfAdded(ScripInfoModel scrip) async {
    bool added;
    List<int> pos = [-1, -1, -1, -1];
    for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
      pos[i] = Dataconstants.marketWatchListeners[i].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
    }
    added = pos.any((element) => element > -1);
    if (!added) {
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) => WatchListPickerCard(scrip),
      );
      if (result != null && result['added'] == 1) {
        setState(() {
          added = true;
        });
        pos[result['watchListId']] = Dataconstants.marketWatchListeners[result['watchListId']].watchList.indexWhere((element) => element.exch == scrip.exch && element.exchCode == scrip.exchCode);
        CommonFunction.showSnackBar(
          context: context,
          text: 'Added ${scrip.name} to ${Dataconstants.marketWatchListeners[result['watchListId']].watchListName}',
          duration: const Duration(milliseconds: 1500),
        );
      } else if (result != null && result['added'] == 2) {
        CommonFunction.showSnackBar(
          context: context,
          text: 'Cannot add more than ${Dataconstants.maxWatchlistCount} scrips to Watchlist',
          color: Colors.red,
          duration: const Duration(milliseconds: 1500),
        );
      }
    } else {
      setState(() {
        added = false;
      });
      for (int i = 0; i < pos.length; i++) {
        if (pos[i] > -1) {
          CommonFunction.showSnackBar(
            context: context,
            text: 'Removed ${Dataconstants.marketWatchListeners[i].watchList[pos[i]].name} from ${Dataconstants.marketWatchListeners[i].watchListName}',
            color: Colors.black,
            duration: const Duration(milliseconds: 1500),
          );
          Dataconstants.marketWatchListeners[i].removeFromWatchListIndex(pos[i]);
        }
      }
      pos = [-1, -1, -1, -1];
    }
  }

  void navigateCommodity() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return OrderPlacementScreen(
            model: widget.data.model,
            orderType: ScripDetailType.none,
            isBuy: widget.data.buysell.toUpperCase() == "BUY" ? true : false,
            selectedExch: widget.data.model.exch,
            stream: Dataconstants.pageController.stream,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Dataconstants.iqsClient.sendLTPRequest(
    //   widget.data.model,
    //   true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    widget.data.profitPotential = 0.0;
    if (widget.data.status.toUpperCase() == 'CLOSED')
      showBottomLine = true;
    else
      showBottomLine = false;
    added = false;
    if (widget.data.model != null) {
      for (int i = 0; i < Dataconstants.marketWatchListeners.length; i++) {
        pos[i] = Dataconstants.marketWatchListeners[i].watchList
            .indexWhere((element) => element.exch == widget.data.model.exch && element.exchCode == widget.data.model.exchCode);
      }
      added = pos.any((element) => element > -1);
      // //print('this scrip is already added $added');
    }
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7)),
                color: showBottomLine ? theme.cardColor.withOpacity(0.2) : theme.cardColor,
              ),
              child: Column(
                children: [
                  // if (widget.isScripDetailResearch)
                  //   Align(
                  //     alignment: Alignment.topLeft,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(7),
                  //       ),
                  //       child: CustomPaint(
                  //         painter: Chevron(),
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(top: 3, bottom: 3, left: 8, right: 25),
                  //           child: Text(
                  //             "Future & Options",
                  //             style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                          backgroundColor: theme.cardColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) => DraggableScrollableSheet(
                            maxChildSize: 0.6,
                            initialChildSize: 0.45,
                            expand: false,
                            builder: (context, controller) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Center(
                                    child: FractionallySizedBox(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 7),
                                        height: 5,
                                        decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(5)),
                                      ),
                                      widthFactor: 0.25,
                                    ),
                                  ),
                                  Container(
                                    // height: 250,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                        color: theme.cardColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      Text(
                                                        widget.data.model.desc,
                                                        style: TextStyle(fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Text(
                                                        widget.data.header,
                                                        style: TextStyle(fontSize: 10),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      // Text(
                                                      //   "${widget.data.header}",
                                                      // ),
                                                      // SizedBox(
                                                      //   height: 5,
                                                      // ),
                                                      RichText(
                                                          text: TextSpan(children: [
                                                            TextSpan(text: "Stock Code :", style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                            TextSpan(text: " ${widget.data.model.desc.toString()}", style: TextStyle(fontSize: 10, color: Colors.grey))
                                                          ]))
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    children: [
                                                      Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
                                                        // SizedBox(
                                                        //   width: 65,
                                                        // ),
                                                        Observer(
                                                          builder: (_) => Text(
                                                            '₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(2) : widget.data.model.prevDayClose.toStringAsFixed(2) : widget.data.model.close.toStringAsFixed(2)} ',
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: theme.textTheme.bodyText1.color),
                                                          ),
                                                        ),
                                                        Observer(
                                                          builder: (_) => Text(
                                                            widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: widget.data.model.percentChange > 0
                                                                  ? Utils.brightGreenColor
                                                                  : widget.data.model.percentChange < 0
                                                                  ? Utils.brightRedColor
                                                                  : theme.textTheme.bodyText1.color,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Align(
                                                        alignment: Alignment.centerRight,
                                                        child: RichText(
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text: '${widget.data.insertiontime}',
                                                                  style: TextStyle(fontSize: 10, color: Colors.grey)),
                                                              TextSpan(text: widget.data.calltype, style: TextStyle(color: Colors.blue, fontSize: 10)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Text(
                                                widget.data.internalremark,
                                                maxLines: 5,
                                                style: TextStyle(fontSize: 10, color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Target Price",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(text: '₹ ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                          TextSpan(
                                                              text: '${double.parse(widget.data.targetprice)}',
                                                              style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Profit Potential",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Observer(builder: (_) {
                                                      double profitPotential;
                                                      widget.data.model.close == 0.00
                                                          ? widget.data.model.prevDayClose == 0.00
                                                          ? widget.data.buysell.toUpperCase() == "BUY"
                                                          ? profitPotential = ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) *
                                                          widget.data.model.minimumLotQty)
                                                          : profitPotential = ((double.parse(widget.data.price) - double.parse(widget.data.targetprice)) *
                                                          widget.data.model.minimumLotQty)
                                                          : widget.data.buysell.toUpperCase() == "BUY"
                                                          ? profitPotential =
                                                      ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) * widget.data.model.minimumLotQty)
                                                          : profitPotential =
                                                      ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty)
                                                          : widget.data.buysell.toUpperCase() == "BUY"
                                                          ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.close) * widget.data.model.minimumLotQty)
                                                          : profitPotential = ((widget.data.model.close - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty);
                                                      widget.data.profitPotential = profitPotential;
                                                      return Text('₹ ${profitPotential.toStringAsFixed(0)}', style: TextStyle(color: theme.textTheme.bodyText1.color));
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Time Period",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text(widget.data.validity),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Stop Loss",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text("₹ ${double.parse(widget.data.stoploss)}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Entry Price",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(text: '\u{20B9} ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                          TextSpan(
                                                              text: '${double.parse(widget.data.price)}',
                                                              style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Status",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    Text(widget.data.status),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Call Type",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text("${widget.data.calltype}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                // if (widget.data.callType == 'FUCM')
                                                //   Column(
                                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                                //     children: [
                                                //       Text(
                                                //         "Margin Rqd",
                                                //         style: TextStyle(color: Colors.grey, fontSize: 12),
                                                //       ),
                                                //       SizedBox(height: 1),
                                                //       RichText(
                                                //         text: TextSpan(
                                                //           children: [
                                                //             TextSpan(text: '₹ ', style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                //             TextSpan(
                                                //                 text: CommonFunction.currencyFormat(snapshot.data['OrderMargin']), style: TextStyle(color: theme.textTheme.bodyText1.color)),
                                                //           ],
                                                //         ),
                                                //       ),
                                                //     ],
                                                //   ),
                                                // if (widget.data.callType == 'FUCM')
                                                //   SizedBox(
                                                //     width: 10,
                                                //   ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "View",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    Text("NA"),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Lot Size",
                                                      style: TextStyle(color: Colors.grey, fontSize: 12),
                                                    ),
                                                    SizedBox(height: 1),
                                                    Text("${widget.data.model.minimumLotQty} ${widget.data.model.unit1}")
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      )),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ButtonTheme(
                                        minWidth: 280.0,
                                        height: 30.0,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            navigateCommodity();
                                          },
                                          child: Text(widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell", style: TextStyle(color: Colors.white)),
                                        ),
                                      )),
                                  SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.data.model.desc,
                                        style: TextStyle(fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        widget.data.header,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      // Text(
                                      //   widget.data.header,
                                      //   style: TextStyle(fontWeight: FontWeight.w500),
                                      // ),
                                      // SizedBox(
                                      //   height: 3,
                                      // ),
                                      // Text(
                                      //   widget.data.model.desc,
                                      //   style: TextStyle(fontSize: 10, color: Colors.grey),
                                      // ),
                                      // SizedBox(
                                      //   height: 3,
                                      // ),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(text: widget.data.insertiontime, style: TextStyle(fontSize: 10, color: Colors.grey)),
                                            TextSpan(text: " | ", style: TextStyle(color: Colors.grey, fontSize: 10)),
                                            TextSpan(text: widget.data.calltype.toString(), style: TextStyle(color: Color(0xff03A9F5), fontSize: 10)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Observer(
                                    builder: (_) => Text(
                                      "₹ ${widget.data.model.close == 0.00 ? widget.data.model.prevDayClose == 0.00 ? double.tryParse(widget.data.price).toStringAsFixed(2) : widget.data.model.prevDayClose.toStringAsFixed(2) : widget.data.model.close.toStringAsFixed(2)}",
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Observer(
                                    builder: (_) => Text(
                                      widget.data.model.close == 0.00 ? "(0.00%)" : widget.data.model.percentChangeText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: widget.data.model.percentChange > 0
                                            ? Utils.brightGreenColor
                                            : widget.data.model.percentChange < 0
                                                ? Utils.brightRedColor
                                                : theme.textTheme.bodyText1.color,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration:
                                    BoxDecoration(color: ThemeConstants.themeMode.value == ThemeMode.light ? Colors.white : Color(0xff2E4052), borderRadius: BorderRadius.all(Radius.circular(4))),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      "Profit Potential",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Observer(builder: (_) {
                                      double profitPotential;
                                      widget.data.model.close == 0.00
                                          ? widget.data.model.prevDayClose == 0.00
                                              ? widget.data.buysell.toUpperCase() == "BUY"
                                                  ? profitPotential =
                                                      ((double.parse(widget.data.targetprice) - double.parse(widget.data.price)) * widget.data.model.minimumLotQty)
                                                  : profitPotential =
                                                      ((double.parse(widget.data.price) - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty)
                                              : widget.data.buysell.toUpperCase() == "BUY"
                                                  ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.prevDayClose) * widget.data.model.minimumLotQty)
                                                  : profitPotential = ((widget.data.model.prevDayClose - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty)
                                          : widget.data.buysell.toUpperCase() == "BUY"
                                              ? profitPotential = ((double.parse(widget.data.targetprice) - widget.data.model.close) * widget.data.model.minimumLotQty)
                                              : profitPotential = ((widget.data.model.close - double.parse(widget.data.targetprice)) * widget.data.model.minimumLotQty);
                                      widget.data.profitPotential = profitPotential;
                                      return Text('₹ ${profitPotential.toStringAsFixed(0)}',
                                          style: theme.textTheme.bodyText1.copyWith(
                                            fontSize: 16,
                                            color: profitPotential > 0 ? Utils.brightGreenColor : Utils.brightRedColor,
                                          ));
                                    }),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Target Price",
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                  SizedBox(height: 2),
                                  Text('₹ ${double.parse(widget.data.targetprice).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Stop Loss",
                                    style: TextStyle(color: Colors.grey, fontSize: 11),
                                  ),
                                  SizedBox(height: 2),
                                  Text("₹ ${double.parse(widget.data.stoploss).toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // InkWell(
                                //   borderRadius:
                                //       BorderRadius.all(Radius.circular(50)),
                                //   child: SvgPicture.asset(
                                //     ThemeConstants.themeMode.value ==
                                //             ThemeMode.light
                                //         ? "assets/images/research/share_light.svg"
                                //         : "assets/images/research/share.svg",
                                //     // height: 15,
                                //   ),
                                //   onTap: () {
                                //     Share.share(
                                //         'Hey check out this Research Idea from ICICIdirect https://google.com');
                                //   },
                                // ),
                                // SizedBox(
                                //   width: 20,
                                // ),
                                // InkWell(
                                //   borderRadius: BorderRadius.all(Radius.circular(50)),
                                //   child: Icon(
                                //     added ? Icons.bookmark : Icons.bookmark_border_outlined,
                                //     color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff7B7B7B) : Color(0xffF1F1F1),
                                //     size: 22,
                                //   ),
                                //   onTap: () => seeIfAdded(widget.data.model),
                                // ),
                                Spacer(),
                                MaterialButton(
                                  height: 26,
                                  minWidth: 65,
                                  color: widget.data.buysell.toUpperCase() == "BUY" ? Utils.brightGreenColor : Utils.brightRedColor,
                                  onPressed: () {
                                    navigateCommodity();
                                  },
                                  child: Text(
                                    widget.data.buysell.toUpperCase() == "BUY" ? "Buy" : "Sell",
                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showBottomLine)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: showBottomLine ? 0 : 15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        bottomLeft: showBottomLine ? Radius.circular(0) : Radius.circular(7),
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7)),
                    color: showBottomLine ? theme.cardColor.withOpacity(0.6) : theme.cardColor,
                  ),
                ),
              ),
          ],
        ),
        if (showBottomLine)
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)),
              color: theme.cardColor,
            ),
            child: Text(
              widget.data.statusdescreption,
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class OrderPlacementBottomSheet extends StatefulWidget {
  final String segment;
  final String stockName;
  final bool isBuy;
  final ScripInfoModel currentModel;

  OrderPlacementBottomSheet({this.segment, this.stockName, this.isBuy, this.currentModel});

  @override
  State<OrderPlacementBottomSheet> createState() => _OrderPlacementBottomSheetState();
}

class _OrderPlacementBottomSheetState extends State<OrderPlacementBottomSheet> {
  String _groupValue = 'NSE';

  valueChanged() {
    return (value) => widget.currentModel.alternateModel == null ? null : setState(() => _groupValue = value);
  }

  @override
  void initState() {
    super.initState();
    Dataconstants.iqsClient.sendLTPRequest(
      widget.currentModel.alternateModel,
      true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: DraggableScrollableSheet(
        maxChildSize: 0.4,
        initialChildSize: 0.28,
        expand: false,
        builder: (context, controller) => Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          child: Column(
            children: [
              Center(
                child: FractionallySizedBox(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 7),
                    height: 5,
                    width: 48,
                    decoration: BoxDecoration(color: Colors.grey[700], borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Stock Name:"),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: width * 0.70,
                      child: Text(
                        "${widget.stockName}",
                        softWrap: true,
                      )),
                ],
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                children: [
                  Text("Select Exchange:"),
                  SizedBox(
                    width: 10,
                  ),
                  Radio(visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity), value: "NSE", groupValue: _groupValue, onChanged: valueChanged()),
                  Text("NSE"),
                  SizedBox(
                    width: 20,
                  ),
                  Radio(visualDensity: VisualDensity(horizontal: VisualDensity.minimumDensity), value: "BSE", groupValue: _groupValue, onChanged: valueChanged()),
                  Text(
                    "BSE",
                    style: TextStyle(
                      color: widget.currentModel.alternateModel == null ? Colors.grey : theme.textTheme.bodyText1.color,
                      decoration: widget.currentModel.alternateModel == null ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    height: 40,
                    minWidth: width * 0.45,
                    color: theme.cardColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: theme.primaryColor)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            // return ScripDetailsScreen(model: _groupValue == 'NSE' ? widget.currentModel : widget.currentModel.alternateModel);
                            return ScriptInfo(_groupValue == 'NSE' ? widget.currentModel : widget.currentModel.alternateModel);
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Get Quote",
                      style: TextStyle(color: theme.primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  MaterialButton(
                    height: 40,
                    minWidth: width * 0.45,
                    color: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return OrderPlacementScreen(
                              model: widget.currentModel,
                              orderType: ScripDetailType.none,
                              isBuy: widget.isBuy,
                              selectedExch: _groupValue == 'NSE' ? "N" : "B",
                              stream: Dataconstants.pageController.stream,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      widget.isBuy ? "Buy" : "Sell",
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

/* Scrip Detail Screen Research Tab color flag */
class Chevron extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = new LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xff9C28B1), Color(0xff9C28B1)],
    );

    final Rect colorBounds = Rect.fromLTRB(0, 0, size.width, size.height);
    final Paint paint = new Paint()..shader = gradient.createShader(colorBounds);

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - size.width / 9, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/* One Click Equity common filter */
class FilterEq {
  ///
  /// Displayed label
  ///
  final String label;

  ///
  /// The displayed icon when selected
  ///
  final IconData icon;
  final Function func;

  const FilterEq({this.label, this.icon, this.func});
}
