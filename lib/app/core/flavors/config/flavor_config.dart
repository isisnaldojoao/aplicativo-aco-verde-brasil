import '../interfaces/flavor_values.dart';

enum Flavor {
  dev,
  prod,
}

class FlavorConfig {
  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) =>
      _instance ??= FlavorConfig._internal(flavor, values);

  FlavorConfig._internal(this.flavor, this.values);

  final Flavor flavor;
  final FlavorValues values;
  static FlavorConfig? _instance;

  static FlavorConfig? get instance => _instance;

  bool get isProduction => _instance?.flavor == Flavor.prod;
  bool get isDevelopment => _instance?.flavor == Flavor.dev;
}
