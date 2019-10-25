import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/enums.dart';
import 'package:hello_world/meal.dart';
import 'package:provider/provider.dart';

import 'app_status.dart';
import 'custom_tab.dart';


Color day = Color(0xff25cbff);
Color night = Color(0xff08061e);

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
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

  void scrollTo(percent){
    var dest = 0.0;

    if(percent < 0.25) dest = 0;
    else if(percent < 0.75) dest = controller.position.maxScrollExtent/2;
    else dest = controller.position.maxScrollExtent;

    controller.animateTo(dest, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    appStatus = Provider.of<AppStatus>(context);

    appStatus.screenWidth = MediaQuery.of(context).size.width;
    appStatus.screenHeight = MediaQuery.of(context).size.height;

    if(appStatus.controller == null) appStatus.controller = AnimationController(
        duration: Duration(milliseconds: 400),
        vsync: this);

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
                    onTap: () => scrollTo(0),
                    child: MealScreen(
                      type: Meal.lunch,
                      bgColor: day,
                      textColor: night,
                    ),
                  ),
                  CustomTab(),
                  GestureDetector(
                    onTap: () => scrollTo(1),
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