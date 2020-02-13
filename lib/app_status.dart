import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'enums.dart';
class AppStatus with ChangeNotifier  {
  List _dayMeal = [];

  int _selectedDay = 0;

  int _nextDay = 1;
  double _startAnimation = 0;

  double _atualScreen = 0;
  double opacityPercent = 1;
  double animationPercent = 1;

  String ru = RUs.CT.value;

  double _meal = 0;
  int _selectedMeal = 0;

  AnimationController controller;

  AppStatus(this._atualScreen) {
    _selectedDay = _atualScreen.round();

    for (var i = 0; i < 7; i++) {
      _dayMeal.add([]);
      for (var j = 0; j < 14; j++) _dayMeal[i].add("teste" + i.toString());
    }
    getOption().then((str) => fetchMenu(str));
  }

  saveOption() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ru', ru);
  }

  Future<String> getOption() async {
    return SharedPreferences.getInstance().then((prefs) => ru = prefs.getString('ru'));
  }

  fetchMenu(String opt) {
    String str = "";
    ru = opt;

    saveOption();

    if(opt == RUs.CT.value) str = RUs.CT.link;
    else if(opt == RUs.PV.value) str = RUs.PV.link;
//    else if(opt == RUs.DC.value) str = RUs.DC.link;
    else str = RUs.CT.link;

    var link = "https://spreadsheets.google.com/feeds/list/$str/1/public/values?alt=json";
    http.get(link)
      .then((response) {
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
      })
      .catchError((erro, stack) {
        //Todo: implementar essa questao do erro aqui
        print("er");
        print(erro);
      });
  }

  getMeal() => _meal;

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
    double temp = _atualScreen - d;

    if(temp < 0) temp = 0;
    else if(temp > 6) temp = 6;
    else {
      if(temp > _selectedDay && _selectedDay < 6) _nextDay = _selectedDay + 1;
      else if(temp < _selectedDay && _selectedDay > 0) _nextDay = _selectedDay - 1;
    }
    _atualScreen = temp;
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
    double atScr = _atualScreen;
    if(_atualScreen == page) return;

    _nextDay = page;
    _startAnimation = _atualScreen;
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

      if(atScr == atScr.ceil()){
        double interval = page.toDouble()-atScr, act = opacityTransition.value - atScr;
        animationPercent = act / interval;

        opacityPercent = ((animationPercent*2)-1).abs();
        _selectedDay = (animationPercent < 0.5)? atScr.round() : page;

        notifyListeners();
      } else
        attOpacity();
    });

    controller.reset();
    controller.forward();
  }

  getDayMeal() => _dayMeal[_selectedDay];
  getDayMealOf(int type) => _dayMeal[_selectedDay][type + (_selectedMeal % 2) * 7];

  getAtualScreen() => _atualScreen;
  getSelectedDay() => _selectedDay;

  getNextDay() => _nextDay;
  getStartDay() => _startAnimation;

  notify() => notifyListeners();
}