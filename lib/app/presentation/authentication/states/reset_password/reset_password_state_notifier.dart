import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/data.dart';
import '../../../../helpers/helpers.dart';

typedef ResetPasswordState = CommonState<CommonError, String>;

class ResetPasswordStateNotifier extends StateNotifier<ResetPasswordState> {
  ResetPasswordStateNotifier({required this.dataSource})
      : super(const ResetPasswordState.initial());
  final AuthenticationDataSource dataSource;
  Future<void> load({required String email}) async {
    state = const ResetPasswordState.loadInProgress();
    final result = await dataSource.resetPassword(email: email);
    result.fold(
      (l) => state = ResetPasswordState.loadFailure(l),
      (r) => state = const ResetPasswordState.loadSuccess('Sucesso'),
    );
  }
}
