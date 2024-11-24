import 'package:hive_flutter/hive_flutter.dart';

part 'inventory_model.g.dart';

@HiveType(typeId: 1)
class InventoryModel {
  @HiveField(0)
  String ud;

  @HiveField(1)
  int index;

  @HiveField(2)
  DateTime createdAt;
  InventoryModel({
    required this.ud,
    required this.index,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ud': ud,
      'index': index,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
