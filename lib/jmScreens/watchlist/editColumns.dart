import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';

class EditColumns extends StatefulWidget {
  const EditColumns({Key key}) : super(key: key);

  @override
  State<EditColumns> createState() => _EditColumnsState();
}

class _EditColumnsState extends State<EditColumns> {
  var columns = [
    ["Bid", false],
    ["Bid Qty", false],
    ["Ask Qty", false],
    ["Ask", false],
    ["Volume", false],
    ["Day High", false],
    ["Day Low", false],
    ["Price to Earnings", false],
    ["Price to Book Value", false],
    ["EPS", false],
  ];

  var totalValue = 0;

  changeValue() {
    setState(() {
      totalValue =
          columns.where((element) => element[1] == true).toList().length;
      //print(totalValue.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getColumns();
  }

  getColumns() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var finalValues = prefs.getString("editColumns") ?? "";
    if (finalValues != "") {
      List newValue = jsonDecode(finalValues);
      for (var i = 0; i < newValue.length; i++) {
        if (newValue[i][1] == true)
          setState(() {
            columns[i][1] = true;
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Columns",
            style: Utils.fonts(size: 16.0, color: Utils.blackColor),
          ),
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "You can add upto 8 columns in Landscape Watchlist",
                  style: Utils.fonts(
                      size: 12.0,
                      color: Utils.greyColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8.0,
                ),
                for (var i = 0; i < columns.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        if (columns[i][1] == true) {
                          columns[i][1] = false;
                        } else {
                          columns[i][1] = true;
                        }
                        changeValue();
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                columns[i][0],
                                style: Utils.fonts(
                                    size: 15.0,
                                    color: columns[i][1] == true
                                        ? Utils.primaryColor
                                        : Utils.blackColor),
                              ),
                              Spacer(),
                              columns[i][1] == true
                                  ? SvgPicture.asset(
                                      "assets/appImages/selectedCircle.svg",
                                      height: 20,
                                      width: 20,
                                    )
                                  : SvgPicture.asset(
                                      "assets/appImages/unselectedRadio.svg",
                                      height: 20,
                                      width: 20,
                                    )
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Divider(
                            thickness: 1,
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
            boxShadow: kElevationToShadow[2],
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
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
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    side:
                                        BorderSide(color: Utils.greyColor))))),
                ElevatedButton(
                    onPressed: () async {
                      if (totalValue == 0) {
                        CommonFunction.showBasicToast("Please Select The Columns");
                        return;
                      }

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var finalValue = jsonEncode(columns);
                      prefs.setString("editColumns", finalValue);
                      CommonFunction.CustomToast(
                          Icons.save_as, "Columns Saved", false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      child: Text(
                        "Save Columns",
                        style: Utils.fonts(
                            size: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Utils.primaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )))),
              ],
            ),
          ),
        ));
  }
}
