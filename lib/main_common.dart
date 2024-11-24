import 'package:flutter/cupertino.dart';

import 'app/app_widget.dart';
import 'app/data/hive/hive_init.dart';

Future<void> mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveInit().init();

  runApp(const AppWidget());
}
