import 'package:flutter_stream_friends/flutter_stream_friends.dart';

import 'package:beer_me_up/model/beer.dart';

class CheckInIntent {
  final ValueStreamCallback<String> input;
  final ValueStreamCallback<Beer> beerSelected;

  CheckInIntent({
    final ValueStreamCallback<String> inputIntent,
    final ValueStreamCallback<Beer> beerSelectedIntent,
  }) :
    this.input = inputIntent ?? new ValueStreamCallback<String>(),
    this.beerSelected = beerSelectedIntent ?? new ValueStreamCallback<Beer>();
}