import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/data_sources/inventory_data_source.dart';
import '../../../helpers/helpers.dart';

typedef PendingQuantityState = CommonState<CommonError, int>;

class PendingQuantityStateNotifier extends StateNotifier<PendingQuantityState> {
  PendingQuantityStateNotifier(this.dataSource)
      : super(const PendingQuantityState.initial());

  final InventoryDataSource dataSource;

  Future<void> load(String email) async {
    state = const PendingQuantityState.loadInProgress();
    try {
      final data = await dataSource.pending(email);

      state = PendingQuantityState.loadSuccess(data);
    } catch (e) {
      state = const PendingQuantityState.loadFailure(CommonError.undefined());
    }
  }
}
