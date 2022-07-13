import 'package:get_it/get_it.dart';

import 'business_logics/blocs/price_tracker_bloc.dart';
import 'business_logics/repositories/remote_config_repository.dart';
import 'business_logics/repositories/remote_config_repository_impl.dart';
import 'services/remote_config_service.dart';
import 'services/remote_config_service_impl.dart';

GetIt serviceLocator = GetIt.instance;

injectDependencies() {
  // Singleton Blocs
  GetIt.I.registerLazySingleton(() => PriceTrackerBloc());

  // Repositories
  GetIt.I.registerLazySingleton<RemoteConfigRepository>(() => RemoteConfigRepositoryImpl());

  // Services
  GetIt.I.registerLazySingleton<RemoteConfigService>(() => RemoteConfigServiceImpl());
}
