import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_status.dart';

class MealSubitem extends StatefulWidget{
  MealSubitem({Key key, this.type, this.color, this.align}) : super(key : key);

  final CrossAxisAlignment align;
  final Color color;
  final int type;

  @override
  _MealSubitemState createState() => _MealSubitemState();
}

class _MealSubitemState extends State<MealSubitem> {

  AppStatus appStatus;

//  @override
//  void initState() {
//    super.initState();
//    Future.delayed(Duration.zero, () {
//      appStatus.tabsAnimation.controller.addListener(() => setState(() {}));
//    });
//  }

  @override
  Widget build(BuildContext context){
    appStatus = Provider.of<AppStatus>(context);

    var side = (widget.align == CrossAxisAlignment.start)? 0 : 1;
    var idx = (widget.align == CrossAxisAlignment.start)? -(widget.type+1) : 7-widget.type;

    double offX = appStatus.screenWidth*idx*(appStatus.getScrollPercent() - side);
    offX = (side == 0)? offX : -offX;

    double offY = appStatus.getOffset() - side*appStatus.screenHeight*0.85;

    return Transform.translate(
      offset: Offset(offX,  offY),
      child: Container(
          child: Padding(
              padding: EdgeInsets.all(10),
//              child: Opacity(
//                opacity: appStatus.tabsAnimation.opacity?.value?.abs() ?? 1,
                child: Column(
                  crossAxisAlignment: widget.align,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(chooseType(widget.type),
                        style: new TextStyle(
                            fontSize: 20,
                            color: widget.color,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    Text(appStatus.getDayMealOf(widget.type, side),
                        style: new TextStyle(
                          fontSize: 16,
                          color: widget.color,
                        )
                    )
                  ],
                ),
              )
//          )
      ),
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
