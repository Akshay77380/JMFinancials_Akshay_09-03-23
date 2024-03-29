import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

import '../../Connection/News/NewsClient.dart';
import '../../model/scrip_info_model.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../ScriptInfo/ScriptInfo.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  void initState() {
    // Dataconstants.newsClient = NewsClient.getInstance();
    // Dataconstants.newsClient.connect();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
            "News"
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 103,
          child: Observer(builder: (context) {
            return ListView.builder(
              // shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: Dataconstants.todayNews.filteredNews.length,
              itemBuilder: (context, index) => InkWell(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
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
                                padding: EdgeInsets.all(4),
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
                    ),
                    Divider(),
                  ],
                ),
                onTap: Dataconstants.todayNews.filteredNews[index].staticModel == null
                    ? null
                    : () {
                  ScripInfoModel tempModel = CommonFunction.getScripDataModel(
                      exch: Dataconstants.todayNews.filteredNews[index].staticModel.exch, exchCode: Dataconstants.todayNews.filteredNews[index].staticModel.exchCode, getNseBseMap: true);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScriptInfo(
                        tempModel, false,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),

        // Column(
        //   children: [
        //
        //
        //     // for (var i = 0; i < 4; i++)
        //     //   Column(
        //     //     children: [
        //     //       Padding(
        //     //         padding: const EdgeInsets.symmetric(vertical: 10.0),
        //     //         child: Row(
        //     //           crossAxisAlignment: CrossAxisAlignment.start,
        //     //           children: [
        //     //             SvgPicture.asset("assets/appImages/dashboard/Ellipse 503.svg"),
        //     //             SizedBox(
        //     //               width: 10,
        //     //             ),
        //     //             Expanded(
        //     //               child: Column(
        //     //                 children: [
        //     //                   Text(
        //     //                     "Adani Green Energy net profit rises 14% to Rs 49 cr ",
        //     //                     style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
        //     //                   ),
        //     //                   SizedBox(
        //     //                     height: 10,
        //     //                   ),
        //     //                   Row(
        //     //                     children: [
        //     //                       Text(
        //     //                         "Moneycontrol",
        //     //                         style: Utils.fonts(size: 12.0, color: Utils.primaryColor, fontWeight: FontWeight.w500),
        //     //                       ),
        //     //                       Spacer(),
        //     //                       Text(
        //     //                         "2 Hours Ago",
        //     //                         style: Utils.fonts(size: 12.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
        //     //                       )
        //     //                     ],
        //     //                   )
        //     //                 ],
        //     //               ),
        //     //             ),
        //     //           ],
        //     //         ),
        //     //       ),
        //     //       Divider(
        //     //         thickness: 2,
        //     //       )
        //     //     ],
        //     //   )
        //   ],
        // ),
      ),
    );
  }
}
