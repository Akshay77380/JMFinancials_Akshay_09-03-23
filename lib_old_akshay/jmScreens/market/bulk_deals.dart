import 'package:flutter/material.dart';

import '../../util/Utils.dart';

class BulkDeals extends StatefulWidget {
  var _currentIndex = 0;

  @override
  State<BulkDeals> createState() => _BulkDealsState();
}

class _BulkDealsState extends State<BulkDeals> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                widget._currentIndex = 0;
                setState(() {});
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    border: Border.all(
                        color: widget._currentIndex == 0
                            ? Utils.primaryColor
                            : Utils.greyColor)),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("NSE",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: widget._currentIndex == 0
                                  ? Utils.primaryColor
                                  : Utils.lightGreyColor)),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget._currentIndex = 1;
                setState(() {});
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    border: Border.all(
                        color: widget._currentIndex == 1
                            ? Utils.primaryColor
                            : Utils.greyColor)),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("BSE",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: widget._currentIndex == 1
                                  ? Utils.primaryColor
                                  : Utils.lightGreyColor)),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        for (var i = 0; i < 5; i++)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("ASTRAMICRO",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: widget._currentIndex == 2
                                  ? Utils.primaryColor
                                  : Utils.blackColor)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("NSE",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 14.0,
                                color: widget._currentIndex == 2
                                    ? Utils.primaryColor
                                    : Utils.lightGreyColor)),
                      ),
                    ],
                  ),
                  Text("PURCHASE",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w700,
                          size: 14.0,
                          color: Utils.darkGreenColor)),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Qty",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.lightGreyColor)),
                      Text("5,00,000",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.blackColor)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Price",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.lightGreyColor)),
                      Text("216.0",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.blackColor)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Traded % ",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.lightGreyColor)),
                      Text("0.6%",
                          style: Utils.fonts(
                              fontWeight: FontWeight.w500,
                              size: 14.0,
                              color: Utils.blackColor)),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text("Sold by: ADHUNIK RESIDENCY PRIVATE LIMITED",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w500,
                          size: 14.0,
                          color: Utils.lightGreyColor)
                  ),
                ],
              ),
              Divider(
                thickness: 2,
              )
            ],
          )
      ],
    );
  }
}
