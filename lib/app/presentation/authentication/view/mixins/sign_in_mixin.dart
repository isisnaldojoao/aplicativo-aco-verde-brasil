import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/authentication_provider.dart';
import '../../states/states.dart';
import '../pages/pages.dart';

mixin SignInMixin<T extends SignInPage> on ConsumerState<T> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool visibility = true;

  int tries = 0;

  void listenSingIn() {
    ref.listen<SignInState>(stateSignInProvider, (previous, next) {
      next.maybeWhen(
        loadSuccess: (data) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/auth',
            (route) => false,
          );
        },
        loadFailure: (message) {
          AppSnackBar.show(context: context, text: message);
          setState(() {
            tries++;
          });
        },
        orElse: () {},
      );
    });
  }

  void onTapButton() {
    if (formKey.currentState!.validate()) {
      ref.read(stateSignInProvider.notifier).load(
            email: emailController.text,
            password: passwordController.text,
            tries: tries,
          );
    }
  }
}
