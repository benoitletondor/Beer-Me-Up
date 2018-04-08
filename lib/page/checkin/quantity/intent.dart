import 'package:flutter_stream_friends/flutter_stream_friends.dart';

import 'package:beer_me_up/model/checkin.dart';

class CheckInQuantityIntent {
  final ValueStreamCallback<CheckInQuantity> quantitySelected;
  final VoidStreamCallback checkInConfirmed;

  CheckInQuantityIntent({
    final ValueStreamCallback<CheckInQuantity> quantitySelectedIntent,
    final VoidStreamCallback checkInConfirmedIntent,
  }) :
    this.quantitySelected = quantitySelectedIntent ?? new ValueStreamCallback<CheckInQuantity>(),
    this.checkInConfirmed = checkInConfirmedIntent ?? new VoidStreamCallback();
}