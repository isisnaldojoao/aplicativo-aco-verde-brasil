import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/home_provider.dart';
import '../mixin/count_inventory_mixin.dart';

// Modelo para os registros recentes
class UDRecord {
  final String ud;
  final DateTime timestamp;

  UDRecord(this.ud) : timestamp = DateTime.now();
}

// Provedor para gerenciar os registros recentes
class RecentUDRecordsNotifier extends ChangeNotifier {
  final List<UDRecord> _records = [];

  List<UDRecord> get records => List.unmodifiable(_records);

  void addRecord(String ud) {
    _records.insert(0, UDRecord(ud));
    if (_records.length > 5) _records.removeLast();
    notifyListeners();
  }

  bool contains(String ud) {
    return _records.any((record) => record.ud == ud);
  }
}

final recentUDRecordsProvider =
    ChangeNotifierProvider((_) => RecentUDRecordsNotifier());

class CountInventoryPage extends ConsumerStatefulWidget {
  const CountInventoryPage({super.key});

  @override
  ConsumerState<CountInventoryPage> createState() => _CountInventoryPageState();
}

class _CountInventoryPageState extends ConsumerState<CountInventoryPage>
    with CountInventoryMixin {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    final positions = ref.watch(positionsStateProvider);
    final recentUDRecords = ref.watch(recentUDRecordsProvider);

    saveInventoryCountListen();
    listenPendingCount();
    finalizeInventoryCountListen();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.brand1,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Contagem inventário laminação',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: formkey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24).copyWith(top: 36),
                children: [
                  // Campo para selecionar posição
                  Select(
                    context: context,
                    error: positions.maybeMap(
                      orElse: () => null,
                      loadFailure: (value) => 'Erro ao baixar dados',
                    ),
                    items: positions.maybeWhen(
                      orElse: () => [],
                      loadSuccess: (data) => data
                          .map((e) => SelectItem(label: e, value: e))
                          .toList(),
                    ),
                    label: 'Posição',
                    value: position,
                    onChanged: (value) async {
                      position = value;
                      await ref.read(nextCountProvider.notifier).load(value);
                      counter = ref.read(nextCountProvider);
                      countController.text =
                          ref.read(nextCountProvider).toString();
                      focus.requestFocus();
                    },
                  ),
                  const Space.x5(),
                  // Input para a UD
                  InputWidget(
                    controller: udController,
                    labelText: 'UD',
                    hintText: 'Insira aqui a UD',
                    focus: focus,
                    maxLenght: 33,
                    validator: (p0) {
                      if ((p0?.length ?? 0) < 10) {
                        return 'Nº UD insuficiente, mínimo de 10 caracteres.';
                      }
                      if ((p0?.length ?? 0) > 33) {
                        return 'UD pode ter no máximo 33 caracteres.';
                      }
                      if (int.tryParse(p0!) == null) {
                        return 'Nº UD incorreto, insira um número válido.';
                      }
                      if (recentUDRecords.contains(p0!)) {
                        return 'Esta UD já foi registrada recentemente.';
                      }
                      return null;
                    },
                    action: TextInputAction.send,
                    onSubmitted: (p0) {
                      if (enabledSaveButton() &&
                          formkey.currentState!.validate()) {
                        focus.unfocus();
                        onSave();
                      }
                    },
                    onChanged: (value) => setState(() {
                      enabledSaveButton();
                    }),
                  ),
                  const Space.x5(),
                  // Outros campos de entrada
                  InputWidget(
                    controller: countController,
                    labelText: 'Número da contagem',
                    hintText: 'Insira aqui o n˚ da contagem',
                    isEnabled: false,
                  ),
                  const Space.x5(),
                  InputWidget(
                    controller: unityQtdController,
                    labelText: 'Qtd. UD contada',
                    hintText: '',
                    isEnabled: false,
                  ),
                  const Space.x10(),
                  // Botão para salvar
                  ButtonWidget(
                    title: isSaving ? 'SALVANDO...' : 'SALVAR',
                    onTap: enabledSaveButton() && !isSaving
                        ? () => onSave()
                        : null,
                  ),
                  const Space.x5(),
                  // Botão para finalizar
                  ButtonWidget(
                    title: 'FINALIZAR CONTAGEM',
                    onTap: udQuantity > 0 ? onFinished : null,
                  ),
                  const Space.x10(),
                  // Exibição de registros recentes
                  if (recentUDRecords.records.isNotEmpty) ...[
                    const Text(
                      'Registros Recentes:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Space.x5(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentUDRecords.records.length,
                      itemBuilder: (context, index) {
                        final record = recentUDRecords.records[index];
                        return ListTile(
                          leading: const Icon(Icons.inventory),
                          title: Text(record.ud),
                          subtitle: Text(_formatDateTime(record.timestamp)),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Future<void> onSave() async {
    if (!formkey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    final ud = udController.text;
    final recentRecordsNotifier = ref.read(recentUDRecordsProvider);

    // Verifica se a UD já foi registrada
    if (recentRecordsNotifier.contains(ud)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Esta UD já foi registrada recentemente')),
      );
      setState(() {
        isSaving = false;
      });
      return;
    }

    // Adiciona o registro e atualiza o estado
    recentRecordsNotifier.addRecord(ud);
    udController.clear();
    focus.requestFocus();

    await super.onSave();

    setState(() {
      isSaving = false;
    });
  }
}
