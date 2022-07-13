import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../business_logics/blocs/price_tracker_bloc.dart';
import '../business_logics/models/symbol.dart';
import '../business_logics/models/tick.dart';
import '../dependencies_locator.dart';
import '../services/remote_config_service.dart';

class WebSocketConnectionManager {
  IOWebSocketChannel? _channel;
  final _priceTrackerBloc = serviceLocator<PriceTrackerBloc>();

  Future<void> _connect() async {
    await serviceLocator<RemoteConfigService>().getRemoteConfig().then((config) async {
      String appId = config.getString('app_id');
      _channel = IOWebSocketChannel.connect(Uri.parse('wss://ws.binaryws.com/websockets/v3?app_id=$appId'));
    });
  }

  Future<void> start() async {
    debugPrint(">>>>>>>>>>>>> initiating web socket");
    _listenSocket();
  }

  void stop() {
    _channel?.sink.close(status.normalClosure);
  }

  void _listenSocket() async {
    await _connect();
    getSymbols();
    _channel?.stream.listen((data) {
      debugPrint('>>>>>>>>>>>>> data : $data');
      if (data != null) {
        var decodedData = json.decode(data);
        if (decodedData != null) {
          if (decodedData['msg_type'] == 'active_symbols') {
            List<SymbolModel> symbols = List.from(
              decodedData['active_symbols'].map(
                (element) => SymbolModel.fromJson(element),
              ),
            );
            _priceTrackerBloc.addSymbols(symbols);
          } else if (decodedData['msg_type'] == 'tick') {
            Tick tick = Tick.fromJson(decodedData['tick']);
            _priceTrackerBloc.addTick(tick);
          }
        }
      }
    });
  }

  void getSymbols() {
    _channel?.sink.add(json.encode({"active_symbols": "brief", "product_type": "basic"}));
  }

  void getTicks(String symbol) {
    _channel?.sink.add(json.encode({"ticks": symbol, "subscribe": 1}));
  }
}
