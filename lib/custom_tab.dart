import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_status.dart';

class CustomTab extends StatefulWidget{
  @override
  State<CustomTab> createState() => _CustomTab();
}

class _CustomTab extends State<CustomTab>{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_attConsts);
  }

//  GlobalKey _selectedTab = GlobalKey();
  Size _selectedSize = Size(0, 0);
  Offset _selectedPosition = Offset(0, 0);
  AppStatus appStatus;

  List<GlobalKey> _tabs = [];

  @override
  Widget build(BuildContext context) {
    if(appStatus == null) {
      appStatus = Provider.of<AppStatus>(context);

      for(int i=0; i<8; i++) _tabs.add(GlobalKey());
    } else {
      _attConsts(0);
    }
    var daysStr = ["SEG", "TER", "QUA", "QUI", "SEX", "SAB", "DOM", "CON"];

    List<Widget> days = [];
    for(int i=0; i<8; i++)
      days.add(createTab(i, daysStr[i], i == appStatus.getNextSelectedDay(), i == appStatus.getLastSelectedDay()));

    return Container(
        child: Stack(
          children: <Widget>[
            createSelector(),
            Row(children: days),
          ],
        )
    );
  }

  Widget createTab(int idx, String text, bool selected, bool lastSelected) {
    if(false) return Expanded(
//      flex: 100 + appStatus.tabsAnimation.dayFlex.value,
      key: _tabs[idx],
      child: Text(
          text,
          textAlign: TextAlign.center),
    );
    else if(lastSelected) return Expanded(
//      flex: 200 - appStatus.tabsAnimation.dayFlex.value,
      key: _tabs[idx],
      child: GestureDetector(
        onTap: () => appStatus.toPage(idx),
//        onTap: () => setSelected(idx),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
    else return Expanded(
//        flex: 100,
        key: _tabs[idx],
        child: GestureDetector(
          onTap: () => appStatus.toPage(idx),
//          onTap: () => setSelected(idx),
          child: Text(text, textAlign: TextAlign.center),
        ),
      );
  }

  void setSelected(int idx) {
    appStatus.setSelectedDay(idx);
    appStatus.notify();
    WidgetsBinding.instance.addPostFrameCallback(_attConsts);
  }

  _attConsts(_) {
    final RenderBox containerRenderBox = _tabs[appStatus.getSelectedDay()].currentContext.findRenderObject();

    final containerPosition = containerRenderBox.localToGlobal(Offset.zero);
    final containerSize = containerRenderBox.size;

    setState(() {
      _selectedSize = containerSize;
      _selectedPosition = containerPosition;
    });
  }

  Widget createSelector() => Transform.translate(
      offset: Offset(_selectedPosition.dx + _selectedSize.width*(appStatus.getAtualScreen()-appStatus.getSelectedDay()), 0),
      child: Container(
        width: _selectedSize.width,
        height: _selectedSize.height,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.rectangle,
        ),
      )
  );
}