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

class RUs {
  static const CT = const RUs._internal("Central, CT e Letras", "1YvCqBrNw5l4EFNplmpRBFrFJpjl4EALlVNDk3pwp_dQ");
  static const PV = const RUs._internal("IFCS e Praia Vermelha", "1gymUpZ2m-AbDgH7Ee7uftbqWmKBVYxoToj28E8c-Dzc");
  static const DC = const RUs._internal("Duque de Caxias", "1LBtA7knM0m-HIlsmMOym0eySM35d9f-WcsS9po4Luac");

  final String _value;
  final String _link;

  get value => _value;
  get link => _link;

  const RUs._internal(this._value, this._link);
  toString() => _value;
}

