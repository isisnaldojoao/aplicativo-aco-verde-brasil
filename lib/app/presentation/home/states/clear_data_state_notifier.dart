import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/data_sources/inventory_data_source.dart';
import '../../../helpers/helpers.dart';

typedef ClearDataState = CommonState<CommonError, int>;

class ClearDataStateNotifier extends StateNotifier<ClearDataState> {
  ClearDataStateNotifier({
    required this.dataSource,
  }) : super(const ClearDataState.initial());

  final InventoryDataSource dataSource;

  Future<void> load() async {
    state = const ClearDataState.loadInProgress();
    try {
      await dataSource.clear();
      state = const ClearDataState.loadSuccess(0);
    } catch (e) {
      state = const ClearDataState.loadFailure(CommonError.undefined());
    }
  }
}
