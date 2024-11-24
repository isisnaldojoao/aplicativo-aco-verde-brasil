import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../data/data_sources/authentication_data_source.dart';
import '../../../../data/models/models.dart';

part 'authentication_state.dart';

class CheckAutenticationStatenotifier
    extends StateNotifier<Autenticationstate> {
  CheckAutenticationStatenotifier({
    required this.dataSource,
  }) : super(Initial());

  final AuthenticationDataSource dataSource;

  bool enableMock = false;

  void loadAutentication() async {
    state = Loading();

    final user = await dataSource.getUser();

    user.fold(
      (l) => state = IsNotLogged(),
      (r) {
        if (enableMock) {
          state = IsLogged(r);
          return;
        }

        try {
          final isExpired = JwtDecoder.isExpired(r.token);
          if (isExpired) {
            state = IsNotLogged();
          } else {
            state = IsLogged(r);
          }
        } catch (e) {
          state = IsNotLogged();
        }
      },
    );
  }
}
