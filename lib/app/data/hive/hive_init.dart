import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/counter_model.dart';
import '../models/models.dart';

class HiveInit {
  Future<void> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive
      ..registerAdapter(CounterModelAdapter())
      ..registerAdapter(InventoryModelAdapter())
      ..registerAdapter(UserModelAdapter());
  }
}
