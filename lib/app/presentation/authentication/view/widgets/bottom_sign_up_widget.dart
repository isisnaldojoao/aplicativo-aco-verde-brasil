import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BottomSignUpWidget extends StatelessWidget {
  const BottomSignUpWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Já tem uma conta?',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
              text: ' Entre',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
