import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Connection/News/NewsClient.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class News extends StatefulWidget {

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {

  @override
  void initState() {

    Dataconstants.newsClient = NewsClient.getInstance();
    Dataconstants.newsClient.connect();
    // TODO: implement initState
    super.initState();
  }

  static Color categoryColor(String category) {
    switch (category) {
      case 'Stocks':
        return Colors.lightBlue;
      case 'Commentary':
        return Colors.pink;
      case 'Global':
        return Colors.deepOrange;
      case 'Block Details':
        return Colors.blue;
      case 'Result':
        return Colors.purple;
      case 'Commodities':
        return Colors.amber;
      case 'Fixed income':
        return Colors.lightGreen;
      case 'Special Coverage':
        return Colors.teal;
      default:
        return Colors.lightBlue;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "News",
                    style: Utils.fonts(size: 17.0, color: Utils.blackColor),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  InkWell(
                      onTap: () {
                        // HomeWidgets.scrollTop();
                      },
                      child: SvgPicture.asset("assets/appImages/markets/up_arrow.svg"))
                ],
              ),
              SizedBox(
                height: 600,
                child: Observer(
                    builder: (context) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: Dataconstants.todayNews.filteredNews.length,
                        itemBuilder: (context, index) => InkWell(
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (Dataconstants.todayNews.filteredNews[index].staticModel != null)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        Dataconstants.todayNews.filteredNews[index].staticModel.name,
                                        style: Utils.fonts(
                                          size: 16.0,
                                          color: Utils.blackColor,
                                        ),
                                      ),
                                    ),
                                  if (Dataconstants.todayNews.filteredNews[index].staticModel != null)
                                    SizedBox(
                                      height: 10,
                                    ),
                                  Text(
                                    Dataconstants.todayNews.filteredNews[index].description,
                                    style: Utils.fonts(size: 13.0, color: Utils.blackColor, fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(0),
                                        color: categoryColor(Dataconstants.todayNews.filteredNews[index].category).withOpacity(0.2),
                                        child: Text(
                                          Dataconstants.todayNews.filteredNews[index].category,
                                          style: Utils.fonts(size: 14.0, color: categoryColor(Dataconstants.todayNews.filteredNews[index].category)),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.schedule,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            Dataconstants.todayNews.filteredNews[index].newsTime,
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                          onTap: Dataconstants.todayNews.filteredNews[index].staticModel == null
                              ? null
                              : () {
                            // ScripInfoModel tempModel = CommonFunction.getScripDataModel(
                            //     exch: Dataconstants.todayNews.filteredNews[index].staticModel.exch, exchCode: Dataconstants.todayNews.filteredNews[index].staticModel.exchCode, getNseBseMap: true);
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => ScriptInfo(
                            //       tempModel,
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                      );
                    }
                ),
              ),
              // for (var i = 0; i < 4; i++)
              //   Column(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 10.0),
              //         child: Row(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             SvgPicture.asset("assets/appImages/dashboard/Ellipse 503.svg"),
              //             SizedBox(
              //               width: 10,
              //             ),
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Text(
              //                     "Adani Green Energy net profit rises 14% to Rs 49 cr ",
              //                     style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
              //                   ),
              //                   SizedBox(
              //                     height: 10,
              //                   ),
              //                   Row(
              //                     children: [
              //                       Text(
              //                         "Moneycontrol",
              //                         style: Utils.fonts(size: 12.0, color: Utils.primaryColor, fontWeight: FontWeight.w500),
              //                       ),
              //                       Spacer(),
              //                       Text(
              //                         "2 Hours Ago",
              //                         style: Utils.fonts(size: 12.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
              //                       )
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Divider(
              //         thickness: 2,
              //       )
              //     ],
              //   )
            ],
          ),
        ),
        Container(
          height: 4.0,
          width: MediaQuery.of(context).size.width,
          color: Utils.greyColor.withOpacity(0.2),
        ),
      ],
    );
  }
}
