import 'package:flutter/material.dart';
import 'package:hello_world/change_tab_animation.dart';
import 'package:hello_world/enums.dart';
import 'package:hello_world/meal.dart';
import 'package:provider/provider.dart';

import 'app_status.dart';
import 'custom_tab.dart';


Color day = Color(0xffe9c46a);
Color night = Color(0xff26547c);

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  ScrollController controller = ScrollController();

  AppStatus appStatus;

  void initState() {
    controller.addListener(() => onScroll());
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToMid());

    super.initState();
  }

  void scrollToMid(){
    controller.jumpTo(controller.position.maxScrollExtent/2);
  }

  @override
  Widget build(BuildContext context) {
    appStatus = Provider.of<AppStatus>(context);

    appStatus.screenWidth = MediaQuery.of(context).size.width;
    appStatus.screenHeight = MediaQuery.of(context).size.height;

    appStatus.controller = AnimationController(
        duration: Duration(milliseconds: 400),
        vsync: this);

    if(appStatus.tabsAnimation == null) appStatus.setTabAnimation(
        ChangeTabAnimation(
            AnimationController(
                duration: Duration(milliseconds: 400),
                vsync: this)
        ));

    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate:
            (details) => appStatus.updateDrag(details.delta.dx / appStatus.screenWidth),
        onHorizontalDragEnd:
            (details) => appStatus.endDrag(details.primaryVelocity),

        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate( [
                  GestureDetector(
                    onTap: (){controller.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);},
                    child: MealScreen(
                      type: Meal.lunch,
                      bgColor: day,
                      textColor: night,
                    ),
                  ),
                  CustomTab(),
                  GestureDetector(
                    onTap: (){controller.animateTo(controller.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);},
                    child: MealScreen(
                      type: Meal.dinner,
                      bgColor: night,
                      textColor: day,
                    ),
                  ),
                ] )
            ),
          ],
        ),
      ),
    );
  }

  void onScroll() {
    var percent = controller.offset/controller.position.maxScrollExtent;

    appStatus.setScrollPercent(percent);
    appStatus.setOffset(controller.offset);

    appStatus.notify();
  }
}