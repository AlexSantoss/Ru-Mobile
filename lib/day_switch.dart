import 'package:flutter/material.dart';
import 'package:hello_world/app_status.dart';
import 'package:provider/provider.dart';

class DaySwitch extends StatefulWidget {
  @override
  _DaySwitchState createState() => _DaySwitchState();
}

class _DaySwitchState extends State<DaySwitch> {

  List<GlobalKey> keys = [];
  GlobalKey indicator = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AppStatus appStatus = Provider.of<AppStatus>(context);

    List<Widget> days = [];
    for(int i=0; i < 7; i++) {
      keys.add(GlobalKey());
      days.add(createTab(i, "S", appStatus));
    }
    return Container(
        width: MediaQuery.of(context).size.width,
        color: Color.fromRGBO(255, 255, 255, 0.3),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: <Widget>[
            createSelector(appStatus),
            Row(children: days),
          ],
        )
    );
  }

  Widget createTab(int idx, String text, AppStatus as) {
    if(as.getSelectedDay() == idx) {
      return Expanded(
          flex: 100 + (as.opacityPercent*15).round(),
          child: Text(
            text,
            key: keys[idx],
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
              key: keys[idx],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0
              ),
            ),
          )
      );
  }

  Widget createSelector(AppStatus as) => Transform.translate(
    offset: makeOffsetStuff(as.getNextDay(), as.animationPercent, as.getAtualScreen()),
    child: Container(
      key: indicator,
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
      ),
    ),
  );

  Offset atualOff = Offset.zero;
  makeOffsetStuff(int next, double ani, double atual){
    if(ani % 1 == 0.0) atualOff = getWidgetPosition(indicator);
    Offset nextOff = getWidgetPosition(keys[next.round()]);
    Offset selectOff = getWidgetPosition(keys[atual.round()]);


    if(nextOff == null) return Offset.zero;
    Size inside = getWidgetSize(keys[next.round()]);
    double m = inside.width/2 - getWidgetSize(indicator).width/2;

    if(ani % 1 == 0.0){
      double pc = atual-atual.round();
      double diff = selectOff.dx + getWidgetSize(keys[atual.round()]).width*(pc);

      return Offset(m + diff  ?? 0, 0);
    }else {
      double diff = nextOff.dx - atualOff.dx;
      return Offset(m + atualOff.dx + diff * ani  ?? 0, 0);
    }
  }
}

Size getWidgetSize(GlobalKey gk){
  RenderBox renderBoxRed = gk.currentContext?.findRenderObject();
  return renderBoxRed?.size;
}

Offset getWidgetPosition(GlobalKey gk){
  RenderBox renderBoxRed = gk.currentContext?.findRenderObject();
  return renderBoxRed?.localToGlobal(Offset.zero);
}