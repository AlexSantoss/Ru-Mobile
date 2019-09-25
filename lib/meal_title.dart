import 'package:flutter/material.dart';
import 'package:hello_world/enums.dart';
import 'package:provider/provider.dart';

import 'app_status.dart';

class MealTitle extends StatelessWidget{
  MealTitle({Key key, this.text, this.textColor}): super(key: key);

  final Meal text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    AppStatus appStatus = Provider.of<AppStatus>(context);

    int fator = (text == Meal.lunch)? 1 : 0;

    double scale = 0.5 + 0.5 * (fator - appStatus.getScrollPercent()).abs();
    double offset = appStatus.screenWidth * 0.25 * (1 - fator -  appStatus.getScrollPercent());

    return Center(
        child: Transform.translate(
          offset: Offset(offset, 0),
          child: Transform.scale(
            scale: scale,
            child: Text(
              text.toString(),
              style: new TextStyle(
                fontSize: 48,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
    );
  }
}