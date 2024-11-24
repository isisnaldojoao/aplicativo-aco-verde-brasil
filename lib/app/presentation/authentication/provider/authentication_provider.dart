import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/data_provider.dart';
import '../states/states.dart';

final stateResetPassword = StateNotifierProvider.autoDispose<
    ResetPasswordStateNotifier, ResetPasswordState>(
  (ref) => ResetPasswordStateNotifier(
    dataSource: ref.read(authDatasourceProvider),
  ),
);

final stateSignInProvider =
    StateNotifierProvider.autoDispose<SignInStateNotifier, SignInState>(
  (ref) => SignInStateNotifier(
    dataSource: ref.read(authDatasourceProvider),
    inventoryDataSource: ref.read(inventoryDatasourceProvider),
  ),
);

final autenticationstate =
    StateNotifierProvider<CheckAutenticationStatenotifier, Autenticationstate>(
  (ref) => CheckAutenticationStatenotifier(
    dataSource: ref.read(authDatasourceProvider),
  ),
);
