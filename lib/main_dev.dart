import 'package:flutter/material.dart';

import 'app/core/flavors/config/flavor_config.dart';
import 'app/core/flavors/values/dev_values.dart';
import 'main_common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
    flavor: Flavor.dev,
    values: DevelopmentValues(),
  );

  await mainCommon();
}
