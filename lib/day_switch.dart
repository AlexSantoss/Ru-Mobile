import 'package:flutter/material.dart';
import 'package:hello_world/app_status.dart';
import 'package:provider/provider.dart';

class DaySwitch extends StatefulWidget {
  DaySwitch({Key key, this.primaryColor, this.secundaryColor}): super(key: key);
  final Color primaryColor;
  final Color secundaryColor;

  @override
  _DaySwitchState createState() => _DaySwitchState();
}

class _DaySwitchState extends State<DaySwitch> {

  List<GlobalKey> keys = [];
  GlobalKey indicator = GlobalKey();

  @override
  Widget build(BuildContext context) {
    AppStatus appStatus = Provider.of<AppStatus>(context);

    final s = ["S", "T", "Q", "Q", "S", "S", "D"];
    List<Widget> days = [];
    for(int i=0; i < 7; i++) {
      keys.add(GlobalKey());
      days.add(createTab(i, s[i], appStatus));
    }
    return Container(
        width: MediaQuery.of(context).size.width,
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
    final _txtTween = ColorTween(begin: widget.primaryColor, end: widget.secundaryColor);

    if(as.getSelectedDay() == idx) {
      return Expanded(
          flex: 100 + (as.opacityPercent*15).round(),
          child: Text(
            text,
            key: keys[idx],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _txtTween.transform(as.opacityPercent),
                fontSize: 25.0 + 10 * as.opacityPercent,
                fontWeight: FontWeight.w900
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
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  color: widget.primaryColor
              ),
            ),
          )
      );
  }

  Widget createSelector(AppStatus as) {
    double fix = (as.animationPercent == 1)? 40 : 20+20*(1-(as.getNextDay() - as.getStartDay()).abs()/6);
    double un = 40-fix;
    double sPercent = (as.animationPercent * 2 - 1).abs();

    return Transform.translate(
      offset: makeOffsetStuff(as.getNextDay(), as.animationPercent, as.getAtualScreen()),
      child: Container(
        key: indicator,
        width: fix + un * sPercent,
        height: fix + un * sPercent,
        decoration: BoxDecoration(
          color: widget.primaryColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

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