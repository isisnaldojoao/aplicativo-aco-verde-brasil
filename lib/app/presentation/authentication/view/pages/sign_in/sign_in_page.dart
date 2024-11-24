import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../provider/authentication_provider.dart';
import '../../../states/sign_in/sign_in_state_notifier.dart';
import '../../mixins/sign_in_mixin.dart';
import '../../widgets/widget.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> with SignInMixin {
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

  final _focusEmail = FocusNode();

  @override
  Widget build(BuildContext context) {
    listenSingIn();
    final state = ref.watch(stateSignInProvider);
    return Scaffold(
      backgroundColor: AppColors.brand1,
      body: Form(
        key: formKey,
        child: BodyStyle(
          title: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child:
                Center(child: PictureWidget.asset(ImagesConstants.logoWhite)),
          ),
          items: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              const Space.x10(),
              Center(child: BoxText.headingThree('Boas vindas!')),
              const Space.x2(),
              Center(child: BoxText.body('Faça login para continuar')),
              const SizedBox(height: 60),
              InputWidget(
                controller: emailController,
                validator: Validators.email,
                focus: _focusEmail,
                action: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                hintText: 'example@email.com',
                labelText: 'E-mail',
              ),
              const Space.x5(),
              InputWidget(
                controller: passwordController,
                hintText: 'Senha',
                labelText: 'Senha',
                sufix: EyePasswordWidget(
                  onChanged: () => setState(() => visibility = !visibility),
                  isObscure: visibility,
                ),
                lines: 1,
                obscureText: visibility,
                validator: (text) {
                  if (text!.length < 6) {
                    return 'Senha inválida';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                onSubmitted: (p0) {
                  onTapButton();
                },
              ),
              const Space.x5(),
              ButtonWidget(
                title: 'ENTRAR',
                isLoading: state == const SignInState.loadInProgress(),
                onTap: onTapButton,
              ),
              const Space.x5(),
              const RegisterOptionWidget(),
              const SizedBox(height: 50),
              BoxText.body(
                'Versão $appVersion',
                textAlign: TextAlign.center,
              ),
              const Space.x10(),
            ],
          ),
        ),
      ),
    );
  }
}

class BoxDecorationWidget {
  BoxDecoration get getDecoration {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(35),
        topLeft: Radius.circular(35),
      ),
    );
  }
}

class BodyStyle extends StatelessWidget {
  final Widget items;
  final Widget? title;
  const BodyStyle({super.key, required this.items, this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          title ??
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
              ),
          Container(
            width: double.maxFinite,
            decoration: BoxDecorationWidget().getDecoration,
            child: items,
          ),
        ],
      ),
    );
  }
}
