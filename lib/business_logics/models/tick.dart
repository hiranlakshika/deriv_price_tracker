class Tick {
  Tick({
    required this.ask,
    required this.bid,
    required this.epoch,
    required this.id,
    required this.pipSize,
    required this.quote,
    required this.symbol,
  });

  late final double ask;
  late final double bid;
  late final int epoch;
  late final String id;
  late final int pipSize;
  late final double quote;
  late final String symbol;

  Tick.fromJson(Map<String, dynamic> json) {
    ask = json['ask'];
    bid = json['bid'];
    epoch = json['epoch'];
    id = json['id'];
    pipSize = json['pip_size'];
    quote = json['quote'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ask'] = ask;
    data['bid'] = bid;
    data['epoch'] = epoch;
    data['id'] = id;
    data['pip_size'] = pipSize;
    data['quote'] = quote;
    data['symbol'] = symbol;
    return data;
  }
}