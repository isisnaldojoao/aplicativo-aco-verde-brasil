import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:design_system/design_system.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';

import '../../helpers/helpers.dart';
import '../models/counter_model.dart';
import '../models/models.dart';

class InventoryDataSource {
  final Dio client;

  InventoryDataSource({
    required this.client,
  });

  bool enableMock = false;

  final table = Hive.openBox<CounterModel>('counter');
  final tableLamination = Hive.openBox<String>('lamination-inventory');

  Future<int> nextCounter(String position) async {
    try {
      final result = (await table).values.toList();
      return result.where((element) => element.position == position).length + 1;
    } catch (e) {
      return 1;
    }
  }

  Future<int> pending(String email) async {
    try {
      final result = (await table).values.toList();
      final avaliable =
          result.where((element) => element.isPendingToSend(email));
      return avaliable.length;
    } catch (e) {
      return 0;
    }
  }

  Future<int> sended(String email) async {
    try {
      final result = (await table).values.toList();
      final avaliable = result.where((element) => element.isSended(email));
      return avaliable.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> finishCounter(
    int counter,
    String position,
    String email,
  ) async {
    final index = '$position$counter';

    final box = (await table);
    final result = box.values.toList();
    final counterItem = result.firstWhere(
      (element) =>
          element.number == counter &&
          element.position == position &&
          element.email == email,
    );
    final data = counterItem.copyWith(isFinished: true);
    await box.put(index, data);
  }

  Future<void> setCounterOnline(
    int counter,
    String position,
    String email,
  ) async {
    final index = '$position$counter';

    final box = (await table);
    final result = box.values.toList();
    final counterItem = result.firstWhere((element) =>
        element.number == counter &&
        element.position == position &&
        element.email == email);
    final data = counterItem.copyWith(isOnline: true);
    await box.put(index, data);
  }

  Future<void> save({
    required InventoryModel item,
    required int counter,
    required String email,
    required String position,
  }) async {
    final box = await table;

    final index = '$position$counter';

    final result = box.values.toList();

    if (result.any((element) =>
        element.number == counter &&
        element.position == position &&
        element.email == email)) {
      final counterItem = result.firstWhere((element) =>
          element.number == counter &&
          element.position == position &&
          element.email == email);

      if (counterItem.isFinished) {
        throw Exception('Contagem já foi finalizada');
      }

      final items = List<InventoryModel>.from(counterItem.items);
      items.add(item);
      final data = counterItem.copyWith(items: items);
      await box.put(index, data);
    } else {
      await box.put(
        index,
        CounterModel(
          email: email,
          number: counter,
          createdAt: DateTime.now(),
          items: [item],
          isFinished: false,
          position: position,
          isOnline: false,
        ),
      );
    }
  }

  Future<void> downloadLaminationInventory() async {
    try {
      var list = [];
      if (enableMock) {
        list = ['item 1', 'Item 3', 'item 2'];
      } else {
        final result = await client.get('/lamination-inventory/positions');
        list = result.data as List;
      }

      final box = (await tableLamination);
      await box.clear();
      await box.addAll(list.map((e) => e.toString()).toList());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> clear() async {
    (await table).clear();
  }

  Future<int> syncData(String email, BuildContext context) async {
    try {
      final result = (await table).values.toList();

      int errors = 0;

      final pendingList = result
          .where((element) =>
              !element.isOnline && element.isFinished && element.email == email)
          .toList();

      for (final item in pendingList) {
        try {
          if (!enableMock) {
            await client.post(
              '/lamination-inventory/create',
              data: item.toMap(),
            );
          } else {
            print(item.toMap().toString());
          }

          await setCounterOnline(item.number, item.position, item.email);
        } on DioError catch (e) {
          errors++;
          AppSnackBar.show(
            text:
                'Erro ao sincronizar posição: ${item.position} e cotagem ${item.number} ------- ERROR: ${e.error.toString()}',
            context: context,
          );
        }
      }
      return errors;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<Either<CommonError, List<String>>> getAllLaminationInventory() async {
    try {
      final result = (await tableLamination).values.toList();

      if (result.isEmpty) {
        await downloadLaminationInventory();
        final result2 = (await tableLamination).values.toList();
        if (result2.isEmpty) {
          return const Left(CommonError.notFound());
        }
        return Right(result2);
      }

      return Right(result);
    } catch (e) {
      return const Left(CommonError.unauthenticated());
    }
  }

  Future<CounterModel?> getPendingInventory(
    String email,
  ) async {
    try {
      final result = (await table).values.toList();

      final pending = result
          .where(
            (element) =>
                !element.isOnline &&
                !element.isFinished &&
                element.email == email,
          )
          .toList();
      return pending.isNotEmpty ? pending.first : null;
    } catch (e) {
      return null;
    }
  }
}
