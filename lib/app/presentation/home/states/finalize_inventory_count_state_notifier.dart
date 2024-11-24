import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/data_sources/inventory_data_source.dart';
import '../../../helpers/helpers.dart';

typedef FinalizeInventoryCountState = CommonState<CommonError, bool>;

class FinalizeInventoryCountStateNotifier
    extends StateNotifier<FinalizeInventoryCountState> {
  FinalizeInventoryCountStateNotifier(this.dataSource)
      : super(const FinalizeInventoryCountState.initial());

  final InventoryDataSource dataSource;

  Future<void> load(int counter, String position, String email) async {
    state = const FinalizeInventoryCountState.loadInProgress();
    try {
      await dataSource.finishCounter(counter, position, email);
      state = const FinalizeInventoryCountState.loadSuccess(true);
    } catch (e) {
      state = const FinalizeInventoryCountState.loadFailure(
        CommonError.undefined(),
      );
    }
  }
}
