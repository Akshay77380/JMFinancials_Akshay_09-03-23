import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../database/watchlist_database.dart';
import '../../model/scrip_info_model.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class EditWatchList extends StatefulWidget {
  var id;

  EditWatchList(this.id);

  @override
  State<EditWatchList> createState() => _EditWatchListState();
}

class _EditWatchListState extends State<EditWatchList> {
  var selectedArray = [];
  var allSelected = false;
  List<ScripInfoModel> _editableWatchList = [];
  var selectedScripts = 0;

  @override
  void initState() {
    _editableWatchList =
        Dataconstants.marketWatchListeners[widget.id].watchList.toList();
    CommonFunction.getDefault();
    for (var i = 0; i < _editableWatchList.length; i++)
      selectedArray.add(false);
    super.initState();
  }

  checkSelected() {
    setState(() {
      selectedScripts =
          selectedArray.where((element) => element == true).toList().length;
    });
  }

  final FocusNode myFocusNodeRenameWatchlist = FocusNode();
  TextEditingController renameWatchListController = TextEditingController();
  var renamedWatchlist = "";

  renameWatchList(index) {
    renameWatchListController.text = "";
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
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Rename ${WatchlistDatabase.allWatchlist[index]["watchListName"].toString()}",
                                style: Utils.fonts(size: 18.0),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextField(
                                maxLength: 15,
                                controller: renameWatchListController,
                                focusNode: myFocusNodeRenameWatchlist,
                                showCursor: true,
                                onChanged: (value) {
                                  setState(() {
                                    renamedWatchlist = value;
                                  });
                                },
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
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
                                  labelText: "Watchlist Name",
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
                                        await WatchlistDatabase.instance
                                            .updateWatchListName(
                                                WatchlistDatabase
                                                        .allWatchlist[index]
                                                    ["watchListNo"],
                                                renamedWatchlist);

                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0),
                                        child: Text(
                                          "Save",
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 5.0, top: 10.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Utils.greyColor,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        WatchlistDatabase.allWatchlist[widget.id]
                                ["watchListName"]
                            .toString(),
                        style: Utils.fonts(color: Utils.blackColor, size: 16.0),
                      ),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      // InkWell(
                      //   onTap: () {},
                      //   child: Center(
                      //     child: Icon(
                      //       Icons.edit,
                      //       color: Utils.greyColor.withOpacity(0.5),
                      //       size: 20.0,
                      //     ),
                      //   ),
                      // ),
                      Spacer(),
                      InkWell(
                        onTap: () async {
                          if (Dataconstants.defaultWatchList != widget.id) {
                            await CommonFunction.setDefault(widget.id);
                          } else {
                            await CommonFunction.unSetDefault(widget.id);
                          }
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              border: Border.all(color: Utils.greyColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            children: [
                              Dataconstants.defaultWatchList != widget.id
                                  ? Icon(
                                      Icons.star_border_outlined,
                                      size: 20,
                                      color: Utils.greyColor,
                                    )
                                  : Icon(
                                      Icons.star,
                                      size: 20,
                                      color: Utils.darkyellowColor,
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Set Default",
                                style: Utils.fonts(
                                    size: 13.0, color: Utils.greyColor),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                )
              ],
            ),
          ),
        ),
        body: ReorderableListView(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          children: <Widget>[
            for (int i = 0; i < _editableWatchList.length; i++)
              InkWell(
                key: Key('$i'),
                onTap: () {
                  if (selectedArray[i] != true)
                    setState(() {
                      selectedArray[i] = true;
                      checkSelected();
                    });
                  else
                    setState(() {
                      selectedArray[i] = false;
                      checkSelected();
                    });
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 5.0,
                  ),
                  child: Column(key: Key('$i'),
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _editableWatchList[i].name.toString(),
                                style: Utils.fonts(
                                    size: 16.0,
                                    fontWeight: FontWeight.w500,
                                    color: selectedArray[i] == true
                                        ? Utils.primaryColor
                                        : Utils.blackColor),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FittedBox(
                                child: Row(
                                  children: [
                                    /* Displaying the Script exchange Name */
                                    // Text(_editableWatchList[i].desc.toString()),
                                    if(_editableWatchList[i].exchCategory == ExchCategory.nseEquity||
                                        _editableWatchList[i].exchCategory == ExchCategory.bseEquity)
                                      Text( _editableWatchList[i].exchName.toString(),
                                          style: Utils.fonts(
                                              size: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Utils.greyColor)
                                        // style: const TextStyle(
                                        //     fontSize: 13, color: Colors.grey),
                                      ),
                                    if(_editableWatchList[i].exchCategory == ExchCategory.nseFuture||
                                        _editableWatchList[i].exchCategory == ExchCategory.mcxFutures||
                                        _editableWatchList[i].exchCategory == ExchCategory.currenyFutures||
                                        _editableWatchList[i].exchCategory == ExchCategory.bseCurrenyFutures)
                                        Text( _editableWatchList[i].desc.toString()
                                            .toUpperCase()
                                            .split(" ")[1]       //getDesc(i)??"",
                                            + " " + _editableWatchList[i].desc.toString()
                                            .toUpperCase()
                                            .split(" ")[2] + " " + _editableWatchList[i].desc.toString()
                                            .toUpperCase()
                                            .split(" ")[3],
                                            style: Utils.fonts(
                                                size: 12.0,
                                                fontWeight: FontWeight.w500,
                                                color: Utils.greyColor)
                                          // style: const TextStyle(
                                          //     fontSize: 13, color: Colors.grey),
                                        ),
                                    if(_editableWatchList[i].exchCategory == ExchCategory.nseOptions||
                                        _editableWatchList[i].exchCategory == ExchCategory.mcxOptions||
                                        _editableWatchList[i].exchCategory == ExchCategory.currenyOptions||
                                        _editableWatchList[i].exchCategory == ExchCategory.bseCurrenyOptions)
                                      RichText(
                                        text: TextSpan(
                                          text: _editableWatchList[i].desc.toString()
                                              .toUpperCase()
                                              .split(" ")[1]       //getDesc(i)??"",
                                              + " " + _editableWatchList[i].desc.toString()
                                              .toUpperCase()
                                              .split(" ")[2] + " " + _editableWatchList[i].desc.toString()
                                              .toUpperCase()
                                              .split(" ")[5],
                                          style:Utils.fonts(
                                              size: 12.0,
                                              fontWeight: FontWeight.w500,
                                              color: Utils.greyColor),
                                          children:  <TextSpan>[
                                            TextSpan(text:" "+ _editableWatchList[i].desc.toString().toUpperCase().split(" ")[4],
                                                style: Utils.fonts(
                                                    size: 12.0,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                    _editableWatchList[i].desc.toString().toUpperCase().split(" ")[4]=="CE"?Utils.mediumGreenColor:
                                                    Utils.mediumRedColor
                                                ),),
                                          ],
                                        ),
                                      ),

                                  //   Text( getDesc(i)??"",
                                  //       style: Utils.fonts(
                                  //           size: 12.0,
                                  //           fontWeight: FontWeight.w500,
                                  //           color: Utils.greyColor)
                                  //     // style: const TextStyle(
                                  //     //     fontSize: 13, color: Colors.grey),
                                  //   ),
                                    // if (_editableWatchList[i].exchCategory !=
                                    //     ExchCategory.nseEquity &&
                                    //     _editableWatchList[i].exchCategory !=
                                    //         ExchCategory.bseEquity)
                                    //   orderTagging(
                                    //       _editableWatchList[i].exchCategory,
                                    //       getWhichOption(i).toString()
                                    //   ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                          Spacer(),
                          selectedArray[i] == true
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
                      Divider(
                        thickness: 1.5,
                      ),
                    ],
                  ),
                ),
              )
          ],
          onReorder: (int oldIndex, int newIndex) {

              // setState(() {
              //   if(newIndex > oldIndex){
              //     newIndex = newIndex-1;
              //   }
              // });
              // final task = tasks.removeAt(oldIndex);
              // tasks.insert(newIndex, task);

              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              var item = _editableWatchList.removeAt(oldIndex);
              _editableWatchList.insert(newIndex, item);

          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (allSelected != true) {
                      for (var i = 0; i < selectedArray.length; i++) {
                        selectedArray[i] = true;
                      }
                      setState(() {
                        allSelected = true;
                        checkSelected();
                      });
                    } else {
                      for (var i = 0; i < selectedArray.length; i++) {
                        selectedArray[i] = false;
                      }
                      setState(() {
                        allSelected = false;
                        checkSelected();
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: Row(
                      children: [
                        allSelected
                            ? SvgPicture.asset(
                                "assets/appImages/selectedCircle.svg",
                                height: 20,
                                width: 20,
                              )
                            : SvgPicture.asset(
                                "assets/appImages/unselectedRadio.svg"),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          allSelected ? "Unselect All" : "Select All",
                          style: Utils.fonts(
                              size: 14.0,
                              color: Utils.greyColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: BorderSide(color: Utils.greyColor))))),
              selectedScripts == 0
                  ? ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          children: [
                            Text(
                              "Delete",
                              style: Utils.fonts(
                                  size: 14.0,
                                  color: Utils.greyColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
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
                                          BorderSide(color: Utils.greyColor)))))
                  : ElevatedButton(
                      onPressed: () {
                        var selectedIndex = [];
                        for (var j = 0; j < selectedArray.length; j++) {
                          if (selectedArray[j] == true) {
                            selectedIndex.add([_editableWatchList[j], j]);
                          }
                        }
                        for (var k = 0; k < selectedIndex.length; k++) {
                          _editableWatchList.remove(selectedIndex[k][0]);
                        }
                        selectedArray.removeWhere((element) => element == true);
                        selectedScripts =
                            selectedScripts - selectedIndex.length;
                        Dataconstants.marketWatchListeners[widget.id]
                            .updateWatchList(_editableWatchList);
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                "assets/appImages/deleteWhite.svg"),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Delete (${selectedScripts.toString()})",
                              style: Utils.fonts(
                                  size: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Utils.lightRedColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )))),
            ],
          ),
        ));
  }
  getDesc(i) {
    var desc;
    var finalDesc;
    if (
    _editableWatchList[i].exchCategory == ExchCategory.nseFuture||
        _editableWatchList[i].exchCategory == ExchCategory.mcxFutures||
        _editableWatchList[i].exchCategory == ExchCategory.currenyFutures||
        _editableWatchList[i].exchCategory == ExchCategory.bseCurrenyFutures


    //DataConstants.marketWatchListeners[watchlistNo].watchList[index].exchCategory ==ExchCategory.mcxFutures||
    //         // DataConstants.marketWatchListeners[watchlistNo].watchList[index].exchCategory ==ExchCategory.mcxOptions||
    //         DataConstants.marketWatchListeners[watchlistNo].watchList[index].exchCategory ==ExchCategory.currenyFutures||
    //         // DataConstants.marketWatchListeners[watchlistNo].watchList[index].exchCategory ==ExchCategory.currenyOptions||
    //         DataConstants.marketWatchListeners[watchlistNo].watchList[index].exchCategory ==ExchCategory.bseCurrenyFutures
    //     // || DataConstants.marketWatchListeners[watchlistNo].watchList[index].exchCategory ==ExchCategory.bseCurrenyOptions

    ) {
      desc = _editableWatchList[i].desc.toString().toUpperCase().split(" ");
      finalDesc = desc[1] + " " + desc[2];
    } else if (
    _editableWatchList[i].exchCategory == ExchCategory.nseOptions||
        _editableWatchList[i].exchCategory == ExchCategory.mcxOptions||
        _editableWatchList[i].exchCategory == ExchCategory.currenyOptions||
        _editableWatchList[i].exchCategory == ExchCategory.bseCurrenyOptions
    ) {
      desc = _editableWatchList[i].desc.toString().toUpperCase().split(" ");
      finalDesc =
          desc[1] + " " + desc[2] + " " + desc[5];//.toString().split(".").first
    } else {

      finalDesc = _editableWatchList[i].exchName??""; //.toString().toUpperCase()
    }

    return finalDesc;
  }

  // getDesc(i) {
  //   var desc;
  //   var finalDesc;
  //   if (_editableWatchList[i].exchCategory == ExchCategory.nseFuture) {
  //     desc = _editableWatchList[i].desc.toString().toUpperCase().split(" ");
  //     finalDesc = desc[1] + " " + desc[2];
  //   } else if (_editableWatchList[i].exchCategory == ExchCategory.nseOptions) {
  //     desc = _editableWatchList[i].desc.toString().toUpperCase().split(" ");
  //     finalDesc =
  //         desc[1] + " " + desc[2] + " " + desc[5].toString().split(".").first;
  //   } else {
  //     finalDesc = _editableWatchList[i].exchName.toString().toUpperCase();
  //   }
  //
  //   return finalDesc;
  // }

  getWhichOption(i) {
    var desc;
    var whichOption;
    if (_editableWatchList[i].exchCategory == ExchCategory.nseFuture) {
      desc = _editableWatchList[i].desc.toString().toUpperCase().split(" ");
    } else if (_editableWatchList[i].exchCategory == ExchCategory.nseOptions) {
      desc = _editableWatchList[i].desc.toString().toUpperCase().split(" ");
      whichOption = desc[4];
    }

    return whichOption;
  }

  editListData() {
    var desc;
    var finalDesc;
    var whichOption;
    var listDatas = <Widget>[];
    for (var i = 0; i < _editableWatchList.length; i++) {
      if (_editableWatchList[i].exchCategory == ExchCategory.nseFuture) {
        desc = _editableWatchList[i].desc.toString().toUpperCase().split(" ");
        finalDesc = desc[1] + " " + desc[2];
      } else if (_editableWatchList[i].exchCategory ==
          ExchCategory.nseOptions) {
        desc = _editableWatchList[i].desc.toString().toUpperCase().split(" ");
        whichOption = desc[4];
        finalDesc =
            desc[1] + " " + desc[2] + " " + desc[5].toString().split(".").first;
      } else {
        finalDesc = _editableWatchList[i].exchName.toString().toUpperCase();
      }
      listDatas.add(InkWell(
        onTap: () {
          if (selectedArray[i] != true)
            setState(() {
              selectedArray[i] = true;
              checkSelected();
            });
          else
            setState(() {
              selectedArray[i] = false;
              checkSelected();
            });
        },
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 5.0,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editableWatchList[i].name.toString(),
                        style: Utils.fonts(
                            size: 16.0,
                            fontWeight: FontWeight.w500,
                            color: selectedArray[i] == true
                                ? Utils.primaryColor
                                : Utils.blackColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            /* Displaying the Script exchange Name */
                            Text(finalDesc,
                                style: Utils.fonts(
                                    size: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: Utils.greyColor)
                                // style: const TextStyle(
                                //     fontSize: 13, color: Colors.grey),
                                ),
                            if (_editableWatchList[i].exchCategory !=
                                    ExchCategory.nseEquity &&
                                _editableWatchList[i].exchCategory !=
                                    ExchCategory.bseEquity)
                              orderTagging(_editableWatchList[i].exchCategory,
                                  whichOption),

                            const SizedBox(
                              width: 4,
                            ),
                            /* Displaying the Script Description */
                            // Text(
                            //     Dataconstants
                            //         .marketWatchListeners[
                            //             widget.watchlistNo]
                            //         .watchList[index]
                            //         .marketWatchDesc
                            //         .toUpperCase(),
                            //     style: Utils.fonts(
                            //       size: 12.0,
                            //       fontWeight: FontWeight.w500,
                            //       color: Utils.greyColor,
                            //     )
                            //     // style: const TextStyle(
                            //     //   fontSize: 13,
                            //     //   color: Colors.grey,
                            //     // ),
                            //     ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                  Spacer(),
                  selectedArray[i] == true
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
              Divider(
                thickness: 1.5,
              ),
            ],
          ),
        ),
      ));
    }
    return listDatas;
  }

  orderTagging(exchCategory, whichOption) {
    if (exchCategory == ExchCategory.nseFuture)
      return Text(
        " FUT",
        style: Utils.fonts(
            size: 12.0, fontWeight: FontWeight.w400, color: Utils.primaryColor),
      );
    else if (whichOption == "PE")
      return Text(
        " PE",
        style: Utils.fonts(
            size: 12.0,
            fontWeight: FontWeight.w400,
            color: Utils.mediumRedColor),
      );
    if (whichOption == "CE")
      return Text(
        " CE",
        style: Utils.fonts(
            size: 12.0,
            fontWeight: FontWeight.w400,
            color: Utils.mediumGreenColor),
      );
  }
}
