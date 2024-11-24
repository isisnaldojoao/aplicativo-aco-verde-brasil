import 'package:flutter/material.dart';

import 'app/core/flavors/config/flavor_config.dart';
import 'app/core/flavors/values/prod_values.dart';
import 'main_common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(flavor: Flavor.prod, values: ProductionValues());

  await mainCommon();
}
