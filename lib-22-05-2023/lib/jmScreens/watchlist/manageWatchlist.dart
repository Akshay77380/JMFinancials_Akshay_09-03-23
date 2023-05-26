import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../database/watchlist_database.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'EditWatchlist.dart';

class ManageWatchlist extends StatefulWidget {
  const ManageWatchlist({Key key}) : super(key: key);

  @override
  State<ManageWatchlist> createState() => _ManageWatchlistState();
}

class _ManageWatchlistState extends State<ManageWatchlist> {
  var allWatchlist = [];
  var isChanged = false;

  @override
  void initState() {
    allWatchlist = WatchlistDatabase.allWatchlist;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Watchlists",
          style: Utils.fonts(size: 18.0, color: Utils.blackColor),
        ),
        leading: InkWell(
            onTap: () {
              if (isChanged)
                WatchlistDatabase.instance.replaceAllWatchList(allWatchlist);
              Navigator.pop(context);
              return false;
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              ReorderableListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return Card(
                      color: Utils.whiteColor,
                      key: ValueKey(allWatchlist[i]["watchListNo"]),
                      child: ListTile(
                        onTap: () {
                          if (allWatchlist[i]["watchListName"].toString() ==
                              "Holdings") {
                            CommonFunction.CustomToast(
                                Icons.cancel, "Cannot Edit Holdings", false);
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditWatchList(i)));
                        },
                        leading: Icon(Icons.reorder),
                        title: Row(
                          children: [
                            Text(
                              allWatchlist[i]["watchListName"].toString(),
                              style: Utils.fonts(
                                  fontWeight: FontWeight.w600,
                                  color: Utils.greyColor),
                            ),
                            Spacer(),
                            if (Dataconstants.defaultWatchList == i)
                              SvgPicture.asset(
                                  "assets/appImages/starFilled.svg"),
                            SizedBox(
                              width: 15,
                            ),
                            allWatchlist[i]["watchListName"].toString() ==
                                    "Holdings"
                                ? SizedBox(
                                    width: 20,
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.pop(context, '$i-1');
                                      // DataConstants.toBeDeletedWatchList = i;
                                      // return true;
                                    },
                                    child: SvgPicture.asset(
                                        "assets/appImages/edit.svg")),
                            SizedBox(
                              width: 15,
                            ),
                            allWatchlist[i]["watchListName"].toString() ==
                                    "Holdings"
                                ? SizedBox(
                                    width: 20,
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.pop(context, '$i-2');
                                      // DataConstants.toBeDeletedWatchList = i;
                                    },
                                    child: SvgPicture.asset(
                                        "assets/appImages/delete.svg")),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: WatchlistDatabase.allWatchlist.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex = newIndex - 1;
                      }
                      final element = allWatchlist.removeAt(oldIndex);
                      allWatchlist.insert(newIndex, element);
                      isChanged = true;
                    });
                  }),
              // for (var i = 0; i < WatchlistDatabase.allWatchlist.length; i++)
              //   InkWell(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => EditWatchList(i)))
              //           .then((value) {
              //         setState(() {});
              //       });
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(
              //           horizontal: 16.0, vertical: 10.0),
              //       child: Column(
              //         children: [
              //           Row(
              //             children: [
              //               Text(
              //                 WatchlistDatabase.allWatchlist[i]["watchListName"]
              //                     .toString(),
              //                 style: Utils.fonts(
              //                     fontWeight: FontWeight.w600,
              //                     color: Utils.greyColor),
              //               ),
              //               Spacer(),
              //               if (DataConstants.defaultWatchList == i)
              //                 SvgPicture.asset("assets/appImages/starFilled.svg"),
              //               SizedBox(
              //                 width: 15,
              //               ),
              //               InkWell(
              //                   onTap: () {
              //                     Navigator.pop(context, '$i-1');
              //                     // DataConstants.toBeDeletedWatchList = i;
              //                     // return true;
              //                   },
              //                   child: SvgPicture.asset(
              //                       "assets/appImages/edit.svg")),
              //               SizedBox(
              //                 width: 15,
              //               ),
              //               InkWell(
              //                   onTap: () {
              //                     Navigator.pop(context, '$i-2');
              //                     // DataConstants.toBeDeletedWatchList = i;
              //                   },
              //                   child: SvgPicture.asset(
              //                       "assets/appImages/delete.svg")),
              //             ],
              //           ),
              //           SizedBox(
              //             height: 15,
              //           ),
              //           Container(
              //             height: 1,
              //             width: double.maxFinite,
              //             color: Utils.greyColor.withOpacity(0.3),
              //           )
              //         ],
              //       ),
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
  }
}
