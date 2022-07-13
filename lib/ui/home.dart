import 'package:flutter/material.dart';

import '../business_logics/blocs/price_tracker_bloc.dart';
import '../business_logics/models/symbol.dart';
import '../business_logics/models/tick.dart';
import '../dependencies_locator.dart';
import '../networking/web_scoket_connection_manager.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _webSocketManager = serviceLocator<WebSocketConnectionManager>();
  final _priceTrackerBloc = serviceLocator<PriceTrackerBloc>();

  final _markets = <String>[
    'Forex',
    'Synthetic indices',
    'Stocks & indices',
    'Cryptocurrencies',
    'Basket indices',
    'Commodities'
  ];

  String _marketValue = 'Forex';

  var _symbols = <String>[];

  String _symbolValue = '';

  double _initialPrice = 0;
  double _currentPrice = 0;

  Color _textColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deriv Price Tracker'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _webSocketManager.start(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _loadingWidget();
            }

            if(snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text('Markets'),
                    _marketDropDown(),
                    const SizedBox(
                      height: 30.0,
                    ),
                    const Text('Available symbols'),
                    _symbolsDropDown(),
                    const SizedBox(
                      height: 30.0,
                    ),
                    _currentPriceWidget(),
                  ],
                ),
              );
            }
            return _loadingWidget();
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

  Widget _marketDropDown() {
    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return DropdownButton<String>(
        value: _marketValue,
        items: _markets.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: const Text('Market'),
        onChanged: (newValue) {
          setState(() {
            _marketValue = newValue ?? '';
            _webSocketManager.getSymbols();
          });
        },
      );
    });
  }

  Widget _symbolsDropDown() {
    return StreamBuilder<List<SymbolModel>>(
        stream: _priceTrackerBloc.symbolsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            _loadingWidget();
          }

          if (snapshot.hasError) {
            return _emptyItemsText();
          }

          if (snapshot.hasData) {
            _symbols = snapshot.data
                    ?.where((element) => element.marketDisplayName == _marketValue)
                    .map((element) => element.symbol)
                    .toList() ??
                [];
            if (_symbols.isNotEmpty) _symbolValue = _symbols.first;
          }

          return DropdownButton<String>(
            value: _symbolValue,
            items: _symbols.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) _webSocketManager.getTicks(newValue);
            },
          );
        });
  }

  Widget _currentPriceWidget() {
    return StreamBuilder<Tick>(
        stream: _priceTrackerBloc.ticksStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _currentPrice = snapshot.data?.quote ?? 0;
            if (_initialPrice == 0) {
              _initialPrice = _currentPrice;
            }

            if (_currentPrice > _initialPrice) {
              _textColor = Colors.green;
            } else if (_currentPrice < _initialPrice) {
              _textColor = Colors.red;
            } else {
              _textColor = Colors.grey;
            }
          }

          return Text(
            'Current price : ${_currentPrice.toStringAsFixed(2)}',
            style: TextStyle(color: _textColor),
          );
        });
  }
}
