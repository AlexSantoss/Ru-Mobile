import 'package:flutter/material.dart';

import 'change_tab_animation.dart';

class AppStatus with ChangeNotifier {
  List _dayMeal = [];

  double _scrollPercent = 0.0;
  double _offset = 0.0;

  double _atualScreen = 0;
  double opacityPercent = 1;

  int _lastSelectedDay = 0;
  int _selectedDay = 0;
  int _nextSelectedDay = 0;

  double screenWidth;
  double screenHeight;

  ChangeTabAnimation tabsAnimation;

  AppStatus(this._selectedDay, this._scrollPercent, this._offset) {
    for (var i = 0; i < 7; i++) {
      _dayMeal.add([]);
      for (var j = 0; j < 7; j++) _dayMeal[i].add("teste" + i.toString());
    }
  }

  updateDrag(double d) {
    _atualScreen -= d;

    if(_atualScreen < 0) _atualScreen = 0;
    else if(_atualScreen > 6) _atualScreen = 6;

    attOpacity();
  }

  AnimationController controller;
  Animation<double> _opacityTransition;

  endDrag(double velocity) {
    int end;

    if(velocity.abs() > 100) end = (velocity > 0)? _atualScreen.floor() : _atualScreen.ceil();
    else end = _atualScreen.round();

    toPage(end);
  }

  getAtualScreen() => _atualScreen;

  attOpacity() {
    double decimal = _atualScreen-_atualScreen.floor();
    opacityPercent = (decimal - 0.5).abs() * 2;

    _selectedDay = _atualScreen.round();

    notifyListeners();
  }

  toPage(int page) {
    _opacityTransition = Tween(
        begin: _atualScreen,
        end: page.toDouble()
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.decelerate))
      ..addListener(() {
        _atualScreen = _opacityTransition.value;
        attOpacity();
      });

    controller.forward();
  }

  getDayMeal() => _dayMeal[_selectedDay];
  getDayMealOf(int type) => _dayMeal[_selectedDay][type];

  getScrollPercent() => _scrollPercent;
  setScrollPercent(double scrollPercent) => _scrollPercent = scrollPercent;

  getOffset() => _offset;

  setOffset(double offset) => _offset = offset;
  setSelectedDay(int selectedDay) {
    _nextSelectedDay = selectedDay;
    _lastSelectedDay = _selectedDay;
  }
  getLastSelectedDay() => _lastSelectedDay;
  getSelectedDay() => _selectedDay;

  getNextSelectedDay() => _nextSelectedDay;

  notify() => notifyListeners();

  setTabAnimation(ChangeTabAnimation changeTabAnimation) {
    tabsAnimation = changeTabAnimation;
//    tabsAnimation.controller.addListener(() {
//      if (_nextSelectedDay != _selectedDay &&
//          tabsAnimation.opacity.value >= 0) {
//        _selectedDay = _nextSelectedDay;
//      }
//    });
  }
}