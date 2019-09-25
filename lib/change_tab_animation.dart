import 'package:flutter/animation.dart';

class ChangeTabAnimation {
  AnimationController controller;
  Animation<double> selectorPosition;
//  Animation<double> opacity;
  Animation<int> dayFlex;

  ChangeTabAnimation(this.controller) :
        dayFlex = IntTween(
            begin: 0,
            end: 100
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Curves.decelerate))
//        opacity = Tween(
//            begin: -1.0,
//            end: 1.0
//        ).animate(CurvedAnimation(
//            parent: controller,
//            curve: Curves.decelerate))
  ;

  void startTabTransition(double endPosition) {
    selectorPosition = Tween(
        begin: selectorPosition?.value ?? 0.0,
        end: endPosition)
        .animate(new CurvedAnimation(
        parent: controller,
        curve: Curves.decelerate
    ));

    controller.reset();
    controller.forward();
  }
}