class Rating {
  final double value;
  const Rating(this.value);

  bool get isValid => value >= 1 && value <= 5;
  int get rounded => value.round();
}
