import 'package:flutter/material.dart';
import '../database/news_database.dart';
import '../model/news_record_model.dart';

class NewsScreen extends StatelessWidget {
  final int newsNseCode;
  NewsScreen(this.newsNseCode);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: NewsDatabase.instance.getScripNews(newsNseCode),
        builder: (context, AsyncSnapshot<List<NewsRecordModel>> news) {
          if (news.hasData && news.data.isNotEmpty)
            return ListView.builder(
                itemCount: news.data.length,
                itemBuilder: (context, index) {
                  return RefreshIndicator(
                    onRefresh: (){},
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                news.data[index].description,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    color:
                                        categoryColor(news.data[index].category)
                                            .withOpacity(0.2),
                                    child: Text(
                                      news.data[index].category,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: categoryColor(
                                            news.data[index].category),
                                      ),
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
                                        news.data[index].stockNewsTime,
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
                  );
                });
          else
            return Center(
              child: Text(
                "No news available.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            );
        });
  }

  Color categoryColor(String category) {
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
}
