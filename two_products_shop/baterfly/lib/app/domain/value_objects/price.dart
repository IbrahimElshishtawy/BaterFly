class Price {
  final double value;
  const Price(this.value);

  String get formatted => '${value.toStringAsFixed(2)} ج.م';
}
