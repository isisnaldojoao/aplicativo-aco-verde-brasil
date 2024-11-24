import '../interfaces/flavor_values.dart';

class ProductionValues implements FlavorValues {
  @override
  String get baseUrl => 'http://192.168.0.14:3000/';
}
