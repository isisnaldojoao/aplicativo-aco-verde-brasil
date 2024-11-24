import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ClearDataSuccessWidget extends ConsumerStatefulWidget {
  const ClearDataSuccessWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ClearDataSuccessWidgetState();
}

class _ClearDataSuccessWidgetState
    extends ConsumerState<ClearDataSuccessWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 50,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 60,
            width: 60,
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: [Color(0xFF444444)],
              pause: false,
            ),
          ),
          const Space.x10(),
          BoxText.headingTwo(
            'Dados limpos com sucesso!',
            textAlign: TextAlign.center,
          ),
          const Space.x2(),
        ],
      ),
    );
  }
}
