import 'package:flutter/material.dart';

import '../../../core/navigator/module_routes_interface.dart';
import '../view/pages/pages.dart';

class AuthRoutes extends IModuleRoutes {
  @override
  String get routeName => '/auth';

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        '': (context) => const SplashPage(),
        '/login': (context) => const SignInPage(),
      };
}
