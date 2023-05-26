import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/CircuitBreakersController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';

class CircuitBreakersPage extends StatefulWidget {
  const CircuitBreakersPage({Key key}) : super(key: key);

  @override
  State<CircuitBreakersPage> createState() => _CircuitBreakersPageState();
}

class _CircuitBreakersPageState extends State<CircuitBreakersPage> {

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
                    return CircuitBreakersController.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : CircuitBreakersController.getUpperCktListItems.isEmpty
                        ? Text("No Data available")
                        : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: CircuitBreakersController.getUpperCktListItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    CircuitBreakersController.getUpperCktListItems[index].toString(),
                                    overflow: TextOverflow.clip,
                                    style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  "${CircuitBreakersController.getUpperCktListItems[index].toString()}%",
                                  style: Utils.fonts(size: 14.0, color: CircuitBreakersController.getUpperCktListItems[index] >= 0 ? Utils.lightGreenColor : Utils.lightRedColor, fontWeight: FontWeight.w500),
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
