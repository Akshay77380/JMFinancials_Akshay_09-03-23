import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import '../../util/Utils.dart';

class ToggleSwitch extends StatefulWidget {
  final switchController;
  final isBorder;
  final activeColor;
  final inactiveColor;
  final thumbColor;
  var height;
  var width;

  ToggleSwitch(
      {@required this.switchController,
      this.isBorder,
      @required this.activeColor,
      @required this.inactiveColor,
      @required this.thumbColor,
      this.height = 18.0,
      this.width = 40.0});

  @override
  State<ToggleSwitch> createState() => _SwitchState();
}

class _SwitchState extends State<ToggleSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: widget.isBorder
              ? Border.all(
                  color: Utils.blackColor, width: 2
              )
              : null,
          borderRadius: BorderRadius.circular(15)),
      child: AdvancedSwitch(
        width: widget.width,
        height: widget.height,
        controller: widget.switchController,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        thumb: ValueListenableBuilder<bool>(
          valueListenable: widget.switchController,
          builder: (_, value, __) {
            return CircleAvatar(
              radius: 2,
              backgroundColor: widget.thumbColor,
            );
          },
        ),
      ),
    );
  }
}
