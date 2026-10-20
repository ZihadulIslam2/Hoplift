enum BaggageType {
  large("Large"),
  small("Small"),
  none("None"),;

  final String name;

  const BaggageType(this.name);

  factory BaggageType.fromString(String value) {
    value = value.toLowerCase();
    switch (value) {
      case 'small':
        return BaggageType.small;
      case 'large':
        return BaggageType.large;
      case 'suitcase':
        return BaggageType.large;
      case 'none':
        return BaggageType.none;
      default:
        throw ArgumentError('Invalid baggage type: $value');
    }
  }
  String assetImagePath() {
    switch (this) {
      case BaggageType.small:
        return 'assets/images/smallbaggage.png';
      case BaggageType.large:
        return 'assets/images/largebaggage.png';
      case BaggageType.none:
        return 'assets/images/empty.png';
    }
  }
}