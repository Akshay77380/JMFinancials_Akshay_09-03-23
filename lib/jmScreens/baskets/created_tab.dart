import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controllers/basketController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'basket.dart';
import 'basket_overview.dart';

class CreatedTab extends StatefulWidget {
  @override
  State<CreatedTab> createState() => _CreatedTabState();
}

class _CreatedTabState extends State<CreatedTab> {
  // List<MainData> globalArray = [];
  TextEditingController _basketController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  BasketController.BasketList.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Utils.primaryColor.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Current Value",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "15,24,555.50",
                                      style: Utils.fonts(
                                          size: 14.0,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Unrealised P/L",
                                      style: Utils.fonts(
                                          size: 12.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "1,25,251.5",
                                      style: Utils.fonts(
                                          size: 14.0,
                                          color: Utils.mediumGreenColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                  BasketController.BasketList.isEmpty
                      ? SizedBox.shrink()
                      : SizedBox(
                          height: 20,
                        ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Utils.containerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: TextField(
                            textAlign: TextAlign.start,
                            style: Utils.fonts(
                                color: Utils.blackColor,
                                fontWeight: FontWeight.w500,
                                size: 15.0),
                            decoration: InputDecoration(
                                prefixIcon: Icon(CupertinoIcons.search),
                                hintText: "Search your Basket",
                                hintStyle: Utils.fonts(
                                    color: Utils.greyColor,
                                    fontWeight: FontWeight.w500,
                                    size: 15.0),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          DotExpand2();
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Utils.primaryColor.withOpacity(0.1)),
                          child: SvgPicture.asset(
                            'assets/appImages/basket/plus.svg',
                            color: Utils.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 2.5,
              color: Utils.greyColor.withOpacity(0.1),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BasketController.BasketList.isEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          SvgPicture.asset(
                              "assets/appImages/basket/basket.svg"),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            "Your Basket is Empty. Add your favourite scrips using search bar on the top",
                            textAlign: TextAlign.center,
                            style: Utils.fonts(
                                fontWeight: FontWeight.w500,
                                size: 15.0,
                                color: Utils.greyColor),
                          )
                        ],
                      )
                    : Column(
                        children: [
                          for (var index = 0;
                              index < BasketController.BasketList.length;
                              index++)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => basketOverview(
                                              BasketController
                                                  .BasketList[index],
                                              false),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              BasketController
                                                  .BasketList[index].basketName,
                                              style: Utils.fonts(
                                                  fontWeight: FontWeight.w700,
                                                  size: 14.0),
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: Utils.darkyellowColor
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3)),
                                                child: Center(
                                                    child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 2.0),
                                                  child: Text(
                                                    "0 scrips",
                                                    style: Utils.fonts(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        size: 11.0,
                                                        color: Utils
                                                            .darkyellowColor),
                                                  ),
                                                )))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "Basket Value: 10,222",
                                                style: Utils.fonts(
                                                    fontWeight: FontWeight.w500,
                                                    size: 11.0,
                                                    color: Utils.greyColor
                                                        .withOpacity(0.8)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                )
                              ],
                            )
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget DotExpand2() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0))),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Container(
                                  width: 30,
                                  height: 2,
                                  color: Utils.greyColor,
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "New Basket",
                                style: Utils.fonts(size: 18.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextField(
                                maxLength: 15,
                                controller: _basketController,
                                // focusNode: myFocusNodeCreateWatchlist,
                                showCursor: true,
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                                onChanged: (value) {
                                  // setState(() {
                                  //   // newWatchListName = value;
                                  // });
                                },
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).cardColor,
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                  focusColor: Theme.of(context).primaryColor,
                                  filled: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  labelText: "Basket Name",
                                  // prefixIcon: Icon(
                                  //   Icons.phone_android_rounded,
                                  //   size: 18,
                                  //   color: Colors.grey,
                                  // ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0),
                                        child: Text(
                                          "Cancel",
                                          style: Utils.fonts(
                                              size: 14.0,
                                              color: Utils.greyColor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  side: BorderSide(
                                                      color:
                                                          Utils.greyColor))))),
                                  ElevatedButton(
                                      onPressed: () async {
                                        if (_basketController.text
                                            .toString()
                                            .isEmpty) {
                                          CommonFunction.CustomToast(
                                              Icons.error,
                                              "Enter Basket Name",
                                              false);
                                          return;
                                        }

                                        var requestJson = {
                                          "LoginID": Dataconstants.feUserID,
                                          "Operation": "INSERT",
                                          "Basketname":
                                              _basketController.text.toString(),
                                          "Basketscrips": " "
                                        };
                                        //log("create watchlist request - ${requestJson.toString()}");

                                        var response =
                                            await CommonFunction.createBasket(
                                                requestJson);
                                        var basketId;
                                        try {
                                          basketId = response["data"][0]
                                                  ["Basket_Id"]
                                              .toString();

                                          Navigator.pop(context);

                                          BasketController().fetchBasket();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Basket(
                                                      _basketController.text
                                                          .toString(),
                                                      basketId))).then((value) {
                                            _basketController.text = "";
                                            setState(() {});
                                          });
                                        } catch (e) {
                                          CommonFunction.showBasicToast(
                                              response["data"][0]["Msg"]
                                                  .toString());
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0),
                                        child: Text(
                                          "Create",
                                          style: Utils.fonts(
                                              size: 14.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Utils.primaryColor),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          )))),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          );
        }).then((value) {
      setState(() {});
    });
  }
}
