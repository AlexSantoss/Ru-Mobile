import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/enums.dart';
import 'package:provider/provider.dart';

import 'app_status.dart';
import 'meal.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  ScrollController _controller = ScrollController();
  static final _bgTween  = ColorTween(begin: Color(0xff25cbff), end: Color(0xff08061e));
  static final _txtTween = ColorTween(begin: Color(0xff08061e), end: Color(0xff25cbff));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback( (_) => _controller.jumpTo(_controller.position.maxScrollExtent));
  }

  bool aux = true;
  void scrollTo(percent){
    aux = false;
    WidgetsBinding.instance
        .addPostFrameCallback((_) =>
        _controller.animateTo(
            (percent < 0.40)? 0.0 : _controller.position.maxScrollExtent
            , duration: Duration(milliseconds: ((percent < 0.40)? 200 * percent / 0.4 : 300 * (1-(percent-0.4) / 0.6)).round())
            , curve: Curves.fastOutSlowIn)
            .whenComplete(() => aux = true));
  }

  @override
  Widget build(BuildContext context) {
    final appStatus = Provider.of<AppStatus>(context);

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    if(appStatus.controller == null) appStatus.controller = AnimationController(
        duration: Duration(milliseconds: 400),
        vsync: this);

    return Scaffold(
        body: Container(
          color: _bgTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),
          child: NotificationListener(
            onNotification: (t) {
              if(t is ScrollEndNotification && aux) scrollTo(_controller.offset/_controller.position.maxScrollExtent);
              return true;
            },
            child: ListView(
                controller: _controller,
                children: <Widget>[
                  Configuration(),
                  Container(
                    height: h*0.95,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onHorizontalDragUpdate:
                                (details) => appStatus.updateDrag(details.delta.dx / w),
                            onHorizontalDragEnd:
                                (details) => appStatus.endDrag(details.primaryVelocity),
                            child: Opacity(
                              child: MealScreen( textColor: _txtTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() )),
                              opacity: appStatus.opacityPercent,
                            ),
                          ),
                        ),
                        DaySwitch(),
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onHorizontalDragUpdate:
                                (details) => appStatus.updateType(details.delta.dx / w),
                            onHorizontalDragEnd:
                                (details) => appStatus.endType(details.primaryVelocity),
                            child: Stack(children: <Widget>[TypeSwitch(Meal.lunch), TypeSwitch(Meal.dinner)] )
                        )
                      ],
                    ),
                  ),
                ]
            ),
          ),
        )
    );
  }
}

class Configuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.2,
      width: MediaQuery.of(context).size.width,
      color: Colors.blueGrey,
    );
  }
}

class DaySwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> a = [];
    for(int i=0; i < 7; i++)
      a.add(Text("Seg", style: TextStyle(fontSize: 20),));

    return Container(
      height: MediaQuery.of(context).size.height*0.05,
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(255, 255, 255, 0.3),
      child: Row(
        children: a,
      ),
    );
  }

}

class TypeSwitch extends StatelessWidget  with FlareController{
  TypeSwitch(this.type, {Key key}) : super(key: key);
  final Meal type;

  ActorAnimation _natural;
  ActorAnimation _rotating;
  AppStatus appStatus;

  @override
  Widget build(BuildContext context) {
    appStatus = Provider.of<AppStatus>(context);

    return Container(
      height: MediaQuery.of(context).size.width/2,
      width: MediaQuery.of(context).size.width,
      child: FlareActor(
        type.file,
        controller: this,
        fit: BoxFit.contain,
      ),
    );
  }

  double _elapsed = 0;
  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _elapsed += elapsed;
//    print(type);
    if(type == Meal.lunch) _rotating.apply( -appStatus.getMeal()%2, artboard, 1.0);
    else _rotating.apply( (-appStatus.getMeal()+1)%2, artboard, 1.0);
    _natural.apply( _elapsed % 2.0, artboard, 1.0);

    return true;
  }

  @override
  void initialize(FlutterActorArtboard actor) {
    _rotating = actor.getAnimation("rotating");
    _natural = actor.getAnimation("natural");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    // TODO: implement setViewTransform
  }
}