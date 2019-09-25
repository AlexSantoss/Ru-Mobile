class Meal {
  final _value;
  const Meal._internal(this._value);
  toString() => _value;

  static const lunch = const Meal._internal('Almoco');
  static const dinner = const Meal._internal('Janta');
}
