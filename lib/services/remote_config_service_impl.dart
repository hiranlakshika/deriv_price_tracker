import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../business_logics/repositories/remote_config_repository.dart';
import '../dependencies_locator.dart';
import 'remote_config_service.dart';

class RemoteConfigServiceImpl implements RemoteConfigService {
  final RemoteConfigRepository _remoteConfigRepository = serviceLocator<RemoteConfigRepository>();

  @override
  Future<FirebaseRemoteConfig> getRemoteConfig() => _remoteConfigRepository.initRemoteConfig();
}
