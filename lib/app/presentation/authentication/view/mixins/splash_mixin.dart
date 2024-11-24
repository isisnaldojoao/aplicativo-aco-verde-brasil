import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/authentication_provider.dart';
import '../../states/states.dart';
import '../pages/splash/splash_page.dart';

mixin SplashMixin<T extends SplashPage> on ConsumerState<T> {
  @override
  void initState() {
    Future.microtask(
        () => ref.read(autenticationstate.notifier).loadAutentication());
    super.initState();
  }

  void listen() {
    ref.listen<Autenticationstate>(
      autenticationstate,
      (previous, next) {
        if (next is IsLogged) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (next is IsNotLogged) {
          Navigator.of(context).pushReplacementNamed('/auth/login');
        }
      },
    );
  }
}
