import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SaveInventoryCountDialogWidget extends ConsumerStatefulWidget {
  const SaveInventoryCountDialogWidget({
    super.key,
    required this.saveSuccessfully,
  });

  final bool saveSuccessfully;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SaveInventoryCountDialogWidgetState();
}

class _SaveInventoryCountDialogWidgetState
    extends ConsumerState<SaveInventoryCountDialogWidget> {
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
              pause: widget.saveSuccessfully,
            ),
          ),
          const Space.x10(),
          BoxText.headingTwo(
            widget.saveSuccessfully
                ? 'Contagem salva!'
                : 'Salvando contagem...',
            textAlign: TextAlign.center,
          ),
          const Space.x2(),
          BoxText.body(
            widget.saveSuccessfully
                ? 'A contagem foi salva com sucesso.'
                : 'Aguarde enquanto a contagem esta sendo salva.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
