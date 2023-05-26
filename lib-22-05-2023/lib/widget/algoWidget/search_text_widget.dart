import 'package:flutter/material.dart';

class SearchTextWidget extends StatefulWidget {
  final Function function;
  final String hint;
  const SearchTextWidget({
    Key key,
    @required this.function,
    this.hint = 'Search Name',
  }) : super(key: key);
  @override
  _SearchTextWidgetState createState() => _SearchTextWidgetState();
}

class _SearchTextWidgetState extends State<SearchTextWidget> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.search,
          color: Colors.grey[600],
        ),
        SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: _controller,
            onChanged: (value) {
              widget.function(value);
              setState(() {});
              // Dataconstants.orderReport
              //     .updatePendingFilteredOrdersBySearch(value);
            },
            onSubmitted: (value) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
        _controller.text.length > 0
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                widget.function('');
                setState(() {
                _controller.clear();
            });
            FocusScope.of(context).unfocus();
          },
          child: Icon(
            Icons.clear,
            color: Colors.grey[600],
          ),
        )
            : SizedBox.shrink(),
      ],
    );
  }
}
