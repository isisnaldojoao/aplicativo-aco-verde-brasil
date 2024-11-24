import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/data_sources/inventory_data_source.dart';
import '../../../data/models/counter_model.dart';

class LoadPendingCountStateNotifier extends StateNotifier<CounterModel?> {
  LoadPendingCountStateNotifier({
    required this.dataSource,
  }) : super(null);
  final InventoryDataSource dataSource;
  Future<void> load(String email) async {
    final result = await dataSource.getPendingInventory(email);
    state = result;
  }
}
