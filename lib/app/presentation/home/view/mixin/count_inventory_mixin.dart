// ignore_for_file: use_build_context_synchronously

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/counter_model.dart';
import '../../../../data/models/models.dart';
import '../../../authentication/provider/authentication_provider.dart';
import '../../../authentication/states/states.dart';
import '../../provider/home_provider.dart';
import '../../states/finalize_inventory_count_state_notifier.dart';
import '../../states/save_inventory_count_state_notifier.dart';
import '../pages/count_inventory_page.dart';
import '../widgets/finalize_inventory_count_dialog_widget.dart';
import '../widgets/save_inventory_count_dialog_widget.dart';

mixin CountInventoryMixin on ConsumerState<CountInventoryPage> {
  final udController = TextEditingController();
  final countController = TextEditingController();
  var unityQtdController = TextEditingController(text: '0');
  int udQuantity = 0;
  int counter = 1;

  String? position;

  final focus = FocusNode();

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = ref.read(autenticationstate) as IsLogged;
      ref.read(positionsStateProvider.notifier).load();
      ref.read(pendingCounterStateProvider.notifier).load(user.user.email);
    });
  }

  bool enabledSaveButton() {
    final ud = udController.text;
    return (ud.isNotEmpty && ud.length >= 10 && ud.length <= 30) &&
        position != null;
  }

  void saveInventoryCountListen() {
    ref.listen<SaveInventoryCountState>(
      saveInventoryCountProvider,
      (previous, next) {
        next.maybeWhen(
          loadInProgress: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              useRootNavigator: false,
              builder: (context) => const SaveInventoryCountDialogWidget(
                saveSuccessfully: false,
              ),
            );
          },
          loadSuccess: (data) async {
            // SUCESSO AO SALVAR CONTAGEM

            // fecha dialog
            Navigator.pop(context);

            // abre novo dialog
            showDialog(
              context: context,
              builder: (context) => const SaveInventoryCountDialogWidget(
                saveSuccessfully: true,
              ),
            );

            // espera 800 ms para fechar
            await Future.delayed(const Duration(milliseconds: 500));
            Navigator.pop(context);

            // limpa os dados
            setState(() {
              udQuantity++;
              unityQtdController.text = udQuantity.toString();
              udController.clear();
            });

            // abre o teclado
            focus.requestFocus();
          },
          loadFailure: (message) {
            Navigator.pop(context);
            AppSnackBar.show(
              context: context,
              text: 'Não foi possível salvar a contagem. Tente novamente!',
            );
          },
          orElse: () {},
        );
      },
    );
  }

  Future<void> onSave() async {
    if (!formkey.currentState!.validate()) {
      return;
    }

    final ud = udController.text;
    final quantity = udQuantity + 1;

    final user = ref.read(autenticationstate) as IsLogged;

    ref.read(saveInventoryCountProvider.notifier).load(
          counter,
          user.user.email,
          position!,
          InventoryModel(
            ud: ud,
            index: quantity,
            createdAt: DateTime.now(),
          ),
        );

    // await Future.delayed(const Duration(milliseconds: 800));
    // Navigator.pop(context);

    // focus.requestFocus();

    // setState(() {
    //   udQuantity++;
    //   unityQtdController.text = udQuantity.toString();
    //   udController.clear();
    // });
  }

  Future<void> onFinished() async {
    final user = ref.read(autenticationstate) as IsLogged;

    ref.read(finalizeInventoryCountProvider.notifier).load(
          counter,
          position!,
          user.user.email,
        );
  }

  void listenPendingCount() {
    ref.listen<CounterModel?>(pendingCounterStateProvider, (previous, next) {
      if (next != null) {
        position = next.position;
        counter = next.number;
        countController.text = next.number.toString();
        udQuantity = next.items.length;
        unityQtdController.text = udQuantity.toString();
        setState(() {});
      }
    });
  }

  void finalizeInventoryCountListen() {
    ref.listen<FinalizeInventoryCountState>(
      finalizeInventoryCountProvider,
      (previous, next) {
        next.maybeWhen(
          loadSuccess: (data) async {
            final user = ref.read(autenticationstate) as IsLogged;
            ref.read(pendingQuantityProvider.notifier).load(user.user.email);

            showDialog(
              context: context,
              builder: (context) => const FinalizeInventoryCountDialogWidget(
                isFinished: true,
              ),
            );
            await Future.delayed(const Duration(milliseconds: 500));
            Navigator.pop(context);

            setState(() {
              udQuantity = 0;
              udController.clear();
              position = null;
              countController.clear();
              unityQtdController.text = udQuantity.toString();
            });
            focus.requestFocus();
          },
          loadFailure: (message) {
            Navigator.pop(context);
            AppSnackBar.show(
              context: context,
              text: 'Não foi possível finalizar a contagem. Tente novamente!',
            );
          },
          orElse: () {},
        );
      },
    );
  }
}
