import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AppStatus with ChangeNotifier {
  List _dayMeal = [];

  double _scrollPercent = 0.0;
  double _offset = 0.0;

  int _selectedDay = 0;
  double _atualScreen = 0;
  double opacityPercent = 1;

  double screenWidth;
  double screenHeight;

  AnimationController controller;

  AppStatus(this._atualScreen) {
    _selectedDay = _atualScreen.round();

    for (var i = 0; i < 7; i++) {
      _dayMeal.add([]);
      for (var j = 0; j < 14; j++) _dayMeal[i].add("teste" + i.toString());
    }
    fetchMenu();
  }

  fetchMenu() async {
    var link = "https://spreadsheets.google.com/feeds/list/1YvCqBrNw5l4EFNplmpRBFrFJpjl4EALlVNDk3pwp_dQ/1/public/values?alt=json";
    http.get(link).then((response) {
      int auxi = 0, auxj=0;
      for(final row in json.decode(response.body)["feed"]["entry"]){

        var sheet = LinkedHashMap.from(row)
          ..removeWhere((k, _) => !k.startsWith("gsx"));
        if( sheet.length != 8 ||
            sheet["gsx\$_cn6ca"]["\$t"] == "JANTAR" ||
            sheet["gsx\$_cn6ca"]["\$t"] == "ALMOÇO") continue;
        sheet.removeWhere((k, _) => k == "gsx\$_cn6ca");
        for(final column in sheet.entries){
          _dayMeal[auxj++][auxi] = column.value["\$t"].toString().replaceAll("\n", "");
        }

        auxi++;
        auxj = 0;
      }
      notifyListeners();
    });
  }

  getMeal() => _meal;

  double _meal = 0;
  int _selectedMeal = 0;
  updateType(double d) {
    _meal -= d;
    _meal = _meal%2;

    attMeal();
  }

  endType(double velocity) {
    int end;

    if(velocity.abs() > 100) end = (velocity > 0)? _meal.floor() : _meal.ceil();
    else end = _meal.round();

    toMeal(end);
  }

  bool animatingMeal;
  toMeal(int meal) {
    animatingMeal = true;
    final opacityTransition = Tween(
        begin: _meal,
        end: meal.toDouble()
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.decelerate));

    opacityTransition.addListener(() {
      if(!animatingMeal) return;

      _meal = opacityTransition.value;
      attMeal();
    });


    controller.reset();
    controller.forward();
  }

  attMeal(){
    _selectedMeal = _meal.round();
    notifyListeners();
  }

  updateDrag(double d) {
    _atualScreen -= d;

    if(_atualScreen < 0) _atualScreen = 0;
    else if(_atualScreen > 6) _atualScreen = 6;

    attOpacity();
  }

  endDrag(double velocity) {
    int end;

    if(velocity.abs() > 100) end = (velocity > 0)? _atualScreen.floor() : _atualScreen.ceil();
    else end = _atualScreen.round();

    toPage(end);
  }

  attOpacity() {
    double decimal = _atualScreen-_atualScreen.floor();
    opacityPercent = (decimal - 0.5).abs() * 2;

    _selectedDay = _atualScreen.round();
    notifyListeners();
  }

  toPage(int page) {
    animatingMeal = false;
    final opacityTransition = Tween(
        begin: _atualScreen,
        end: page.toDouble()
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.decelerate));

    opacityTransition.addListener(() {
      if(animatingMeal) return;

      _atualScreen = opacityTransition.value;
      attOpacity();
    });

    controller.reset();
    controller.forward();
  }

  getDayMeal() => _dayMeal[_selectedDay];
  getDayMealOf(int type) => _dayMeal[_selectedDay][type + (_selectedMeal % 2) * 7];

  getScrollPercent() => _scrollPercent;
  setScrollPercent(double scrollPercent) => _scrollPercent = scrollPercent;

  getOffset() => _offset;
  setOffset(double offset) => _offset = offset;

  getSelectedDay() => _selectedDay;
  getAtualScreen() => _atualScreen;

  notify() => notifyListeners();
}