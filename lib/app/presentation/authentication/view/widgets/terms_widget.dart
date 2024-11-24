import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsWidget extends StatelessWidget {
  const TermsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Ao registrar você concorda com nossos ',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).primaryColor,
          ),
          children: <TextSpan>[
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    Navigator.pushNamed(context, '/authentication/sign-up'),
              text: ' termos de uso  ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const TextSpan(text: ' e '),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    Navigator.pushNamed(context, '/authentication/sign-up'),
              text: 'Política de privacidade',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
