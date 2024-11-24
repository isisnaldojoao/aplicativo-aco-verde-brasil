import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/data_sources/inventory_data_source.dart';
import '../../../data/models/models.dart';
import '../../../helpers/helpers.dart';

typedef SaveInventoryCountState = CommonState<CommonError, bool>;

class SaveInventoryCountStateNotifier
    extends StateNotifier<SaveInventoryCountState> {
  SaveInventoryCountStateNotifier(this.dataSource)
      : super(const SaveInventoryCountState.initial());

  final InventoryDataSource dataSource;

  Future<void> load(
    int counter,
    String email,
    String position,
    InventoryModel inventory,
  ) async {
    state = const SaveInventoryCountState.loadInProgress();
    try {
      await dataSource.save(
        item: inventory,
        counter: counter,
        email: email,
        position: position,
      );
      state = const SaveInventoryCountState.loadSuccess(true);
    } catch (e) {
      state =
          const SaveInventoryCountState.loadFailure(CommonError.undefined());
    }
  }
}
