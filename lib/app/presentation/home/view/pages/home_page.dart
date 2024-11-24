import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../widgets/clear_data_widget.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/inventory_widget.dart';
import '../widgets/sync_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PictureWidget.asset(ImagesConstants.logColorful),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      drawer: const DrawerWidget(),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          BoxText.headingThree('Boas vindas! 👋'),
          const Space.x6(),
          BoxText.smallBody('Início'),
          const Space.x4(),
          const InventoryWidget(),
          const Space.x10(),
          BoxText.smallBody('Sincronização'),
          const Space.x4(),
          const SycnWidget(),
          const Space.x10(),
          BoxText.smallBody('Limpar contagem'),
          const Space.x4(),
          const ClearDataWidget(),
          const Space.x8(),
          Center(child: BoxText.body('Versão $appVersion')),
        ],
      ),
    );
  }
}
