import 'package:meta/meta.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';

import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';

class CheckInIntent {
  final ValueStreamCallback<String> input;
  final ValueStreamCallback<Beer> beerSelected;

  CheckInIntent({
    final ValueStreamCallback<String> inputIntent,
    final ValueStreamCallback<Beer> beerSelectedIntent,
  }) :
    this.input = inputIntent ?? ValueStreamCallback<String>(),
    this.beerSelected = beerSelectedIntent ?? ValueStreamCallback<Beer>();
}

class SelectedQuantityIntentValue {
  final Beer selectedBeer;
  final CheckInQuantity quantity;

  SelectedQuantityIntentValue({
    @required this.selectedBeer,
    @required this.quantity,
  });
}