import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

class SyncDialogWidget extends ConsumerStatefulWidget {
  const SyncDialogWidget({
    super.key,
    required this.syncFinished,
    this.errors,
  });
  final bool syncFinished;
  final int? errors;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SyncDialogWidgetState();
}

class _SyncDialogWidgetState extends ConsumerState<SyncDialogWidget> {
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
            height: 60,
            width: 60,
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: const [Color(0xFF444444)],
              pause: widget.syncFinished,
            ),
          ),
          const Space.x10(),
          BoxText.headingTwo(
            widget.syncFinished
                ? 'Sincronizado com sucesso!'
                : 'Sincronizando...',
            textAlign: TextAlign.center,
          ),
          const Space.x2(),
          BoxText.body(
            widget.syncFinished
                ? 'A sincronização foi finalizada. Ocorreram ${widget.errors ?? 0} erros.'
                : 'Aguarde enquanto a contagem esta sendo sincronizada.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
