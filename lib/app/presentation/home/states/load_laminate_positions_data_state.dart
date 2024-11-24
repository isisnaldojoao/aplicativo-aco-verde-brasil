import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/data_sources/inventory_data_source.dart';
import '../../../helpers/helpers.dart';

typedef LoadLaminatePositionDataState = CommonState<CommonError, List<String>>;

class LoadLaminatePositionDataStateNotifier
    extends StateNotifier<LoadLaminatePositionDataState> {
  LoadLaminatePositionDataStateNotifier({required this.dataSource})
      : super(const LoadLaminatePositionDataState.initial());
  final InventoryDataSource dataSource;
  Future<void> load() async {
    state = const LoadLaminatePositionDataState.loadInProgress();
    final result = await dataSource.getAllLaminationInventory();

    result.fold(
      (l) => state = LoadLaminatePositionDataState.loadFailure(l),
      (r) {
        if (r.isEmpty) {
          state = const LoadLaminatePositionDataState.loadFailure(
              CommonError.notFound());
          return;
        }
        state = LoadLaminatePositionDataState.loadSuccess(r);
      },
    );
  }
}
