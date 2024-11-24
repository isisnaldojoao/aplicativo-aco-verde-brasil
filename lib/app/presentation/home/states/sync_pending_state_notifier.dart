import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/data_sources/inventory_data_source.dart';
import '../../../helpers/helpers.dart';

typedef SyncPendingState = CommonState<CommonError, int>;

class SyncPendingStateNotifier extends StateNotifier<SyncPendingState> {
  SyncPendingStateNotifier({
    required this.dataSource,
  }) : super(const SyncPendingState.initial());

  final InventoryDataSource dataSource;

  Future<void> load(
    String email,
    BuildContext context,
  ) async {
    state = const SyncPendingState.loadInProgress();
    try {
      final count = await dataSource.syncData(email, context);
      await dataSource.downloadLaminationInventory();
      state = SyncPendingState.loadSuccess(count);
    } catch (e) {
      state = const SyncPendingState.loadFailure(CommonError.undefined());
    }
  }
}
