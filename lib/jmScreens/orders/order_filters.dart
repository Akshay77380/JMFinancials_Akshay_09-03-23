import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../controllers/holdingController.dart';
import '../../controllers/orderBookController.dart';
import '../../controllers/positionFilterController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../Scanners/groupMember.dart';

class OrderBookFilters extends StatefulWidget {
  final List<Map<String, bool>> _orderBookFilters;

  OrderBookFilters(this._orderBookFilters);

  @override
  State<OrderBookFilters> createState() => _OrderBookFiltersState();
}

class _OrderBookFiltersState extends State<OrderBookFilters> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return DraggableScrollableSheet(
          maxChildSize: 0.85,
          initialChildSize: 0.8,
          expand: false,
          builder: (context, controller) => SingleChildScrollView(
                controller: controller,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 2,
                          width: 30,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Utils.greyColor),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Filter by',
                        style: Utils.fonts(fontWeight: FontWeight.w600, size: 18.0),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'SEGMENT',
                        style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        runSpacing: 10.0,
                        spacing: 0.0,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: widget._orderBookFilters[0].entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    OrderBookController.orderBookFilters[0][entry.key] = !OrderBookController.orderBookFilters[0][entry.key];
                                    if (entry.key == 'All') {
                                      if (OrderBookController.orderBookFilters[0]['All'] == true) {
                                        OrderBookController.orderBookFilters[0]['Equity'] = false;
                                        OrderBookController.orderBookFilters[0]['Future'] = false;
                                        OrderBookController.orderBookFilters[0]['Option'] = false;
                                        OrderBookController.orderBookFilters[0]['Currency'] = false;
                                        OrderBookController.orderBookFilters[0]['Commodity'] = false;
                                      }
                                    } else {
                                      if (OrderBookController.orderBookFilters[0]['Equity'] == true ||
                                          OrderBookController.orderBookFilters[0]['Future'] == true ||
                                          OrderBookController.orderBookFilters[0]['Option'] == true ||
                                          OrderBookController.orderBookFilters[0]['Currency'] == true ||
                                          OrderBookController.orderBookFilters[0]['Commodity'] == true) {
                                        OrderBookController.orderBookFilters[0]['All'] = false;
                                      }
                                    }
                                  });
                                },
                                child: SizedBox(
                                  width: 125,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Obx(() {
                                          return Checkbox(
                                            checkColor: Colors.white,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            activeColor: Utils.primaryColor,
                                            value: OrderBookController.orderBookFilters[0][entry.key],
                                            shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                                            onChanged: (value) {
                                              setState(() {
                                                OrderBookController.orderBookFilters[0][entry.key] = value;
                                                if (entry.key == 'All') {
                                                  if (OrderBookController.orderBookFilters[0]['All'] == true) {
                                                    OrderBookController.orderBookFilters[0]['Equity'] = false;
                                                    OrderBookController.orderBookFilters[0]['Future'] = false;
                                                    OrderBookController.orderBookFilters[0]['Option'] = false;
                                                    OrderBookController.orderBookFilters[0]['Currency'] = false;
                                                    OrderBookController.orderBookFilters[0]['Commodity'] = false;
                                                  }
                                                } else {
                                                  if (OrderBookController.orderBookFilters[0]['Equity'] == true ||
                                                      OrderBookController.orderBookFilters[0]['Future'] == true ||
                                                      OrderBookController.orderBookFilters[0]['Option'] == true ||
                                                      OrderBookController.orderBookFilters[0]['Currency'] == true ||
                                                      OrderBookController.orderBookFilters[0]['Commodity'] == true) {
                                                    OrderBookController.orderBookFilters[0]['All'] = false;
                                                  }
                                                }
                                              });
                                            },
                                          );
                                        }),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        entry.key,
                                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'PRODUCT',
                        style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        runSpacing: 10.0,
                        spacing: 0.0,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: widget._orderBookFilters[1].entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    OrderBookController.orderBookFilters[1][entry.key] = !OrderBookController.orderBookFilters[1][entry.key];
                                    if (entry.key == 'All') {
                                      if (OrderBookController.orderBookFilters[1]['All'] == true) {
                                        OrderBookController.orderBookFilters[1]['CNC'] = false;
                                        OrderBookController.orderBookFilters[1]['MIS'] = false;
                                        OrderBookController.orderBookFilters[1]['NRML'] = false;
                                      }
                                    } else {
                                      if (OrderBookController.orderBookFilters[1]['CNC'] == true ||
                                          OrderBookController.orderBookFilters[1]['MIS'] == true ||
                                          OrderBookController.orderBookFilters[1]['NRML'] == true) {
                                        OrderBookController.orderBookFilters[1]['All'] = false;
                                      }
                                    }
                                  });
                                },
                                child: SizedBox(
                                  width: 125,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Checkbox(
                                          checkColor: Colors.white,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          activeColor: Utils.primaryColor,
                                          value: OrderBookController.orderBookFilters[1][entry.key],
                                          shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                                          onChanged: (value) {
                                            setState(() {
                                              OrderBookController.orderBookFilters[1][entry.key] = value;
                                              if (entry.key == 'All') {
                                                if (OrderBookController.orderBookFilters[1]['All'] == true) {
                                                  OrderBookController.orderBookFilters[1]['CNC'] = false;
                                                  OrderBookController.orderBookFilters[1]['MIS'] = false;
                                                  OrderBookController.orderBookFilters[1]['NRML'] = false;
                                                }
                                              } else {
                                                if (OrderBookController.orderBookFilters[1]['CNC'] == true ||
                                                    OrderBookController.orderBookFilters[1]['MIS'] == true ||
                                                    OrderBookController.orderBookFilters[1]['NRML'] == true) {
                                                  OrderBookController.orderBookFilters[1]['All'] = false;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        entry.key,
                                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'STATUS',
                        style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        runSpacing: 10.0,
                        spacing: 0.0,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runAlignment: WrapAlignment.start,
                        children: widget._orderBookFilters[2].entries
                            .map(
                              (entry) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    OrderBookController.orderBookFilters[2][entry.key] = !OrderBookController.orderBookFilters[2][entry.key];
                                    if (entry.key == 'All') {
                                      if (OrderBookController.orderBookFilters[2]['All'] == true) {
                                        OrderBookController.orderBookFilters[2]['Executed'] = false;
                                        OrderBookController.orderBookFilters[2]['Rejected'] = false;
                                        OrderBookController.orderBookFilters[2]['Cancelled'] = false;
                                      }
                                    } else {
                                      if (OrderBookController.orderBookFilters[2]['Executed'] == true ||
                                          OrderBookController.orderBookFilters[2]['Rejected'] == true ||
                                          OrderBookController.orderBookFilters[2]['Cancelled'] == true) {
                                        OrderBookController.orderBookFilters[2]['All'] = false;
                                      }
                                    }
                                  });
                                },
                                child: SizedBox(
                                  width: 125,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: Checkbox(
                                          checkColor: Colors.white,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          activeColor: Utils.primaryColor,
                                          value: OrderBookController.orderBookFilters[2][entry.key],
                                          shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                                          onChanged: (value) {
                                            setState(() {
                                              OrderBookController.orderBookFilters[2][entry.key] = value;
                                              if (entry.key == 'All') {
                                                if (OrderBookController.orderBookFilters[2]['All'] == true) {
                                                  OrderBookController.orderBookFilters[2]['Executed'] = false;
                                                  OrderBookController.orderBookFilters[2]['Rejected'] = false;
                                                  OrderBookController.orderBookFilters[2]['Cancelled'] = false;
                                                }
                                              } else {
                                                if (OrderBookController.orderBookFilters[2]['Executed'] == true ||
                                                    OrderBookController.orderBookFilters[2]['Rejected'] == true ||
                                                    OrderBookController.orderBookFilters[2]['Cancelled'] == true) {
                                                  OrderBookController.orderBookFilters[2]['All'] = false;
                                                }
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        entry.key,
                                        style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Select Expiry',
                        style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 45,
                        width: size.width,
                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Utils.greyColor.withOpacity(0.1)),
                        child: DropdownButton<String>(
                            isExpanded: true,
                            items: OrderBookController.expiryItems.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                                ),
                              );
                            }).toList(),
                            underline: SizedBox(),
                            hint: Text(
                              'All',
                              style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                            ),
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).textTheme.bodyText1.color,
                            ),
                            onChanged: (val) {}),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Sort By',
                        style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            OrderBookController.sortVal.value = 0;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Radio(
                                  value: 0,
                                  groupValue: OrderBookController.sortVal.value,
                                  onChanged: (value) {
                                    setState(() {
                                      OrderBookController.sortVal.value = value;
                                    });
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'A - Z',
                              style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            OrderBookController.sortVal.value = 1;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Radio(
                                  value: 1,
                                  groupValue: OrderBookController.sortVal.value,
                                  onChanged: (value) {
                                    setState(() {
                                      OrderBookController.sortVal.value = value;
                                    });
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Z - A',
                              style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      CommonFunction.saveAndCancelButton(
                          cancelText: 'Cancel',
                          SaveText: 'Done',
                          cancelCall: () {
                            Navigator.pop(context);
                            OrderBookController.sortVal.value = OrderBookController.sortPrevVal.value;
                            CommonFunction.cancelFilters(true);
                          },
                          saveCall: () async {
                            Navigator.pop(context);
                            Dataconstants.orderBookData.filterSortOrderBookOrders();
                            OrderBookController.sortPrevVal.value = OrderBookController.sortVal.value;
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('orderBookFilters', jsonEncode(OrderBookController.orderBookFilters));
                          })
                    ],
                  ),
                ),
              ));
    });
  }
}

