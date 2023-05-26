import '../model/scrip_info_model.dart';
import '../util/Dataconstants.dart';
import 'package:flutter/material.dart';

class WatchListPickerCard extends StatefulWidget {
  final ScripInfoModel model;

  WatchListPickerCard(this.model);

  @override
  _WatchListPickerCardState createState() => _WatchListPickerCardState();
}

class _WatchListPickerCardState extends State<WatchListPickerCard> {
  int _radioIndex;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return AlertDialog(
      title: Text('Select Watchlist'),
      content: IntrinsicHeight(
        child: Column(
          children: [
            RadioListTile<int>(
              title: Text(
                "Watchlist 1",
              ),
              value: 0,
              groupValue: _radioIndex,
              onChanged: (int value) {
                setState(() {
                  _radioIndex = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text(
                "Watchlist 2",
              ),
              value: 1,
              groupValue: _radioIndex,
              onChanged: (int value) {
                setState(() {
                  _radioIndex = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text(
                "Watchlist 3",
              ),
              value: 2,
              groupValue: _radioIndex,
              onChanged: (int value) {
                setState(() {
                  _radioIndex = value;
                });
              },
            ),
            RadioListTile<int>(
              title: Text(
                "Watchlist 4",
              ),
              value: 3,
              groupValue: _radioIndex,
              onChanged: (int value) {
                setState(() {
                  _radioIndex = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: theme.primaryColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop({'added': 0, 'watchListId': -1});
          },
        ),
        TextButton(
          child: Text(
            'Add',
            style: TextStyle(
              color: theme.primaryColor,
            ),
          ),
          onPressed: () {
            if (Dataconstants.marketWatchListeners[_radioIndex].watchList.length >= Dataconstants.maxWatchlistCount) {
              Navigator.of(context).pop({'added':   2, 'watchListId': _radioIndex});
            } else {
              Dataconstants.marketWatchListeners[_radioIndex].addToWatchList(widget.model);
              Navigator.of(context).pop({'added': 1, 'watchListId': _radioIndex});
            }
          },
        ),
      ],
    );
  }
}
