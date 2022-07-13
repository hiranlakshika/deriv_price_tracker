import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class RemoteConfigService {
  Future<FirebaseRemoteConfig> getRemoteConfig();
}