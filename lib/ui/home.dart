import 'package:deriv_price_tracker/dependencies_locator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import '../services/remote_config_service.dart';

class MyHomePage extends StatelessWidget {
  final _remoteConfigService = serviceLocator<RemoteConfigService>();

  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deriv Price Tracker'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _remoteConfigService.getRemoteConfig(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              _loadingWidget();
            }
            if (snapshot.hasData) {
              debugPrint('Firebase Remote Config initialized');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  items: <String>['A', 'B', 'C', 'D'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                DropdownButton<String>(
                  items: <String>['A', 'B', 'C', 'D'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                Text(''),
              ],
            );
          }),
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _emptyItemsText() {
    return const Center(
      child: Text('Something went wrong! Please try later.'),
    );
  }
}
