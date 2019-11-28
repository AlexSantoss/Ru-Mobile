import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_status.dart';
import 'enums.dart';

class MealScreen extends StatelessWidget {
  MealScreen({Key key, this.textColor}): super(key: key);

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final appStatus = Provider.of<AppStatus>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7,
        (idx) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
                chooseType(idx),
                textAlign: TextAlign.start,
                style: new TextStyle(
                    fontSize: 20,
                    color: textColor,
                    fontWeight: FontWeight.bold
                )
            ),
            Text(
                appStatus.getDayMealOf(idx),
                textAlign: TextAlign.start,
                style: new TextStyle(
                  fontSize: 16,
                  color: textColor,
                )
            )
          ],
        )
      )
    );
  }

  String chooseType(int i){
    switch(i){
      case 0: return "Entrada";
      case 1: return "Prato Principal";
      case 2: return "Prato Vegetariano";
      case 3: return "Guarnicao";
      case 4: return "Acompanhamento";
      case 5: return "Sobremesa";
      case 6: return "Refresco";
      default: return "";
    }
  }

}

