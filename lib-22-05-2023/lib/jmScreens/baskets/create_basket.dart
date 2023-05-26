import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/scrip_info_model.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import 'view_basket_after_buying.dart';

class createBasket extends StatefulWidget {
  @override
  State<createBasket> createState() => _createBasketState();
}

class _createBasketState extends State<createBasket> {
  var basketValue;

  ScripInfoModel temp =
      CommonFunction.getScripDataModel(exchCode: 12, exch: 'N');

  List<MainData> globalArray = [];
  TextEditingController _basketController = TextEditingController();

  // getData() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   var entry = prefs.getString("Entry");
  //   if (entry != "") {
  //     globalArray = json.decode(entry);
  //   }
  //   setState(() {});
  // }

  @override
  void initState() {
    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(globalArray[0].toString());
    if (globalArray[0] != null) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Baskets",
                style: Utils.fonts(fontWeight: FontWeight.w700)),
            actions: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      context: context,
                      builder: (context) {
                        return DraggableScrollableSheet(
                            expand: false,
                            minChildSize: 0.3,
                            initialChildSize: 0.5,
                            maxChildSize: 0.50,
                            builder: (context, scrollController) {
                              return DotExpand1();
                            });
                      }).then((value) {
                    setState(() {});
                  });
                },
                child: Icon(
                  Icons.more_vert,
                  color: Utils.greyColor,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 750,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: globalArray.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  viewBasketAfterBuying(this.globalArray),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      globalArray[index]._basketName.toString(),
                                      style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 13.0),
                                    ),
                                    // Text("BasketName", style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),),
                                    Container(
                                        height: 15,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Text(
                                          // globalArray[index]["scripts"].length.toString()+" Scrips",
                                          globalArray[0]
                                                  .scripsData
                                                  .length
                                                  .toString() +
                                              " Scrips",
                                          style: Utils.fonts(
                                              fontWeight: FontWeight.w500,
                                              size: 11.0),
                                        )))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      child: Text(
                                        "Basket Value: 10,222",
                                        style: Utils.fonts(
                                            fontWeight: FontWeight.w500,
                                            size: 11.0,
                                            color: Utils.greyColor),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ));
    } else {
      // return Basket();
    }
  }

  Widget DotExpand1() {
    return Padding(
      padding: EdgeInsets.only(
          top: 10,
          left: 5,
          right: 5,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          Row(
            children: [
              Text(
                "New Bulk Order",
                style: Utils.fonts(color: Utils.blackColor, size: 16.0),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: _basketController,
            decoration: InputDecoration(
              labelText: 'Label text',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 34, vertical: 10),
              child: Center(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(
                                color: Utils.greyColor.withOpacity(0.7))),
                        child: Center(
                            child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Utils.greyColor.withOpacity(0.8),
                              fontSize: 20),
                        )),
                      ),
                    ),
                    // Spacer(flex: 1),
                    SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        // MainData(_bulkOrderController.text, <ScriptsData>[]);
                        globalArray.add(MainData(
                            _basketController.text, [ScriptsData("ndfeilfh")]));
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            "Create",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MainData {
  String _basketName;

  List<ScriptsData> scripsData;

  MainData(this._basketName, this.scripsData);
}

class ScriptsData {
  String _scriptsName;

  //  exch_code
  // exch_name
  //  weightage

  ScriptsData(this._scriptsName);
}
