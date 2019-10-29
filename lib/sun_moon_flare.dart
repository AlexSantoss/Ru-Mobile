import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:hello_world/enums.dart';
import 'package:provider/provider.dart';

import 'app_status.dart';

class FlareSunAndMoon extends StatelessWidget  with FlareController{
  FlareSunAndMoon({Key key, this.type}) : super(key: key);
  Meal type;
  ActorAnimation _transitionAnimation;
  ActorAnimation _runningAnimation;
  AppStatus appStatus;

  @override
  Widget build(BuildContext context) {
    if(appStatus == null) appStatus = Provider.of<AppStatus>(context);

    return Container(
      height: appStatus.screenWidth,
      width: appStatus.screenWidth,
      child: FlareActor(
        (type == Meal.dinner)? 'assets/moon.flr' : 'assets/sun.flr',
        alignment: (type == Meal.dinner)? Alignment.centerLeft : Alignment.centerRight,
        fit: BoxFit.contain,
        controller: this,
      ),
    );
  }

  double _elapsed = 0;
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    double percent = (type == Meal.dinner)? 1-appStatus.getScrollPercent() : appStatus.getScrollPercent();

    if(percent == 0.0) {
      _elapsed += elapsed;
      _transitionAnimation.apply( _elapsed % 2.0, artboard, 1.0);
    } else {
      _elapsed = 0;
      _transitionAnimation.apply(2 + percent, artboard, 1.0);
    }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard actor) {
    _transitionAnimation = actor.getAnimation("transition");
    _runningAnimation = actor.getAnimation("running");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}
}