import 'package:rxdart/rxdart.dart';

import '../models/symbol.dart';
import '../models/tick.dart';
import 'bloc_holder.dart';

class PriceTrackerBloc extends BlocBase {
  /* Rxdart objects */
  final _symbolsSubject = BehaviorSubject<List<SymbolModel>>();
  final _tickSubject = BehaviorSubject<Tick>();

  /* Streams */
  Stream<List<SymbolModel>> get symbolsStream => _symbolsSubject.stream;

  Stream<Tick> get ticksStream => _tickSubject.stream;

  void addSymbols(List<SymbolModel> symbols) {
    _symbolsSubject.sink.add(symbols);
  }

  void addTick(Tick tick) {
    _tickSubject.sink.add(tick);
  }

  @override
  void dispose() {
    _symbolsSubject.close();
  }
}
