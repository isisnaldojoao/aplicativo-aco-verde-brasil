import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/client/api_client_factory.dart';
import '../../core/flavors/config/flavor_config.dart';
import '../data_sources/authentication_data_source.dart';
import '../data_sources/inventory_data_source.dart';

final apiClient = Provider(
  (ref) => ApiClientFactory.create(
    baseUrl: FlavorConfig.instance!.values.baseUrl,
  ),
);

final authDatasourceProvider = Provider(
  (ref) => AuthenticationDataSource(
    client: ref.read(apiClient),
  ),
);

final inventoryDatasourceProvider = Provider(
  (ref) => InventoryDataSource(
    client: ref.read(apiClient),
  ),
);
