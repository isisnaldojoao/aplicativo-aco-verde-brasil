import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/data.dart';
import '../../../data/models/counter_model.dart';
import '../states/clear_data_state_notifier.dart';
import '../states/finalize_inventory_count_state_notifier.dart';
import '../states/load_laminate_positions_data_state.dart';
import '../states/load_pending_count_state.dart';
import '../states/next_count_state_notifier.dart';
import '../states/pending_data_state_notifier.dart';
import '../states/pending_quantity_state_notifier.dart';
import '../states/save_inventory_count_state_notifier.dart';
import '../states/sync_pending_state_notifier.dart';

final pendingQuantityProvider =
    StateNotifierProvider<PendingQuantityStateNotifier, PendingQuantityState>(
  (ref) => PendingQuantityStateNotifier(ref.read(inventoryDatasourceProvider)),
);

final syncPendingProvider =
    StateNotifierProvider<SyncPendingStateNotifier, SyncPendingState>(
  (ref) => SyncPendingStateNotifier(
      dataSource: ref.read(inventoryDatasourceProvider)),
);

final clearDataProvider =
    StateNotifierProvider<ClearDataStateNotifier, ClearDataState>(
  (ref) =>
      ClearDataStateNotifier(dataSource: ref.read(inventoryDatasourceProvider)),
);

final saveInventoryCountProvider = StateNotifierProvider<
    SaveInventoryCountStateNotifier, SaveInventoryCountState>(
  (ref) =>
      SaveInventoryCountStateNotifier(ref.read(inventoryDatasourceProvider)),
);

final finalizeInventoryCountProvider = StateNotifierProvider<
    FinalizeInventoryCountStateNotifier, FinalizeInventoryCountState>(
  (ref) => FinalizeInventoryCountStateNotifier(
      ref.read(inventoryDatasourceProvider)),
);

final nextCountProvider = StateNotifierProvider<NextCountStateNotifier, int>(
  (ref) => NextCountStateNotifier(ref.read(inventoryDatasourceProvider)),
);

final sendedDataStateProvider =
    StateNotifierProvider<PendingDataStateNotifier, PendingDataState>(
  (ref) => PendingDataStateNotifier(ref.read(inventoryDatasourceProvider)),
);

final positionsStateProvider = StateNotifierProvider<
    LoadLaminatePositionDataStateNotifier, LoadLaminatePositionDataState>(
  (ref) => LoadLaminatePositionDataStateNotifier(
      dataSource: ref.read(inventoryDatasourceProvider)),
);

final pendingCounterStateProvider = StateNotifierProvider.autoDispose<
    LoadPendingCountStateNotifier, CounterModel?>(
  (ref) => LoadPendingCountStateNotifier(
      dataSource: ref.read(inventoryDatasourceProvider)),
);
