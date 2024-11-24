import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'inventory_model.dart';

part 'counter_model.g.dart';

@HiveType(typeId: 2)
class CounterModel {
  @HiveField(0)
  String email;

  @HiveField(1)
  int number;

  @HiveField(4)
  String position;

  @HiveField(2)
  List<InventoryModel> items;

  @HiveField(3)
  bool isFinished;

  @HiveField(5)
  bool isOnline;

  @HiveField(6)
  DateTime createdAt;

  CounterModel({
    required this.email,
    required this.number,
    required this.position,
    required this.items,
    required this.isFinished,
    required this.isOnline,
    required this.createdAt,
  });

  CounterModel copyWith({
    String? email,
    int? number,
    String? position,
    List<InventoryModel>? items,
    bool? isFinished,
    bool? isOnline,
    DateTime? createdAt,
  }) {
    return CounterModel(
      email: email ?? this.email,
      number: number ?? this.number,
      position: position ?? this.position,
      items: items ?? this.items,
      isFinished: isFinished ?? this.isFinished,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  List<Map<String, dynamic>> toMap() {
    return items
        .map((e) => {
              'ud': e.ud,
              'posicao': position,
              'n_contagem': number,
              'usuario': email.split('@').first,
              'data': DateFormat('yyyy-MM-dd').format(e.createdAt),
              'horario': DateFormat('HH:mm:ss').format(e.createdAt),
            })
        .toList();
  }

  bool isPendingToSend(String userEmail) {
    return email == userEmail && isFinished && !isOnline;
  }

  bool isSended(String userEmail) {
    return email == userEmail && isFinished && isOnline;
  }
}
