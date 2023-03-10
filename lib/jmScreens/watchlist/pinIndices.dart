import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../CommonWidgets/switch.dart';

class PinIndicesOnTop extends StatefulWidget {
  const PinIndicesOnTop({Key key}) : super(key: key);

  @override
  State<PinIndicesOnTop> createState() => _PinIndicesOnTopState();
}

class _PinIndicesOnTopState extends State<PinIndicesOnTop> {
  final _displayIndicesController = ValueNotifier<bool>(false);

  var indices = [];
  var displayIndices;

  @override
  void initState() {
    createIndices();
    _displayIndicesController.addListener(() {
      saveDisplayIndices();
      setState(() {
        Dataconstants.displayIndices = _displayIndicesController.value;
      });
    });
    super.initState();
  }

  saveDisplayIndices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("displayIndices", _displayIndicesController.value);
  }

  createIndices() async {
    for (var i = 0;
        i < Dataconstants.indicesMarketWatchListener.watchList.length;
        i++)
      indices.add(
          [Dataconstants.indicesMarketWatchListener.watchList[i].name, false]);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var finalValues = prefs.getString("pinnedIndices") ?? "";
    displayIndices = prefs.getBool("displayIndices") ?? false;
    _displayIndicesController.value = displayIndices;
    Dataconstants.displayIndices = displayIndices;
    if (finalValues != "") {
      List newValue = jsonDecode(finalValues);
      for (var i = 0; i < indices.length; i++) {
        if (newValue[i][1] == true)
          setState(() {
            indices[i][1] = true;
          });
      }
    }
  }

  var totalValue = 0;

  changeValue() async {
    setState(() {
      totalValue =
          indices.where((element) => element[1] == true).toList().length;
      //print(totalValue.toString());
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var finalValue = jsonEncode(indices);
    prefs.setString("pinnedIndices", finalValue);
  }

  checkIfSelected(index) {
    if (indices[index][1] == true) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pin Indices on Top",
          style: Utils.fonts(size: 16.0, color: Utils.blackColor),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Display Indices",
                      style: Utils.fonts(
                          size: 15.0,
                          color: Utils.blackColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    ToggleSwitch(
                        height: 22.0,
                        isBorder: false,
                        switchController: _displayIndicesController,
                        activeColor: Utils.primaryColor.withOpacity(0.5),
                        inactiveColor: Utils.greyColor.withOpacity(0.3),
                        thumbColor: _displayIndicesController.value == true
                            ? Utils.primaryColor
                            : Utils.greyColor)
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
                color: Utils.greyColor.withOpacity(0.2),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "You can select upto 6 Indices",
                    style: Utils.fonts(
                        size: 12.0,
                        color: Utils.greyColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Text(
                    "ALL",
                    style: Utils.fonts(
                        size: 14.0,
                        color: Utils.primaryColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Utils.primaryColor,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              for (var i = 0;
                  i < Dataconstants.indicesMarketWatchListener.watchList.length;
                  i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      var checkSelected = checkIfSelected(i);
                      if (totalValue < 6 || checkSelected) {
                        if (indices[i][1] == true) {
                          indices[i][1] = false;
                        } else {
                          indices[i][1] = true;
                        }
                        changeValue();
                      }
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              indices[i][0],
                              style: Utils.fonts(
                                  size: 15.0,
                                  color: indices[i][1] == true
                                      ? Utils.primaryColor
                                      : Utils.blackColor),
                            ),
                            Spacer(),
                            indices[i][1] == true
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
    );
  }
}
