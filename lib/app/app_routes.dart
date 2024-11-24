import 'package:flutter/material.dart';
import 'core/navigator/app_routes_interface.dart';
import 'core/navigator/module_routes_interface.dart';
import 'presentation/authentication/routes/auth_routes.dart';
import 'presentation/home/view/pages/count_inventory_page.dart';
import 'presentation/home/view/pages/home_page.dart';

class AppRoutes extends IAppRoutes {
  @override
  List<IModuleRoutes> get features => [
        AuthRoutes(),
      ];

  @override
  String get initialRoute => '/auth';

  @override
  Map<String, Widget Function(BuildContext p1)> get routes => {
        '/home': (_) => const HomePage(),
        '/register-inventory': (_) => const CountInventoryPage(),
      };
}
