
import '../../util/CommonFunctions.dart';
import '../../util/DataConstants.dart';
import '../../widget/search_area.dart';
import 'package:flutter/material.dart';

class basketSearchScreen extends SearchDelegate {
  String _selectedResult;


  basketSearchScreen();

  @override
  ThemeData appBarTheme(BuildContext context) {
    var theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.bottomNavigationBarTheme.backgroundColor,
    );
  }

  void search(String value) {
    this.query = value;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        color: Theme.of(context).textTheme.bodyText1.color,
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).textTheme.bodyText1.color,
      ),
      onPressed: () {
        Dataconstants.searchResearch = false;
        Dataconstants.searchResearch = false;
        Dataconstants.isFromAlgo=false;
        Navigator.pop(context);
        // print("ahdjahdjah ${Dataconstants.isFromAlgo}");

      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length >= 2) {
      var result = CommonFunction.globalSearch(query.toLowerCase());

      return SearchArea(
        dataAll: result['All'],
        dataCash: result['Cash'],
        dataFO: result['FO'],
        dataCurrency: result['Currency'],
        dataCommodity: result['Commodity'],
        query: query,
        // id: _id,
        searchFunction: search,
      );
    } else
      return SearchArea(
        dataAll: [],
        dataCash: [],
        dataFO: [],
        dataCurrency: [],
        dataCommodity: [],
        query: '',
        // id: _id,
        searchFunction: search,
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length >= 2) {
      var result = CommonFunction.globalSearch(query.toLowerCase());

      return SearchArea(
        dataAll: result['All'],
        dataCash: result['Cash'],
        dataFO: result['FO'],
        dataCurrency: result['Currency'],
        dataCommodity: result['Commodity'],
        query: query,
        // id: _id,
        searchFunction: search,
      );
    } else
      return SearchArea(
        dataAll: [],
        dataCash: [],
        dataFO: [],
        dataCurrency: [],
        dataCommodity: [],
        query: '',
        // id: _id,
        searchFunction: search,
      );
  }
}