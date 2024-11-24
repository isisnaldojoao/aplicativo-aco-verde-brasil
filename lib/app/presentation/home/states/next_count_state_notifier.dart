import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/data_sources/inventory_data_source.dart';

class NextCountStateNotifier extends StateNotifier<int> {
  NextCountStateNotifier(this.dataSource) : super(0);

  final InventoryDataSource dataSource;

  Future<void> load(String position) async {
    try {
      final data = await dataSource.nextCounter(position);
      state = data;
    } catch (e) {
      state = 1;
    }
  }
}
