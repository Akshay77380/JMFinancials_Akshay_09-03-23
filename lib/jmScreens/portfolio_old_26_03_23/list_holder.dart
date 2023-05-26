import 'package:flutter/material.dart';

import '../../util/Utils.dart';
import 'zero_portfolio.dart';
import 'zero_portfolio_tabular_view.dart';

class listHolder extends StatefulWidget {

  @override
  State<listHolder> createState() => _listHolderState();
}

class _listHolderState extends State<listHolder> {
  bool _isGrid = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Portfolio",
          style: Utils.fonts(fontWeight: FontWeight.w500, size: 14.0),
          textAlign: TextAlign.start,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.comment),
            tooltip: 'Comment Icon',
            onPressed: () {
              setState(() {
                _isGrid ? _isGrid = false : _isGrid = true;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () {},
          ),
        ],
      ),
      body: _isGrid ? zeroPortfolio() : zeroPortfoliTabular(),
    );
  }
}
