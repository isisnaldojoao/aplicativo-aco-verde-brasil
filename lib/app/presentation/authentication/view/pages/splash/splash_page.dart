import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../mixins/splash_mixin.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with SplashMixin {
  @override
  Widget build(BuildContext context) {
    listen();
    return Scaffold(
      backgroundColor: AppColors().kcPrimary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100,
            child: Center(
              child: PictureWidget.asset(ImagesConstants.logoWhite),
            ),
          ),
        ],
      ),
    );
  }
}
