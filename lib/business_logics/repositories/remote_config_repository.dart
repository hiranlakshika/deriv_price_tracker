import 'package:firebase_remote_config/firebase_remote_config.dart';

abstract class RemoteConfigRepository {
  Future<FirebaseRemoteConfig> initRemoteConfig();
}
