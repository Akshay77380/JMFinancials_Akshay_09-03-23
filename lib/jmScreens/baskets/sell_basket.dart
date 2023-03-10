import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/Utils.dart';
import '../CommonWidgets/number_field.dart';

class sellBasket extends StatefulWidget {
  @override
  State<sellBasket> createState() => _sellBasketState();
}

class _sellBasketState extends State<sellBasket> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Utils.mediumRedColor.withOpacity(0.8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 3.0),
                  child: Text(
                    "SELL",
                    style: Utils.fonts(
                        size: 14.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text("IT Basket",
                  style: Utils.fonts(
                      size: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
            ],
          ),
          actions: [Icon(Icons.more_vert)],
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Utils.primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Current Value",
                          style: Utils.fonts(
                              size: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "51,301.89",
                          style: Utils.fonts(
                              size: 15.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            thickness: 3,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Amount",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w700, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                NumberField(
                  numberController: _textEditingController,
                  maxLength: 22,
                  isBuy: true,
                )
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(children: [
                  Text(
                    "Note",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: SvgPicture.asset(
                        "assets/appImages/basket/inverted_rectangle.svg",
                        color: Colors.black),
                  )
                ]),
                Text(
                    "The actual sell value of basket may differ since all orders will be placed at market at time of execution.",
                    style: Utils.fonts(
                        size: 13.0,
                        fontWeight: FontWeight.w600,
                        color: Utils.greyColor.withOpacity(0.5)))
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      bottomNavigationBar: Card(
        margin: EdgeInsets.zero,
        color: Utils.whiteColor,
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Utils.primaryColor,
            ),
            child: Center(
                child: Text("Confirm Account",
                    style: Utils.fonts(
                        fontWeight: FontWeight.w600, color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
