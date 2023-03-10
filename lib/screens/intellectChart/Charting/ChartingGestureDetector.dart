import 'package:flutter/gestures.dart';

class ChartingGestureDetector extends OneSequenceGestureRecognizer {
  final Function onHorizontalDragDown;
  final Function onHorizontalDragUpdate;
  final Function onHorizontalDragUp;

  ChartingGestureDetector({
    this.onHorizontalDragDown,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragUp,
  });

  @override
  void addPointer(PointerEvent event) {
    //Returns true or false depending on whether there
    //is a pointer on screen already
    if (onHorizontalDragDown(event)) {
      startTrackingPointer(event.pointer);
      resolve(GestureDisposition.accepted);
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    //If the pointer is being dragged
    if (event is PointerMoveEvent) {
      //Sends the position of the drag
      onHorizontalDragUpdate(event.position);
    }
    //If the pointer is being lifted
    else if (event is PointerUpEvent) {
      onHorizontalDragUp(event);
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  String get debugDescription => 'singlePointerDrag';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
