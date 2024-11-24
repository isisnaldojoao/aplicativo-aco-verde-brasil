import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

class FinalizeInventoryCountDialogWidget extends ConsumerStatefulWidget {
  const FinalizeInventoryCountDialogWidget({
    super.key,
    required this.isFinished,
  });

  final bool isFinished;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FinalizeInventoryCountDialogWidgetState();
}

class _FinalizeInventoryCountDialogWidgetState
    extends ConsumerState<FinalizeInventoryCountDialogWidget> {
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
          SizedBox(
            height: 40,
            width: 40,
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: const [Color(0xFF444444)],
              pause: widget.isFinished,
            ),
          ),
          const Space.x10(),
          BoxText.headingTwo(
            widget.isFinished
                ? 'Contagem finalizada!'
                : 'Finalizando contagem...',
            textAlign: TextAlign.center,
          ),
          const Space.x2(),
          BoxText.body(
            widget.isFinished
                ? 'Sincronize a contagem que foi finalizada!'
                : 'Aguarde enquanto a contagem esta sendo finalizada.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