class PositionFilters extends StatefulWidget {
  final List<Map<String, bool>> _positionFilters;

  PositionFilters(this._positionFilters);

  @override
  State<PositionFilters> createState() => _PositionFiltersState();
}

class _PositionFiltersState extends State<PositionFilters> {
  List<String> _expiryItems = ['All'];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return DraggableScrollableSheet(
        maxChildSize: 0.88,
        initialChildSize: 0.85,
        expand: false,
        builder: (context, controller) => SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 2,
                        width: 30,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Utils.greyColor),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Filter by',
                      style: Utils.fonts(fontWeight: FontWeight.w600, size: 18.0),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'SEGMENT',
                      style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 10.0,
                      spacing: 0.0,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: widget._positionFilters[0].entries
                          .map(
                            (entry) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  PositionFilterController.positionFilters[0][entry.key] = !PositionFilterController.positionFilters[0][entry.key];
                                  if (entry.key == 'All') {
                                    if (PositionFilterController.positionFilters[0]['All'] == true) {
                                      PositionFilterController.positionFilters[0]['Equity'] = false;
                                      PositionFilterController.positionFilters[0]['Future'] = false;
                                      PositionFilterController.positionFilters[0]['Option'] = false;
                                      PositionFilterController.positionFilters[0]['Currency'] = false;
                                      PositionFilterController.positionFilters[0]['Commodity'] = false;
                                    }
                                  } else {
                                    if (PositionFilterController.positionFilters[0]['Equity'] == true ||
                                        PositionFilterController.positionFilters[0]['Future'] == true ||
                                        PositionFilterController.positionFilters[0]['Option'] == true ||
                                        PositionFilterController.positionFilters[0]['Currency'] == true ||
                                        PositionFilterController.positionFilters[0]['Commodity'] == true) {
                                      PositionFilterController.positionFilters[0]['All'] = false;
                                    }
                                  }
                                });
                              },
                              child: SizedBox(
                                width: 125,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        activeColor: Utils.primaryColor,
                                        value: PositionFilterController.positionFilters[0][entry.key],
                                        shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                                        onChanged: (value) {
                                          setState(() {
                                            PositionFilterController.positionFilters[0][entry.key] = value;
                                            if (entry.key == 'All') {
                                              if (PositionFilterController.positionFilters[0]['All'] == true) {
                                                PositionFilterController.positionFilters[0]['Equity'] = false;
                                                PositionFilterController.positionFilters[0]['Future'] = false;
                                                PositionFilterController.positionFilters[0]['Option'] = false;
                                                PositionFilterController.positionFilters[0]['Currency'] = false;
                                                PositionFilterController.positionFilters[0]['Commodity'] = false;
                                              }
                                            } else {
                                              if (PositionFilterController.positionFilters[0]['Equity'] == true ||
                                                  PositionFilterController.positionFilters[0]['Future'] == true ||
                                                  PositionFilterController.positionFilters[0]['Option'] == true ||
                                                  PositionFilterController.positionFilters[0]['Currency'] == true ||
                                                  PositionFilterController.positionFilters[0]['Commodity'] == true) {
                                                PositionFilterController.positionFilters[0]['All'] = false;
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      entry.key,
                                      style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'PRODUCT',
                      style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 10.0,
                      spacing: 0.0,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: widget._positionFilters[1].entries
                          .map(
                            (entry) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  PositionFilterController.positionFilters[1][entry.key] = !PositionFilterController.positionFilters[1][entry.key];
                                  if (entry.key == 'All') {
                                    if (PositionFilterController.positionFilters[1]['All'] == true) {
                                      PositionFilterController.positionFilters[1]['CNC'] = false;
                                      PositionFilterController.positionFilters[1]['MIS'] = false;
                                      PositionFilterController.positionFilters[1]['NRML'] = false;
                                    }
                                  } else {
                                    if (PositionFilterController.positionFilters[1]['CNC'] == true ||
                                        PositionFilterController.positionFilters[1]['MIS'] == true ||
                                        PositionFilterController.positionFilters[1]['NRML'] == true) {
                                      PositionFilterController.positionFilters[1]['All'] = false;
                                    }
                                  }
                                });
                              },
                              child: SizedBox(
                                width: 125,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        activeColor: Utils.primaryColor,
                                        value: PositionFilterController.positionFilters[1][entry.key],
                                        shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                                        onChanged: (value) {
                                          setState(() {
                                            PositionFilterController.positionFilters[1][entry.key] = value;
                                            if (entry.key == 'All') {
                                              if (PositionFilterController.positionFilters[1]['All'] == true) {
                                                PositionFilterController.positionFilters[1]['CNC'] = false;
                                                PositionFilterController.positionFilters[1]['MIS'] = false;
                                                PositionFilterController.positionFilters[1]['NRML'] = false;
                                              }
                                            } else {
                                              if (PositionFilterController.positionFilters[1]['CNC'] == true ||
                                                  PositionFilterController.positionFilters[1]['MIS'] == true ||
                                                  PositionFilterController.positionFilters[1]['NRML'] == true) {
                                                PositionFilterController.positionFilters[1]['All'] = false;
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      entry.key,
                                      style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'POSITION',
                      style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 10.0,
                      spacing: 0.0,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: widget._positionFilters[2].entries
                          .map(
                            (entry) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  PositionFilterController.positionFilters[2][entry.key] = !PositionFilterController.positionFilters[2][entry.key];
                                  if(entry.key == 'All') {
                                    if(PositionFilterController.positionFilters[2]['All'] == true) {
                                      PositionFilterController.positionFilters[2]['Long'] = false;
                                      PositionFilterController.positionFilters[2]['Short'] = false;
                                    }
                                  } else {
                                    if(PositionFilterController.positionFilters[2]['Long'] == true ||
                                        PositionFilterController.positionFilters[2]['Short'] == true
                                    ) {
                                      PositionFilterController.positionFilters[2]['All'] = false;
                                    }
                                  }
                                });
                              },
                              child: SizedBox(
                                width: 125,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        activeColor: Utils.primaryColor,
                                        value: PositionFilterController.positionFilters[2][entry.key],
                                        shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                                        onChanged: (value) {
                                          setState(() {
                                            PositionFilterController.positionFilters[2][entry.key] = value;
                                            if(entry.key == 'All') {
                                              if(PositionFilterController.positionFilters[2]['All'] == true) {
                                                PositionFilterController.positionFilters[2]['Long'] = false;
                                                PositionFilterController.positionFilters[2]['Short'] = false;
                                              }
                                            } else {
                                              if(PositionFilterController.positionFilters[2]['Long'] == true ||
                                                  PositionFilterController.positionFilters[2]['Short'] == true
                                              ) {
                                                PositionFilterController.positionFilters[2]['All'] = false;
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      entry.key,
                                      style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'PERIODITY',
                      style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 10.0,
                      spacing: 0.0,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: widget._positionFilters[3].entries
                          .map(
                            (entry) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  PositionFilterController.positionFilters[3][entry.key] = !PositionFilterController.positionFilters[3][entry.key];
                                  if(entry.key == 'All') {
                                    if(PositionFilterController.positionFilters[3]['All'] == true) {
                                      PositionFilterController.positionFilters[3]['Daily'] = false;
                                      PositionFilterController.positionFilters[3]['Expiry'] = false;
                                    }
                                  } else {
                                    if(PositionFilterController.positionFilters[3]['Daily'] == true ||
                                        PositionFilterController.positionFilters[3]['Expiry'] == true
                                    ) {
                                      PositionFilterController.positionFilters[3]['All'] = false;
                                    }
                                  }
                                });
                              },
                              child: SizedBox(
                                width: 125,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        activeColor: Utils.primaryColor,
                                        value: PositionFilterController.positionFilters[3][entry.key],
                                        shape: CircleBorder(side: BorderSide(color: Utils.greyColor)),
                                        onChanged: (value) {
                                          setState(() {
                                            PositionFilterController.positionFilters[3][entry.key] = value;
                                            if(entry.key == 'All') {
                                              if(PositionFilterController.positionFilters[3]['All'] == true) {
                                                PositionFilterController.positionFilters[3]['Daily'] = false;
                                                PositionFilterController.positionFilters[3]['Expiry'] = false;
                                              }
                                            } else {
                                              if(PositionFilterController.positionFilters[3]['Daily'] == true ||
                                                  PositionFilterController.positionFilters[3]['Expiry'] == true
                                              ) {
                                                PositionFilterController.positionFilters[3]['All'] = false;
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      entry.key,
                                      style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Select Expiry',
                      style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 45,
                      width: size.width,
                      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Utils.greyColor.withOpacity(0.1)),
                      child: DropdownButton<String>(
                          isExpanded: true,
                          items: _expiryItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                              ),
                            );
                          }).toList(),
                          underline: SizedBox(),
                          hint: Text(
                            'All',
                            style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                          onChanged: (val) {}),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Sort By',
                      style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              PositionFilterController.sortVal.value = 0;
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Radio(
                                    value: 0,
                                    groupValue: PositionFilterController.sortVal.value,
                                    onChanged: (value) {
                                      setState(() {
                                        PositionFilterController.sortVal.value = value;
                                      });
                                    }),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'A - Z',
                                style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              PositionFilterController.sortVal.value = 2;
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Radio(
                                    value: 2,
                                    groupValue: PositionFilterController.sortVal.value,
                                    onChanged: (value) {
                                      setState(() {
                                        PositionFilterController.sortVal.value = value;
                                      });
                                    }),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Profit High - Low',
                                style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          PositionFilterController.sortVal.value = 1;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: Radio(
                                    value: 1,
                                    groupValue: PositionFilterController.sortVal.value,
                                    onChanged: (value) {
                                      setState(() {
                                        PositionFilterController.sortVal.value = value;
                                      });
                                    }),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Z - A',
                                style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                PositionFilterController.sortVal.value = 3;
                              });
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Radio(
                                      value: 3,
                                      groupValue: PositionFilterController.sortVal.value,
                                      onChanged: (value) {
                                        setState(() {
                                          PositionFilterController.sortVal.value = value;
                                        });
                                      }),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Profit Low - High',
                                  style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    CommonFunction.saveAndCancelButton(
                        cancelText: 'Cancel',
                        SaveText: 'Done',
                        cancelCall: () {
                          Navigator.pop(context);
                          PositionFilterController.sortVal.value = PositionFilterController.sortPrevVal.value;
                          CommonFunction.cancelFilters(false);
                        },
                        saveCall: () async {
                          Navigator.pop(context);
                          PositionFilterController.sortPrevVal.value = PositionFilterController.sortVal.value;
                          Dataconstants.positionFilterController.filterSortPositionOrders();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('positionFilters', jsonEncode(PositionFilterController.positionFilters));
                        })
                  ],
                ),
              ),
            ));
  }
}

class ScannerSortFilters extends StatefulWidget {
  final List<Map<String, bool>> _orderBookFilters;

  ScannerSortFilters(this._orderBookFilters);

  @override
  State<ScannerSortFilters> createState() => _ScannerSortFiltersState();
}

class _ScannerSortFiltersState extends State<ScannerSortFilters> {
  static List<GroupMemberClass> groupList = [];
  static Database _database, db;
  Map<ScannerConditions, Conditions> conditionEnumMap = new Map();
  List<String> dropDownList = [];
  String nseGroupMember = 'MST_GroupMember';
  List<ScannerConditions> conditionList = [];
  Map<String, int> categorylist = Map();
  int i = 0;

  @override
  void initState() {
    // TODO: implement initState

    getDropDownlist();
    super.initState();

    conditionEnumMap[ScannerConditions.RedBody] = new Conditions(
        lName: 'Red Body',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.RedBody,
        scanId: "1");

    conditionEnumMap[ScannerConditions.GapDown] = new Conditions(
        lName: 'Gap Down',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.GapDown,
        scanId: "2");

    conditionEnumMap[ScannerConditions.openEqualToHigh] = new Conditions(
        lName: 'Open = High',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.openEqualToHigh,
        scanId: "3");

    conditionEnumMap[ScannerConditions.CLoseBelowPrevDayLow] = new Conditions(
        lName: 'Close Below Prev Day Low',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.CLoseBelowPrevDayLow,
        scanId: "4");

    conditionEnumMap[ScannerConditions.CLoseBelowPrevWeekLow] = new Conditions(
        lName: 'Close Below Prev Week Low',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.CLoseBelowPrevWeekLow,
        scanId: "5",
        allowed: false);

    conditionEnumMap[ScannerConditions.CLoseBelowPrevMonthLow] = new Conditions(
        lName: 'Close Below Prev Month Low',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.CLoseBelowPrevMonthLow,
        scanId: "6");

    conditionEnumMap[ScannerConditions.CloseBelow5DayLow] = new Conditions(
        lName: 'Close Below 5 Day Low',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.CloseBelow5DayLow,
        scanId: "7");

    conditionEnumMap[ScannerConditions.GreenBody] = new Conditions(
        lName: 'Green Body',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.GreenBody,
        scanId: "8");

    conditionEnumMap[ScannerConditions.GapUp] = new Conditions(
        lName: 'Gap Up',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.GapUp,
        scanId: "9");

    conditionEnumMap[ScannerConditions.openEqualToLow] = new Conditions(
        lName: 'Open = Low',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.openEqualToLow,
        scanId: "10");

    conditionEnumMap[ScannerConditions.PriceTrendRisingLast2Days] = new Conditions(
        lName: 'Price Trend Rising Last 2 Days',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceTrendRisingLast2Days,
        scanId: "11");

    conditionEnumMap[ScannerConditions.PriceTrendFallingLast2Days] = new Conditions(
        lName: 'Price Trend Falling Last 2 Days',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.PriceTrendFallingLast2Days,
        scanId: "12");

    conditionEnumMap[ScannerConditions.DoubleBottom2DaysReversal] = new Conditions(
        lName: 'Double Bottom 2 Days Reversal',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.DoubleBottom2DaysReversal,
        scanId: "13");

    conditionEnumMap[ScannerConditions.PriceDownwardReversal] = new Conditions(
        lName: 'Price Downward Reversal',
        readDB: true,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.PriceDownwardReversal,
        scanId: "14");

    conditionEnumMap[ScannerConditions.CloseAbovePrevDayHigh] = new Conditions(
        lName: 'Close Above Prev Day High',
        readDB: false,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.CloseAbovePrevDayHigh,
        scanId: "15");

    conditionEnumMap[ScannerConditions.CloseAbovePrevWeekHigh] = new Conditions(
        lName: 'Close Above Prev Week High',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.CloseAbovePrevWeekHigh,
        scanId: "16",
        allowed: false);

    conditionEnumMap[ScannerConditions.CloseAbovePrevMonthHigh] = new Conditions(
        lName: 'Close Above Prev Month High',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.CloseAbovePrevMonthHigh,
        scanId: "17");

    conditionEnumMap[ScannerConditions.CloseAbove5DayHigh] = new Conditions(
        lName: 'Close Above 5 Day High',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.CloseAbove5DayHigh,
        scanId: "18");

    conditionEnumMap[ScannerConditions.Doubletop2DaysReversal] = new Conditions(
        lName: 'Double top 2 Days Reversal',
        readDB: false,
        category: "Price Bearish",
        scannerConditions: ScannerConditions.Doubletop2DaysReversal,
        scanId: "19");

    conditionEnumMap[ScannerConditions.PriceUpwardReversal] = new Conditions(
        lName: 'Price Upward Reversal',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceUpwardReversal,
        scanId: "20");

    conditionEnumMap[ScannerConditions.VolumeRaiseAbove50] = new Conditions(
        lName: 'Vol 50% Above Prev. Day',
        readDB: true,
        category: "Volume Rising",
        scannerConditions: ScannerConditions.VolumeRaiseAbove50,
        scanId: "21");

    conditionEnumMap[ScannerConditions.VolumeRaiseAbove100] = new Conditions(
        lName: 'Vol 100% Above Prev. Day',
        readDB: true,
        category: "Volume Rising",
        scannerConditions: ScannerConditions.VolumeRaiseAbove100,
        scanId: "22");

    conditionEnumMap[ScannerConditions.VolumeRaiseAbove200] = new Conditions(
        lName: 'Vol 200% Above Prev. Day',
        readDB: true,
        category: "Volume Rising",
        scannerConditions: ScannerConditions.VolumeRaiseAbove200,
        scanId: "23");

    conditionEnumMap[ScannerConditions.PriceAboveR4] = new Conditions(
        lName: 'Price Above R4',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAboveR4,
        scanId: "24");

    conditionEnumMap[ScannerConditions.PriceAboveR3] = new Conditions(
        lName: 'Price Above R3',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAboveR3,
        scanId: "25");

    conditionEnumMap[ScannerConditions.PriceAboveR2] = new Conditions(
        lName: 'Price Above R2',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAboveR2,
        scanId: "26");

    conditionEnumMap[ScannerConditions.PriceAboveR1] = new Conditions(
        lName: 'Price Above R1',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAboveR1,
        scanId: "27");

    conditionEnumMap[ScannerConditions.PriceAbovePivot] = new Conditions(
        lName: 'Price Above Pivot',
        readDB: false,
        category: "Pivot Bullish",
        scannerConditions: ScannerConditions.PriceAbovePivot,
        scanId: "28");

    conditionEnumMap[ScannerConditions.PriceBelowS4] = new Conditions(
        lName: 'Price Below S4',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowS4,
        scanId: "29");

    conditionEnumMap[ScannerConditions.PriceBelowS3] = new Conditions(
        lName: 'Price Below S3',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowS3,
        scanId: "30");

    conditionEnumMap[ScannerConditions.PriceBelowS2] = new Conditions(
        lName: 'Price Below S2',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowS2,
        scanId: "31");

    conditionEnumMap[ScannerConditions.PriceBelowS1] = new Conditions(
        lName: 'Price Below S1',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowS1,
        scanId: "32");

    conditionEnumMap[ScannerConditions.PriceBelowPivot] = new Conditions(
        lName: 'Price Below Pivot',
        readDB: false,
        category: "Pivot Bearish",
        scannerConditions: ScannerConditions.PriceBelowPivot,
        scanId: "33");

    conditionEnumMap[ScannerConditions.PriceGrowth1YearAbove25] =
    new Conditions(
        lName: 'Price-Growth 1 Yr Abv 25%',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceGrowth1YearAbove25,
        scanId: "33B");

    conditionEnumMap[ScannerConditions.PriceGrowth3YearBetween25To50] =
    new Conditions(
        lName: 'Price-Growth 3 Yr Btw 25%-50%',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceGrowth3YearBetween25To50,
        scanId: "34");

    conditionEnumMap[ScannerConditions.PriceGrowth3YearBetween50To100] =
    new Conditions(
        lName: 'Price-Growth 3 Yr Btw 50%-100%',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceGrowth3YearBetween50To100,
        scanId: "35");

    conditionEnumMap[ScannerConditions.PriceGrowth3YearAbove100] =
    new Conditions(
        lName: 'Price-Growth 3 Yr Abv 100%',
        readDB: true,
        category: "Price Bullish",
        scannerConditions: ScannerConditions.PriceGrowth3YearAbove100,
        scanId: "36");

    conditionEnumMap[ScannerConditions.PriceAboveSMA5] = new Conditions(
        lName: 'Price Above SMA-5',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA5,
        scanId: "37");

    conditionEnumMap[ScannerConditions.PriceAboveSMA20] = new Conditions(
        lName: 'Price Above SMA-20',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA20,
        scanId: "38");

    conditionEnumMap[ScannerConditions.PriceAboveSMA50] = new Conditions(
        lName: 'Price Above SMA-50',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA50,
        scanId: "39");

    conditionEnumMap[ScannerConditions.PriceAboveSMA100] = new Conditions(
        lName: 'Price Above SMA-100',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA100,
        scanId: "40");

    conditionEnumMap[ScannerConditions.PriceAboveSMA200] = new Conditions(
        lName: 'Price Above SMA-200',
        readDB: true,
        category: "Average Bullish",
        scannerConditions: ScannerConditions.PriceAboveSMA200,
        scanId: "40B");

    conditionEnumMap[ScannerConditions.PriceBelowSMA5] = new Conditions(
        lName: 'Price Below SMA-5',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA5,
        scanId: "41");

    conditionEnumMap[ScannerConditions.PriceBelowSMA20] = new Conditions(
        lName: 'Price Below SMA-20',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA20,
        scanId: "42");

    conditionEnumMap[ScannerConditions.PriceBelowSMA50] = new Conditions(
        lName: 'Price Below SMA-50',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA50,
        scanId: "43");

    conditionEnumMap[ScannerConditions.PriceBelowSMA100] = new Conditions(
        lName: 'Price Below SMA-100',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA100,
        scanId: "44");

    conditionEnumMap[ScannerConditions.PriceBelowSMA200] = new Conditions(
        lName: 'Price Below SMA-200',
        readDB: true,
        category: "Average Bearish",
        scannerConditions: ScannerConditions.PriceBelowSMA200,
        scanId: "45");

    conditionEnumMap[ScannerConditions.PriceAboveSuperTrend1] = new Conditions(
        lName: 'Price Above SuperTrend 1',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceAboveSuperTrend1,
        scanId: "46");

    conditionEnumMap[ScannerConditions.PriceAboveSuperTrend2] = new Conditions(
        lName: 'Price Above SuperTrend 2',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceAboveSuperTrend2,
        scanId: "47");

    conditionEnumMap[ScannerConditions.PriceAboveSuperTrend3] = new Conditions(
        lName: 'Price Above SuperTrend 3',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceAboveSuperTrend3,
        scanId: "48");

    conditionEnumMap[ScannerConditions.PriceBelowSuperTrend1] = new Conditions(
        lName: 'Price Below SuperTrend 1',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBelowSuperTrend1,
        scanId: "49");

    conditionEnumMap[ScannerConditions.PriceBelowSuperTrend2] = new Conditions(
        lName: 'Price Below SuperTrend 2',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBelowSuperTrend2,
        scanId: "50");

    conditionEnumMap[ScannerConditions.PriceBelowSuperTrend3] = new Conditions(
        lName: 'Price Below SuperTrend 3',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBelowSuperTrend3,
        scanId: "51");

    conditionEnumMap[ScannerConditions.PriceBetweenSuperTrend1and2] =
    new Conditions(
        lName: 'Price Btw SuperTrend 1 & 2',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBetweenSuperTrend1and2,
        scanId: "52");

    conditionEnumMap[ScannerConditions.PriceBetweenSuperTrend2and3] =
    new Conditions(
        lName: 'Price Btw SuperTrend 2 & 3',
        readDB: true,
        category: "SuperTrend",
        scannerConditions: ScannerConditions.PriceBetweenSuperTrend2and3,
        scanId: "53");

    conditionEnumMap[ScannerConditions.RSIOverSold30] = new Conditions(
        lName: 'RSI Over Sold30',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIOverSold30,
        scanId: "54");

    conditionEnumMap[ScannerConditions.RSIBetween30To50] = new Conditions(
        lName: 'RSI Between 30 To 50',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIBetween30To50,
        scanId: "55");

    conditionEnumMap[ScannerConditions.RSIBetween50TO70] = new Conditions(
        lName: 'RSI Between 50 To 70',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIBetween50TO70,
        scanId: "56");

    conditionEnumMap[ScannerConditions.RSIOverBought70] = new Conditions(
        lName: 'RSI OverBought 70',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIOverBought70,
        scanId: "57");

    conditionEnumMap[ScannerConditions.RSIAboveRSIAvg30] = new Conditions(
        lName: 'RSI Above RSI Avg30',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIAboveRSIAvg30,
        scanId: "58");

    conditionEnumMap[ScannerConditions.RSIBelowRSIAvg30] = new Conditions(
        lName: 'RSI Below RSI Avg30',
        readDB: true,
        category: "RSI Relative Strength Index",
        scannerConditions: ScannerConditions.RSIBelowRSIAvg30,
        scanId: "59");
    conditionEnumMap.forEach((key, value) {
      conditionList.add(key);
      categorylist[value.category.contains("Bullish")
          ? "Bullish"
          : value.category.contains("Bearish")
          ? "Bearish"
          : "Others"] = categorylist.containsKey(value.category) ? i++ : 0;
    });
  }

  Future<Database> initializeDatabaseFromPath(String path) async {
    try {
      CommonFunction.writeLogInInternalMemory(
          'LaunchWidget', 'loadDatabaseData', 'Database opening path' + path);
      Dataconstants.globalFilePath = path;
      _database = await openDatabase(path, version: 2);

      return _database;
    } catch (e, stackTrace) {
      CommonFunction.sendDataToCrashlytics(
          e, stackTrace, 'SqliteDatabase-initializeDatabaseFromPath Exception');
      return null;
    }
  }

  void getDropDownlist() {
    dropDownList = [];
    //dropDownList.add("NSE - All Scrips");
    for (int i = 0; i < Dataconstants.groupList.length; i++) {
      if (!dropDownList.contains(Dataconstants.groupList[i].groupName)) {
        dropDownList.add(Dataconstants.groupList[i].groupName);
      }
    }
    //log("drop down list => $dropDownList");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return DraggableScrollableSheet(
              maxChildSize: 0.85,
              initialChildSize: 0.8,
              expand: false,
              builder: (context, controller) => Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 2,
                        width: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Utils.greyColor),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter by',
                          style: Utils.fonts(
                              fontWeight: FontWeight.w600, size: 18.0),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            return showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (builder) {
                                  return new Container(
                                    height: 450.0,
                                    color: Colors.transparent,
                                    //could change this to Color(0xFF737373),
                                    //so you don't have to change MaterialApp canvasColor
                                    child: new Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                const Radius.circular(10.0),
                                                topRight: const Radius.circular(
                                                    10.0))),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0,
                                                right: 20.0,
                                                top: 20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                    CustomTabBarScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                Dataconstants
                                                                    .selectedFilterName =
                                                                dropDownList[
                                                                index];
                                                                // //print("filter => ${dropDownList[
                                                                // index]}");
                                                              });
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                            child: ListTile(
                                                              title: Text(
                                                                  '${dropDownList[index].toString()}'),
                                                            ),
                                                          ),
                                                          Divider()
                                                        ],
                                                      );
                                                    },
                                                    itemCount:
                                                    dropDownList.length,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 40,
                                width:
                                Dataconstants.selectedFilterName.length > 15
                                    ? 200
                                    : 150,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  border: Border.all(
                                    color: theme.primaryColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "${Dataconstants.selectedFilterName}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: CustomTabBarScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categorylist.length,
                        itemBuilder: (context, index) {
                          return Column(
                              children: _buildExpandableListView(Dataconstants
                                  .scannerTabControllerIndex ==
                                  0
                                  ? 'Bullish'
                                  : Dataconstants.scannerTabControllerIndex == 1
                                  ? 'Bearish'
                                  : 'Others'));
                        },
                      ),
                    )
                  ],
                ),
              ));
        });
  }

  List<Widget> _buildExpandableListView(String categoryname) {
    List<Widget> columnContent = [];

    for (var value in conditionEnumMap.values) {
      if (value.allowed == false) continue;
      if (value.category.contains(categoryname))
        columnContent.add(
          ListTile(
            title: Text(
              value.lName,
              style: TextStyle(fontSize: 13.8, color: Colors.grey),
            ),
            onTap: () async {
              if (value.category.contains("Bullish")) {
                Navigator.of(context).pop();
                Dataconstants.selectedScannerConditionForBullish =
                    value.scannerConditions;
                await Dataconstants.scannerData.getData(
                    dropDownValue: Dataconstants.selectedFilterName,
                    selectedCondition:
                    Dataconstants.selectedScannerConditionForBullish,
                    conditionEnumMap: conditionEnumMap);
              } else if (value.category.contains("Bearish")) {
                Navigator.of(context).pop();
                Dataconstants.selectedScannerConditionForBearish =
                    value.scannerConditions;
                await Dataconstants.scannerData.getData(
                    dropDownValue: Dataconstants.selectedFilterName,
                    selectedCondition:
                    Dataconstants.selectedScannerConditionForBearish,
                    conditionEnumMap: conditionEnumMap);
              } else {
                Navigator.of(context).pop();
                Dataconstants.selectedScannerConditionForOthers =
                    value.scannerConditions;
                await Dataconstants.scannerData.getData(
                    dropDownValue: Dataconstants.selectedFilterName,
                    selectedCondition:
                    Dataconstants.selectedScannerConditionForOthers,
                    conditionEnumMap: conditionEnumMap);
              }
              //log("filter ${Dataconstants.selectedFilterName} and inside data ${value.lName}");
            },
          ),
        );
      if ((!value.category.contains("Bullish") &&
          categoryname != "Bullish" &&
          !value.category.contains("Bearish") &&
          categoryname != "Bearish" &&
          !value.category.contains("Favourite") &&
          categoryname != "Favourite"))
        columnContent.add(
          ListTile(
            title: Text(
              value.lName,
              style: TextStyle(fontSize: 13.8),
            ),
            onTap: () {},
          ),
        );
    }

    return columnContent;
  }
}

