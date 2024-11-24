import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/data_sources/inventory_data_source.dart';
import '../../../helpers/helpers.dart';

typedef PendingDataState = CommonState<CommonError, int>;

class PendingDataStateNotifier extends StateNotifier<PendingDataState> {
  PendingDataStateNotifier(this.dataSource)
      : super(const PendingDataState.initial());

  final InventoryDataSource dataSource;

  Future<void> load(String email) async {
    state = const PendingDataState.loadInProgress();
    try {
      final data = await dataSource.sended(email);

      state = PendingDataState.loadSuccess(data);
    } catch (e) {
      state = const PendingDataState.loadFailure(CommonError.undefined());
    }
  }
}
