import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/provider/authentication_provider.dart';
import '../../../authentication/states/states.dart';
import '../../provider/home_provider.dart';
import '../../states/sync_pending_state_notifier.dart';
import 'sync_dialog_widget.dart';

class SycnWidget extends ConsumerStatefulWidget {
  const SycnWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SycnWidgetState();
}

class _SycnWidgetState extends ConsumerState<SycnWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(autenticationstate) as IsLogged;
      return ref.read(pendingQuantityProvider.notifier).load(user.user.email);
    });
  }

  void syncListen() {
    ref.listen<SyncPendingState>(
      syncPendingProvider,
      (previous, next) {
        next.maybeWhen(
          loadSuccess: (data) async {
            final user = ref.read(autenticationstate) as IsLogged;
            ref.read(pendingQuantityProvider.notifier).load(user.user.email);
            ref.read(sendedDataStateProvider.notifier).load(user.user.email);

            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) =>
                  SyncDialogWidget(syncFinished: true, errors: data),
            );

            if (data == 0) {
              await Future.delayed(const Duration(milliseconds: 800));
              Navigator.pop(context);
            }
          },
          loadFailure: (message) {
            Navigator.pop(context);
            AppSnackBar.show(
              context: context,
              text: 'A sincronização falhou. Tente novamente!',
            );
          },
          orElse: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    syncListen();
    final state = ref.watch(pendingQuantityProvider);
    return state.maybeWhen(
      loadInProgress: () => const SizedBox(
        height: 180,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      loadSuccess: (data) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.brand2,
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              spreadRadius: 0,
              offset: Offset(0, 2),
              color: Color.fromARGB(255, 200, 200, 200),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxText.headingThree(
              data > 0 ? 'Pendências' : 'Sem pendências',
            ),
            const Space.x2(),
            BoxText.body(
              data > 0
                  ? 'Há $data contagem pendente de sincronização'
                  : 'Não há sincronizações pendentes',
            ),
            const Space.x6(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: data > 0
                      ? () {
                          final user = ref.read(autenticationstate) as IsLogged;

                          ref
                              .read(syncPendingProvider.notifier)
                              .load(user.user.email, context);
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            useRootNavigator: false,
                            builder: (context) => const SyncDialogWidget(
                              syncFinished: false,
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 14,
                      right: 14,
                    ),
                    decoration: BoxDecoration(
                      color:
                          data > 0 ? AppColors.brand1 : const Color(0xffACACAC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BoxText.body(
                      'Sincronizar',
                      color: AppColors.brand2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      orElse: () => Container(),
    );
  }
}