class HoldingFilters extends StatefulWidget {
  @override
  State<HoldingFilters> createState() => _HoldingFiltersState();
}

class _HoldingFiltersState extends State<HoldingFilters> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return DraggableScrollableSheet(
          maxChildSize: 0.5,
          initialChildSize: 0.35,
          expand: false,
          builder: (context, controller) => SingleChildScrollView(
                controller: controller,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 2,
                          width: 30,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Utils.greyColor),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Sort By',
                        style: Utils.fonts(fontWeight: FontWeight.w600, size: 18.0),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            HoldingController.sortVal.value = 0;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Radio(
                                  value: 0,
                                  groupValue: HoldingController.sortVal.value,
                                  onChanged: (value) {
                                    setState(() {
                                      HoldingController.sortVal.value = value;
                                    });
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'A - Z',
                              style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            HoldingController.sortVal.value = 1;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Radio(
                                  value: 1,
                                  groupValue: HoldingController.sortVal.value,
                                  onChanged: (value) {
                                    setState(() {
                                      HoldingController.sortVal.value = value;
                                    });
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Z - A',
                              style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            HoldingController.sortVal.value = 2;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Radio(
                                  value: 2,
                                  groupValue: HoldingController.sortVal.value,
                                  onChanged: (value) {
                                    setState(() {
                                      HoldingController.sortVal.value = value;
                                    });
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Profit High - Low',
                              style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            HoldingController.sortVal.value = 3;
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Radio(
                                  value: 3,
                                  groupValue: HoldingController.sortVal.value,
                                  onChanged: (value) {
                                    setState(() {
                                      HoldingController.sortVal.value = value;
                                    });
                                  }),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Profit Low - High',
                              style: Utils.fonts(fontWeight: FontWeight.w400, size: 14.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      CommonFunction.saveAndCancelButton(
                          cancelText: 'Cancel',
                          SaveText: 'Done',
                          cancelCall: () {
                            Navigator.pop(context);
                            HoldingController.sortVal.value = HoldingController.sortPrevVal.value;
                          },
                          saveCall: () async {
                            Navigator.pop(context);
                            Dataconstants.holdingController.sortHoldings();
                            HoldingController.sortPrevVal.value = HoldingController.sortVal.value;
                          })
                    ],
                  ),
                ),
              ));
    });
  }
}
