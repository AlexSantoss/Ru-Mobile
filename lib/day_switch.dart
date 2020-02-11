import 'package:flutter/material.dart';
import 'package:hello_world/app_status.dart';
import 'package:provider/provider.dart';

class DaySwitch extends StatefulWidget {
  @override
  _DaySwitchState createState() => _DaySwitchState();
}

class _DaySwitchState extends State<DaySwitch> {

  @override
  Widget build(BuildContext context) {
    AppStatus appStatus = Provider.of<AppStatus>(context);

    List<Widget> days = [];
    for(int i=0; i < 7; i++)
      days.add(createTab(i, "S", appStatus));

    return Container(
        height: MediaQuery.of(context).size.height*0.05,
        width: MediaQuery.of(context).size.width,
        color: Color.fromRGBO(255, 255, 255, 0.3),
        child: Center(
          child: Stack(
            children: <Widget>[
              Row(children: days),
            ],
          ),
        )
    );
  }

  Widget createTab(int idx, String text, AppStatus as) {
    if(as.getSelectedDay() == idx) {
      return Expanded(
          flex: 100 + (as.opacityPercent*100).round(),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.0 + 10 * as.opacityPercent
            ),
          )
      );
    }
    else
      return Expanded(
          flex: 100,
          child: GestureDetector(
            onTap: () => as.toPage(idx),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0
              ),
            ),
          )
      );
  }
}