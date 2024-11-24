import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../data/models/user_model.dart';
import '../../../authentication/provider/authentication_provider.dart';
import '../../../authentication/states/authentication/check_authentication_state_notifier.dart';

class DrawerWidget extends ConsumerStatefulWidget {
  const DrawerWidget({super.key});

  @override
  ConsumerState<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends ConsumerState<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.brand1,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const Space.x8(),
          const Space.x8(),
          const Space.x8(),
          SizedBox(
            height: 60,
            child: PictureWidget.asset(ImagesConstants.logoWhite),
          ),
          const Space.x8(),
          _buildCard(),
          const Space.x4(),
          _buildSignOut(),
        ],
      ),
    );
  }

  Widget _buildCard() {
    final state = ref.watch(autenticationstate) as IsLogged;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff4B574E),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxText.bodyBold(
            state.user.username,
            color: Colors.white,
          ),
          const Space.x1(),
          BoxText.smallBody(
            state.user.email,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSignOut() {
    return GestureDetector(
      onTap: () async {
        final table = await Hive.openBox<UserModel>('user');

        await table.clear();

        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/auth',
          (route) => false,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff4B574E),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BoxText.bodyBold(
              'SAIR',
              color: Colors.white,
            ),
            const Space.x1(),
            const Icon(Icons.exit_to_app),
          ],
        ),
      ),
    );
  }
}
