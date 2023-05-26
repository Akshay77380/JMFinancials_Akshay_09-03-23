import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/Dataconstants.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class EquitySipOrderDetails extends StatefulWidget
{
  final bool status;
  var sipStatus,symbol,frequency,sipType,qty,price,percentChangeText,sipReferenceId,period,startDate,nextDate,endDate,avgPrice;
  EquitySipOrderDetails({Key key, @required this.status, this.sipStatus, this.symbol, this.frequency, this.sipType, this.qty, this.price, this.percentChangeText, this.sipReferenceId, this.period, this.startDate, this.nextDate, this.endDate, this.avgPrice}) : super(key: key);

  // orderDatum order;
  @override
  State<EquitySipOrderDetails> createState() => _EquitySipOrderDetailsState();
}

class _EquitySipOrderDetailsState extends State<EquitySipOrderDetails> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height - 220,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SIP Order Details",
                            style: Utils.fonts(size: 20.0),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  color: Colors.green.withOpacity(0.3),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2.0),
                                child: Text(
                                  "CLOSE",
                                  style: Utils.fonts(
                                      size: 16.0, color: Utils.blackColor),
                                ),
                              ),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "QTY",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '${widget.qty}',
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 15.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "Avg Price",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '${widget.avgPrice}',
                                style: Utils.fonts(
                                  fontWeight: FontWeight.w700,
                                  size: 15.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "STATUS",
                                style: Utils.fonts(
                                    color: Utils.greyColor,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                // widget.status ? 'ACTIVE' : 'PAUSE',
                                '${widget.sipStatus}',
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w700,
                                    size: 15.0,
                                    color: widget.status
                                        ? Utils.primaryColor
                                        : Utils.greyColor),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Utils.greyColor,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15.0),
                            )),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text("SIP STOCK",
                                style: Utils.fonts(
                                    size: 15.0, color: Utils.blackColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child: Text('${widget.symbol}',
                                        style: Utils.fonts(
                                            size: 22.0,
                                            color: Utils.blackColor,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  Observer(
                                      builder: (_) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text('${widget.price}',
                                                    // widget.order.model.close
                                                    //     .toStringAsFixed(
                                                    //     widget.order.model
                                                    //         .precision),
                                                    style: Utils.fonts(
                                                        size: 18.0,
                                                        color: Utils.blackColor,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${widget.percentChangeText}',
                                                    // widget.order.model
                                                    //     .priceChangeText +
                                                    //     " " +
                                                    //     widget.order.model
                                                    //         .percentChangeText,
                                                    style: Utils.fonts(
                                                        color:
                                                            // widget
                                                            //     .order
                                                            //     .model
                                                            //     .percentChange >
                                                            //     0
                                                            //     ? ThemeConstants
                                                            //     .buyColor
                                                            //     : widget
                                                            //     .order
                                                            //     .model
                                                            //     .percentChange <
                                                            //     0
                                                            //     ?
                                                            ThemeConstants
                                                                .sellColor
                                                        // : theme
                                                        // .errorColor
                                                        ,
                                                        size: 13.0,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Icon(
                                                      // widget.order.model
                                                      //     .percentChange >
                                                      //     0
                                                      //     ? Icons
                                                      //     .arrow_drop_up_rounded
                                                      //     :
                                                      Icons
                                                          .arrow_drop_down_rounded,
                                                      color:
                                                          // widget
                                                          //     .order
                                                          //     .model
                                                          //     .percentChange >
                                                          //     0
                                                          //     ? ThemeConstants
                                                          //     .buyColor
                                                          //     :
                                                          ThemeConstants
                                                              .sellColor,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('SIP Reference ID',
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('${widget.sipReferenceId}',
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Frequency",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('${widget.frequency}',
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Period",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('${widget.period}',
                              style: Utils.fonts(
                                  size: 14.0, color: Utils.blackColor))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Start Date",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('${widget.startDate.toString().substring(0, 10)}', style: Utils.fonts(size: 14.0, color: Utils.blackColor))

                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.status ? "Next Date" : "Pause Date",
                              style: Utils.fonts(
                                  size: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Utils.greyColor)),
                          Text('${widget.nextDate.toString().substring(0, 10)}', style: Utils.fonts(size: 14.0, color: Utils.blackColor))

                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (widget.status)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("End Date",
                                style: Utils.fonts(
                                    size: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Utils.greyColor)),
                            Text('${widget.endDate.toString().substring(0, 10)}', style: Utils.fonts(size: 14.0, color: Utils.blackColor))

                          ],
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Utils.primaryColor,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Utils.whiteColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0)),
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if (widget.status)
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(25.0),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      builder: (builder) {
                                        return DraggableScrollableSheet(
                                          initialChildSize:
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.0005,
                                          minChildSize: 0.30,
                                          maxChildSize: 0.6,
                                          expand: false,
                                          builder: (BuildContext context,
                                              ScrollController
                                                  scrollController) {
                                            return confirmDialog(false);
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text("PAUSE",
                                      style: Utils.fonts(
                                          size: 16.0, color: Utils.greyColor)),
                                )
                              else
                                Text("MODIFY",
                                    style: Utils.fonts(
                                        size: 16.0, color: Utils.greyColor)),
                              VerticalDivider(
                                color: Utils.greyColor,
                                thickness: 2,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    builder: (builder) {
                                      return DraggableScrollableSheet(
                                        initialChildSize:
                                            MediaQuery.of(context).size.height *
                                                0.0005,
                                        minChildSize: 0.30,
                                        maxChildSize: 0.6,
                                        expand: false,
                                        builder: (BuildContext context,
                                            ScrollController scrollController) {
                                          return confirmDialog(true);
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text("CANCEL",
                                    style: Utils.fonts(
                                        size: 16.0, color: Utils.greyColor)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.status)
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 150.0, vertical: 20.0),
                          child: Text("MODIFY",
                              style: Utils.fonts(
                                  size: 16.0, color: Utils.whiteColor)),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 140.0, vertical: 20.0),
                          child: Text("RESTART SIP",
                              style: Utils.fonts(
                                  size: 16.0, color: Utils.whiteColor)),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget confirmDialog(bool isCancel)
  {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          SvgPicture.asset(isCancel
              ? 'assets/appImages/cancelSip.svg'
              : 'assets/appImages/pauseSip.svg'),
          const SizedBox(
            height: 15,
          ),
          Text('${isCancel ? 'Cancel' : 'Pause'} SIP?',
              style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 15,
          ),
          Text('Are you sure you want to ${isCancel ? 'Cancel' : 'Pause'} SIP?',
              style: Utils.fonts(
                  size: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Utils.greyColor)),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              thickness: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      final dataList = await setPauseSips(Dataconstants.feUserID, Dataconstants.loginData.data.jwtToken, '${widget.sipReferenceId}');
                      // update the value of active_counter with the length of paused Sips
                      Dataconstants.active_counter.value = dataList.where((item) => item['InstructionState'] == 'A').toList().length;
                    } catch (e) {
                      print('Error: $e');
                    }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Utils.greyColor, width: 1),
                    ),
                    child: Text('Yes',
                        style: Utils.fonts(
                            size: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor)),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Utils.primaryColor,
                    ),
                    child: Text('No',
                        style: Utils.fonts(
                            size: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.whiteColor)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Future<List<dynamic>> setPauseSips(String clientCode, String sessionToken,String InstID) async {
  //   final url = Uri.parse('https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/Pause');
  //   final headers = {'Content-Type': 'application/json'};
  //   final body = jsonEncode({'ClientCode': clientCode, 'SessionToken': sessionToken,'InstID':InstID});
  //   final response = await http.post(url, headers: headers, body: body);
  //   print("response data ${response.body}");
  //   print("response body data${body}");
  //   if (response.statusCode == 200)
  //   {
  //     final dataList = jsonDecode(response.body);
  //     // Dataconstants.active_counter.value = dataList.length;
  //     Dataconstants.active_counter.value = dataList.where((item) => item['InstructionState'] == 'A').toList().length;
  //     setState(() {
  //
  //     }); // trigger a rebuild of the widget tree
  //     return dataList;
  //   }
  //   else
  //   {
  //     throw Exception('Failed to fetch pause SIPs');
  //   }
  // }

  Future<List<dynamic>> setPauseSips(String clientCode, String sessionToken,String InstID) async {
    final url = Uri.parse('https://tradeapiuat.jmfonline.in/tools/Instruction/api/sip/Pause');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'ClientCode': clientCode, 'SessionToken': sessionToken,'InstID':InstID});
    final response = await http.post(url, headers: headers, body: body);
    print("response data ${response.body}");
    print("response body data${body}");
    if (response.statusCode == 200) {
      final dataList = jsonDecode(response.body);
      Dataconstants.active_counter.value = dataList.where((item) => item['InstructionState'] == 'A').toList().length;
      setState(() {
        // trigger a rebuild of the widget tree
      });
      return dataList;
    } else {
      throw Exception('Failed to fetch pause SIPs');
    }
  }

}
