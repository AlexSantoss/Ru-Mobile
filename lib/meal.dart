import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/sun_moon_flare.dart';
import 'package:provider/provider.dart';
import 'app_status.dart';
import 'enums.dart';
import 'meal_subitem.dart';

class MealScreen extends StatefulWidget {
  MealScreen({Key key, this.type, this.bgColor, this.textColor}) : super(key: key);

  final Color bgColor;
  final Color textColor;

  final Meal type;

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  final List<Widget> offereds = [];
  AppStatus appStatus;

  @override
  void initState() {
    super.initState();
    //Future.delayed(Duration.zero, () {
    //  appStatus.controller.addListener(() => setState(() {}));
    //});
  }

  @override
  Widget build(BuildContext context) {
    appStatus = Provider.of<AppStatus>(context);

    var align = (widget.type == Meal.lunch)? CrossAxisAlignment.start : CrossAxisAlignment.end;

    offereds.clear();
    for(int i=0; i<7; i++)
      offereds.add(MealSubitem(type: i, color: widget.textColor, align: align));

    return Container(
      height: appStatus.screenHeight*0.9,
      color: widget.bgColor,
      child: Stack(
          fit: StackFit.expand,
          children: [
            FlareSunAndMoon(type: widget.type),
            Opacity(
              opacity: appStatus.opacityPercent,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: align,
                children: offereds,
              ),
            )
          ]
      ),
    );
  }
}

