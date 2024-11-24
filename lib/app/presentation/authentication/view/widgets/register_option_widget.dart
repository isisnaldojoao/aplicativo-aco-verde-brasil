import 'package:design_system/design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterOptionWidget extends StatelessWidget {
  const RegisterOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'Não possui conta? ',
            style: const TextStyle(color: Colors.black, fontSize: 12),
            children: <TextSpan>[
              TextSpan(
                text: ' Solicitar acesso',
                style: const TextStyle(color: AppColors.blue, fontSize: 12),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    //TODO:
                  },
              )
            ],
          ),
        ),
      ),
    );
  }
}
