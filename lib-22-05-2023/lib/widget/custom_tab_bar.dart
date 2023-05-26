import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class CustomTabBarScrollPhysics extends ScrollPhysics {
  const CustomTabBarScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  CustomTabBarScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomTabBarScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 120,
        stiffness: 100,
        damping: 1,
      );
}
