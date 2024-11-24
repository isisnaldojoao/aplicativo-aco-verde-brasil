import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../authentication/provider/authentication_provider.dart';
import '../../../authentication/states/states.dart';
import '../../provider/home_provider.dart';
import '../../states/clear_data_state_notifier.dart';
import 'clear_data_success_widget.dart';

class ClearDataWidget extends ConsumerStatefulWidget {
  const ClearDataWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ClearDataWidgetState();
}

class _ClearDataWidgetState extends ConsumerState<ClearDataWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final user = ref.read(autenticationstate) as IsLogged;
      return ref.read(sendedDataStateProvider.notifier).load(user.user.email);
    });
  }

  void syncListen() {
    ref.listen<ClearDataState>(
      clearDataProvider,
      (previous, next) {
        next.maybeWhen(
          loadSuccess: (data) async {
            final user = ref.read(autenticationstate) as IsLogged;
            ref.read(pendingQuantityProvider.notifier).load(user.user.email);
            ref.read(sendedDataStateProvider.notifier).load(user.user.email);
            await Future.delayed(const Duration(milliseconds: 800));
            Navigator.pop(context);
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
    final state = ref.watch(sendedDataStateProvider);
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
            BoxText.body(
              'Limpar contadores e dados de invetário não sincronizados',
            ),
            const Space.x2(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: data > 0
                      ? () {
                          ref.read(clearDataProvider.notifier).load();
                          showDialog(
                            context: context,
                            builder: (context) =>
                                const ClearDataSuccessWidget(),
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
                      'Limpar dados',
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
