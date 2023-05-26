import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/topPerformingIndustries.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';

class TopPerformingIndustriesPage extends StatefulWidget {
  const TopPerformingIndustriesPage({Key key}) : super(key: key);

  @override
  State<TopPerformingIndustriesPage> createState() => _TopPerformingIndustriesPageState();
}

class _TopPerformingIndustriesPageState extends State<TopPerformingIndustriesPage> {

  bool topPerformingIndustriesExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
              "Top Performing Industries",
              style: Utils.fonts(
              size: 20.0,
                color:Utils.blackColor
          )

          )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Obx(() {
                    return TopPerformingIndustriesController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : TopPerformingIndustriesController.getTopPerformingIndustriesListItems.isEmpty
                        ? Text("No Data available")
                        : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: TopPerformingIndustriesController.getTopPerformingIndustriesListItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].sectorName,
                                    overflow: TextOverflow.clip,
                                    style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].deliveryPerChange * 0.09 >= MediaQuery.of(context).size.height * 0.15 ? MediaQuery.of(context).size.height * 0.15 : (TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].deliveryPerChange * 0.08).abs(),
                                        // width: MediaQuery.of(context).size.height * 0.15,
                                        decoration:
                                        BoxDecoration(color: TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].deliveryPerChange >= 0 ? Utils.lightGreenColor : Utils.lightRedColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15.0), bottomRight: Radius.circular(15.0))),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].deliveryPerChange.toStringAsFixed(2)}%",
                                  style: Utils.fonts(size: 14.0, color: TopPerformingIndustriesController.getTopPerformingIndustriesListItems[index].deliveryPerChange >= 0 ? Utils.lightGreenColor : Utils.lightRedColor, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        });
                  })
                ],
              ),
            ),
            Container(
              height: 4.0,
              width: MediaQuery.of(context).size.width,
              color: Utils.greyColor.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
