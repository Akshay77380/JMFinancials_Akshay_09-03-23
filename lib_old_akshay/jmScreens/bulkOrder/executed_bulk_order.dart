import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/Utils.dart';
import 'edit_bulk_order.dart';

class executedBulkOrder extends StatefulWidget {

  @override
  State<executedBulkOrder> createState() => _executedBulkOrderState();
}

class _executedBulkOrderState extends State<executedBulkOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Container(
          height: 40,
          width: 170,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Edit Bulk Order",
                style: Utils.fonts(size:  16.0,fontWeight: FontWeight.w700, color: Utils.blackColor),
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => editBulkOrder(),
                      ),
                    );
                  },
                  child: SvgPicture.asset('assets/appImages/edit.svg')),
              InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        builder: (builder) {
                          return new Container(
                            height: 500.0,
                            color: Colors.transparent,
                            //could change this to Color(0xFF737373),
                            //so you don't have to change MaterialApp canvasColor
                            child: new Container(
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(10.0),
                                        topRight: const Radius.circular(10.0))),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                        Center(
                                          child: SvgPicture.asset(
                                            "assets/appImages/deleteWatchlist.svg",
                                            width: 200,
                                            height: 200,
                                          ),
                                        ),
                                        Text(
                                          "Delete RBI Policy",
                                          style: Utils.fonts(
                                              size: 20.0,
                                              color: Utils.blackColor
                                          ),
                                        ),
                                        // Text(
                                        //   // "Delete ${DataConstants.marketWatchListeners[index].watchListName.toString()}",
                                        //   style: Utils.fonts(size: 18.0),
                                        // ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Are you sure want to delete this Bulk Order?",
                                          style: Utils.fonts(
                                              size: 12.0,
                                              color: Utils.greyColor
                                                  .withOpacity(0.5)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             AddMoney("0", "Limits", "withdraw")));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 20.0),
                                                  child: Text(
                                                    "Cancel",
                                                    style: Utils.fonts(
                                                        size: 14.0,
                                                        color: Utils.greyColor,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(
                                                        Colors.white),
                                                    shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                50.0),
                                                            side: BorderSide(
                                                                color: Utils.greyColor))))),
                                            ElevatedButton(
                                                onPressed: () {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             AddMoney("0", "Limits", "add")));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 15.0,
                                                      horizontal: 20.0),
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          "assets/appImages/deleteWhite.svg"),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Delete",
                                                        style: Utils.fonts(
                                                            size: 14.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w400),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(Utils
                                                        .lightRedColor),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                        )))),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        });
                  },
                  child: SvgPicture.asset('assets/appImages/delete.svg'))
            ],
          ),
        ),
        actions: [
          SvgPicture.asset("assets/appImages/tranding.svg"),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity ,
                    decoration: BoxDecoration(
                        color: Utils.containerColor,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text("Current Value",
                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 11.0),
                              ),
                              SizedBox(height: 10,),
                              Text("15,43,657",
                                style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("Unrealised P/L",
                                style: Utils.fonts(fontWeight: FontWeight.w700, size: 11.0),
                              ),
                              SizedBox(height: 10,),
                              Text("15,43,657",
                                style: Utils.fonts(color: Utils.darkGreenColor,fontWeight: FontWeight.w500, size: 13.0),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                              color: Utils.containerColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: Container(height: 30, width: 30,child: Center(child: SvgPicture.asset('assets/appImages/search.svg')
                                )),
                                hintText: "Add Scrips",
                                border: InputBorder.none
                            ),
                          )
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Utils.containerColor
                        ),
                        child: SvgPicture.asset('assets/appImages/plus.svg', color: Utils.primaryColor,),
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
              thickness: 2,
              color: Colors.grey,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Container(
                  height: 450,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      itemCount: 10 ,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: InkWell(
                                  onTap: (){

                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7.0),
                                              color: Utils.lightGreenColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                "BUY",
                                                style: Utils.fonts(
                                                    fontWeight: FontWeight.w600, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: 5
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Text("IDEA", style: Utils.fonts(
                                            fontWeight: FontWeight.w700,
                                            size : 16.0,
                                          ),),
                                          Row(
                                            children: [
                                              Text("1 @ 13.95", style: Utils.fonts(
                                                fontWeight: FontWeight.w700,
                                                size : 16.0,
                                              ),),

                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: 5
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Text("NSE . MIS", style: Utils.fonts(
                                            fontWeight: FontWeight.w700,
                                            color: Utils.greyColor.withOpacity(0.5),
                                            size : 11.0,
                                          ),),
                                          Row(
                                            children: [
                                              Text("LTP", style: Utils.fonts(
                                                fontWeight: FontWeight.w700,
                                                color: Utils.greyColor.withOpacity(0.5),
                                                size : 11.0,
                                              ),),
                                              Text("13.20", style: Utils.fonts(
                                                fontWeight: FontWeight.w700,
                                                color: Utils.greyColor.withOpacity(0.9),
                                                size : 11.0,
                                              ),),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: RotatedBox(
                                                  quarterTurns: 2,
                                                  child: SvgPicture.asset('assets/appImages/inverted_rectangle.svg', color: Utils.brightRedColor,),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.grey,
                            )
                          ],
                        );
                      }),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label:  Text('Square Off', style: Utils.fonts(color: Colors.blue),),
        backgroundColor: Color(0xffe6efff),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {

              },
              child: Container(
                height: 40,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                ),
                child: Center(
                    child: Text("Reset Basket",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w600,
                            size: 13.0,
                            color: Colors.black))),
              ),
            ),
            InkWell(
              onTap: () {

              },
              child: Container(
                height: 40,
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.blueAccent.withOpacity(0.9),
                ),
                //
                child: Center(
                    child: Text(
                      "Execute",
                      style: Utils.fonts(
                          fontWeight: FontWeight.w600,
                          size: 13.0,
                          color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}