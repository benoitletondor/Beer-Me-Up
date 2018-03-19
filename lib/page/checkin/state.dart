import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/model/beer.dart';

class CheckInState extends Union4Impl<
    CheckInStateInputEmpty,
    CheckInStateSearching,
    CheckInStatePredictionsAvailable,
    CheckInStateError> {

  List<Beer> currentStatePredictions;

  static final Quartet<
      CheckInStateInputEmpty,
      CheckInStateSearching,
      CheckInStatePredictionsAvailable,
      CheckInStateError> factory = const Quartet<
        CheckInStateInputEmpty,
        CheckInStateSearching,
        CheckInStatePredictionsAvailable,
        CheckInStateError>();

  CheckInState._(Union4<
      CheckInStateInputEmpty,
      CheckInStateSearching,
      CheckInStatePredictionsAvailable,
      CheckInStateError> union, {this.currentStatePredictions}) : super(union);

  factory CheckInState.empty() => new CheckInState._(factory.first(new CheckInStateInputEmpty()));
  factory CheckInState.searching(List<Beer> previousPredictions) => new CheckInState._(factory.second(new CheckInStateSearching(previousPredictions)));
  factory CheckInState.predictions(List<Beer> predictions) => new CheckInState._(factory.third(new CheckInStatePredictionsAvailable(predictions)), currentStatePredictions: predictions);
  factory CheckInState.error(String error) => new CheckInState._(factory.fourth(new CheckInStateError(error)));
}

class CheckInStateInputEmpty {}
class CheckInStateSearching {
  final List<Beer> previousPredictions;

  CheckInStateSearching(this.previousPredictions);
}
class CheckInStatePredictionsAvailable {
  final List<Beer> predictions;

  CheckInStatePredictionsAvailable(this.predictions);
}
class CheckInStateError {
  final String error;

  CheckInStateError(this.error);
}

class AutoCompleteResponse {
  final List<Beer> predictions;
  final bool status;
  final String errorMessage;

  AutoCompleteResponse._(this.status, this.errorMessage, this.predictions);

  factory AutoCompleteResponse.error(String error) => new AutoCompleteResponse._(false, error, []);
  factory AutoCompleteResponse.empty() => new AutoCompleteResponse._(true, null, []);
  factory AutoCompleteResponse.success(List<Beer> predictions) => new AutoCompleteResponse._(true, null, predictions);

  bool isSuccessful() => status;
  bool isEmpty() => predictions.isEmpty;
  bool isError() => !status;
}