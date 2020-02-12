import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/enums.dart';
import 'package:provider/provider.dart';

import 'app_status.dart';
import 'day_switch.dart';
import 'meal.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{

  static final _bgTween  = ColorTween(begin: Color(0xff25cbff), end: Color(0xff08061e));
  static final _txtTween = ColorTween(begin: Color(0xff08061e), end: Color(0xff25cbff));

  AnimationController _settingsAnimation;
  double scale = 0;

  @override
  void initState() {
    _settingsAnimation = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 4,
        duration: Duration(milliseconds: 400))
      ..addListener(() {
        setState(() {
          scale = _settingsAnimation.value;
        });
      });
    super.initState();
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
        backgroundColor: _bgTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),
        body: Stack(
          children: <Widget>[
            Column(
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
                      child: Container(width: w, child: MealScreen( textColor: _txtTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ))),
                      opacity: appStatus.opacityPercent,
                    ),
                  ),
                ),
                DaySwitch(
                  primaryColor: _txtTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),
                  secundaryColor: _bgTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),
                ),
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
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () => _settingsAnimation.isCompleted? _settingsAnimation.reverse() : _settingsAnimation.forward(from: 0.0),
                child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        width: 50 + (w-70)*scale/4,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _txtTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Transform.rotate(
                          angle: 360*scale,
                          child: Icon(
                            Icons.settings,
                            size: 30,
                            color: _bgTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 10,
              child: Opacity(
                opacity: (_settingsAnimation.value)/4,
                  child: configuration(appStatus)
              ),
            ),
          ],
        )
    );
  }

  Widget configuration(AppStatus appStatus) {
    return Theme(
      data: ThemeData.dark().copyWith(
        canvasColor: _txtTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),
      ),
      child: DropdownButton<String>(
        value: appStatus.ru,
        icon: Icon(Icons.arrow_downward, color: _bgTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          fontSize: 20,
            color: _bgTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),
        ),
        onChanged: (String newValue) {
          appStatus.fetchMenu(newValue);
          _settingsAnimation.reverse();

        },
        underline:Container(
          height: 2,
          color: _bgTween.transform((appStatus.getMeal() <= 1)? appStatus.getMeal() : 2 - appStatus.getMeal() ),
        ),
        items: <String>[RUs.CT.value, RUs.PV.value]//, RUs.DC.value]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        })
            .toList(),
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