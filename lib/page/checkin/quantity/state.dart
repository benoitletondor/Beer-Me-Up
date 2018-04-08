import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/model/checkin.dart';
import 'package:beer_me_up/model/beer.dart';

class CheckInQuantityState extends Union3Impl<
    CheckInQuantityStateBase,
    CheckInQuantityQuantitySelected,
    CheckInQuantityQuantityNotSelectedError> {

  CheckInQuantity currentStateSelectedQuantity;

  static final Triplet<
      CheckInQuantityStateBase,
      CheckInQuantityQuantitySelected,
      CheckInQuantityQuantityNotSelectedError> factory = const Triplet<
        CheckInQuantityStateBase,
        CheckInQuantityQuantitySelected,
        CheckInQuantityQuantityNotSelectedError> ();

  CheckInQuantityState._(Union3<
      CheckInQuantityStateBase,
      CheckInQuantityQuantitySelected,
      CheckInQuantityQuantityNotSelectedError> union, {this.currentStateSelectedQuantity}) : super(union);

  factory CheckInQuantityState.base(Beer selectedBeer) => new CheckInQuantityState._(factory.first(new CheckInQuantityStateBase(selectedBeer)));
  factory CheckInQuantityState.quantitySelected(Beer selectedBeer, CheckInQuantity quantity) => new CheckInQuantityState._(factory.second(new CheckInQuantityQuantitySelected(selectedBeer, quantity)), currentStateSelectedQuantity: quantity);
  factory CheckInQuantityState.error(Beer selectedBeer) => new CheckInQuantityState._(factory.third(new CheckInQuantityQuantityNotSelectedError(selectedBeer)));
}

class CheckInQuantityStateBase {
  final Beer selectedBeer;

  CheckInQuantityStateBase(this.selectedBeer);
}
class CheckInQuantityQuantitySelected {
  final Beer selectedBeer;
  final CheckInQuantity quantity;

  CheckInQuantityQuantitySelected(this.selectedBeer, this.quantity);
}
class CheckInQuantityQuantityNotSelectedError {
  final Beer selectedBeer;

  CheckInQuantityQuantityNotSelectedError(this.selectedBeer);
}