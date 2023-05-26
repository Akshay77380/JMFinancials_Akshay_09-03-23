import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../controllers/basketController.dart';
import '../../screens/search_bar_screen.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class Basket extends StatefulWidget {
  var basketName;
  var basketId;

  Basket(this.basketName, this.basketId);

  @override
  State<Basket> createState() => _BasketState();
}

class _BasketState extends State<Basket> {
  var scriptCount = 0;

  List scriptArray = [];

  getList() {
    List<Widget> list = [];
    for (int i = 0; i < scriptArray.length; i++) {
      list.add(Container(
        key: Key('$i'),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset('assets/appImages/basket/drag.svg'),
              SizedBox(
                width: 10,
              ),
              Text(
                scriptArray[i]["name"],
                style: Utils.fonts(
                    fontWeight: FontWeight.w700,
                    size: 16.0,
                    color: Utils.blackColor),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Utils.greyColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        if (scriptArray[i]["locked"]) return;
                        var newValue = double.parse(scriptArray[i]["weight"]);
                        scriptArray[i]["weight"] = (newValue - 1).toString();
                        scriptArray[i]["controller"].text =
                            scriptArray[i]["weight"];
                        modifyData();
                        setState(() {});
                      },
                      child:
                          SvgPicture.asset('assets/appImages/basket/minus.svg'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 50,
                      child: TextField(
                        enabled: !scriptArray[i]["locked"],
                        controller: scriptArray[i]["controller"],
                        onChanged: (value) {
                          setState(() {
                            scriptArray[i]["weight"] = value.toString();
                          });
                        },
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        if (scriptArray[i]["locked"]) return;
                        var newValue = double.parse(scriptArray[i]["weight"]);
                        scriptArray[i]["weight"] = (newValue + 1).toString();
                        scriptArray[i]["controller"].text =
                            scriptArray[i]["weight"];
                        modifyData();
                        setState(() {});
                      },
                      child:
                          SvgPicture.asset('assets/appImages/basket/plus.svg'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  scriptArray[i]["locked"] = !scriptArray[i]["locked"];
                  modifyData();
                  setState(() {});
                },
                child: SvgPicture.asset(
                  'assets/appImages/basket/lock.svg',
                  color: scriptArray[i]["locked"]
                      ? Utils.primaryColor
                      : Utils.greyColor.withOpacity(0.5),
                ),
              )
            ],
          ),
        ),
      ));
    }
    return list;
  }

  var basketId = -1;

  getBasketId() {
    for (var i = 0; i < BasketController.BasketList.length; i++) {
      if (BasketController.BasketList[i].basketName == widget.basketName) {
        basketId = i;
        break;
      }
    }
    return true;
  }

  @override
  void initState() {
    getBasketId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.basketName,
          style: Utils.fonts(size: 16.0, color: Utils.blackColor),
        ),
        actions: [
          InkWell(
            child: SvgPicture.asset('assets/appImages/basket/tranding.svg'),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Utils.containerColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: InkWell(
                          onTap: () {
                            Dataconstants.isComingFromMarginCalculator = true;
                            Dataconstants.searchModel = null;
                            showSearch(
                              context: context,
                              delegate: SearchBarScreen(0),
                            ).then((value) {
                              addData();
                            });
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: TextField(
                                  enabled: false,
                                  textAlign: TextAlign.start,
                                  style: Utils.fonts(
                                      color: Utils.blackColor,
                                      fontWeight: FontWeight.w500,
                                      size: 15.0),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(CupertinoIcons.search),
                                      hintText: "Add Scrips",
                                      hintStyle: Utils.fonts(
                                          color: Utils.greyColor,
                                          fontWeight: FontWeight.w500,
                                          size: 15.0),
                                      border: InputBorder.none),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${scriptArray.length}/20",
                                  style: Utils.fonts(
                                      size: 15.0,
                                      color: Utils.greyColor.withOpacity(0.7)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                thickness: 2,
                color: Colors.grey.withOpacity(0.5),
              ),
              scriptArray.length == 0
                  ? Column(
                      children: [
                        SizedBox(
                          height: 80,
                        ),
                        Container(
                          height: 190,
                          width: 200,
                          child: SvgPicture.asset(
                              "assets/appImages/basket/basket.svg"),
                        ),
                        Container(
                          height: 50,
                          width: 300,
                          child: Center(
                            child: Text(
                              "Your Basket is Empty. Add your favourite scrips using search bar on the top",
                              textAlign: TextAlign.center,
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w500,
                                  size: 15.0,
                                  color: Utils.greyColor),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ReorderableListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            children: getList(),
                            onReorder: (int oldIndex, int newIndex) {
                              setState(() {
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final String item1 =
                                    scriptArray.removeAt(oldIndex);
                                scriptArray.insert(newIndex, item1);
                              });
                            },
                          )
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  addData() async {
    for (var i = 0; i < scriptArray.length; i++) {
      if (scriptArray[i]["name"] == Dataconstants.searchModel.name &&
          scriptArray[i]["exch"] == Dataconstants.searchModel.exch) {
        CommonFunction.showBasicToast("Already Added");
        return;
      }
    }
    TextEditingController _textController = TextEditingController();
    FocusNode focusNode = FocusNode();
    var listArray = [];
    for (var i = 0; i < scriptArray.length; i++) {
      listArray.add({
        "name": scriptArray[i]["name"],
        "exch": scriptArray[i]["name"],
        "exchCode": scriptArray[i]["exchCode"],
        "exchCategory": scriptArray[i]["exchCategory"],
        "weight": scriptArray[i]["weight"],
        "locked": scriptArray[i]["locked"]
      });
    }

    var name = Dataconstants.searchModel.name.toString();
    var exch = Dataconstants.searchModel.exch.toString();
    var exchCode = Dataconstants.searchModel.exchCode.toString();
    var exchCategory = Dataconstants.searchModel.exchCategory.toString();
    var newJsons = {
      "name": name,
      "exch": exch,
      "exchCode": exchCode,
      "exchCategory": exchCategory,
      "weight": "0",
      "locked": false
    };

    listArray.add(newJsons);

    scriptArray.add({
      "name": name,
      "exch": exch,
      "exchCode": exchCode,
      "exchCategory": exchCategory,
      "weight": "0",
      "locked": false,
      "controller": _textController,
      "focus": focusNode
    });
    var scriptJson = jsonEncode(listArray);
    //print(scriptJson);
    var json = {
      "LoginID": Dataconstants.feUserID,
      "Operation": "UPDATE",
      "BasketId": widget.basketId,
      "Basketname": widget.basketName,
      "Basketscrips": "${scriptJson.toString()}"
    };
    log(json.toString());
    await CommonFunction.modifyBasket(json);
    // Navigator.pop(context);
    BasketController().fetchBasket();
    setState(() {});
  }

  modifyData() async {
    var listArray = [];
    for (var i = 0; i < scriptArray.length; i++) {
      listArray.add({
        "name": scriptArray[i]["name"],
        "exch": scriptArray[i]["exch"],
        "exchCode": scriptArray[i]["exchCode"],
        "exchCategory": scriptArray[i]["exchCategory"],
        "weight": scriptArray[i]["weight"],
        "locked": scriptArray[i]["locked"]
      });
    }

    var scriptJson = jsonEncode(listArray);
    //print(scriptJson);
    var json = {
      "LoginID": Dataconstants.feUserID,
      "Operation": "UPDATE",
      "BasketId": widget.basketId,
      "Basketname": widget.basketName,
      "Basketscrips": "${scriptJson.toString()}"
    };
    log(json.toString());
    await CommonFunction.modifyBasket(json);
    // Navigator.pop(context);
    BasketController().fetchBasket();
    setState(() {});
  }
}
