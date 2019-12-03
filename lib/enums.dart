import 'dart:ui';

class Meal {
  static const lunch = const Meal._internal('Almoco', 'assets/sun.flr');
  static const dinner = const Meal._internal('Janta', 'assets/moon.flr');

  final String _value;
  final String _file;

  get value => _value;
  get file => _file;

  const Meal._internal(this._value, this._file);
  toString() => _value;
}