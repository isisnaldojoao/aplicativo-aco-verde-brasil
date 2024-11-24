import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/data.dart';
import '../../../../data/data_sources/inventory_data_source.dart';
import '../../../../helpers/helpers.dart';

typedef SignInState = CommonState<String, UserModel>;

class SignInStateNotifier extends StateNotifier<SignInState> {
  SignInStateNotifier({
    required this.dataSource,
    required this.inventoryDataSource,
  }) : super(const SignInState.initial());
  final AuthenticationDataSource dataSource;
  final InventoryDataSource inventoryDataSource;
  Future<void> load({
    required String email,
    required String password,
    required int tries,
  }) async {
    state = const SignInState.loadInProgress();
    final result = await dataSource.singIn(
      password: password,
      email: email.toLowerCase(),
      tried: tries + 1,
    );

    result.fold(
      (l) => state = SignInState.loadFailure(l ?? 'Erro não identificado'),
      (r) async {
        await inventoryDataSource.downloadLaminationInventory();
        state = SignInState.loadSuccess(r);
      },
    );
  }
}
