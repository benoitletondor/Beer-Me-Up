import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

import 'package:beer_me_up/model/beer.dart';

class CheckInState extends Union7Impl<
    CheckInStateInputEmpty,
    CheckInStateInputEmptyLastBeerCheckIns,
    CheckInStateSearching,
    CheckInStateSearchingWithPredictions,
    CheckInStatePredictionsAvailable,
    CheckInStateNoPredictionsAvailable,
    CheckInStateError> {

  static final Septet<
      CheckInStateInputEmpty,
      CheckInStateInputEmptyLastBeerCheckIns,
      CheckInStateSearching,
      CheckInStateSearchingWithPredictions,
      CheckInStatePredictionsAvailable,
      CheckInStateNoPredictionsAvailable,
      CheckInStateError> factory = Septet<
        CheckInStateInputEmpty,
        CheckInStateInputEmptyLastBeerCheckIns,
        CheckInStateSearching,
        CheckInStateSearchingWithPredictions,
        CheckInStatePredictionsAvailable,
        CheckInStateNoPredictionsAvailable,
        CheckInStateError>();

  CheckInState._(Union7<
      CheckInStateInputEmpty,
      CheckInStateInputEmptyLastBeerCheckIns,
      CheckInStateSearching,
      CheckInStateSearchingWithPredictions,
      CheckInStatePredictionsAvailable,
      CheckInStateNoPredictionsAvailable,
      CheckInStateError> union) : super(union);

  factory CheckInState.empty() => CheckInState._(factory.first(CheckInStateInputEmpty()));
  factory CheckInState.emptyLastBeers(List<Beer> beers) => CheckInState._(factory.second(CheckInStateInputEmptyLastBeerCheckIns(beers)));
  factory CheckInState.searching() => CheckInState._(factory.third(CheckInStateSearching()));
  factory CheckInState.searchingWithPredictions(List<Beer> previousPredictions) => CheckInState._(factory.fourth(CheckInStateSearchingWithPredictions(previousPredictions)));
  factory CheckInState.predictions(List<Beer> predictions) => CheckInState._(factory.fifth(CheckInStatePredictionsAvailable(predictions)));
  factory CheckInState.noPredictions() => CheckInState._(factory.sixth(CheckInStateNoPredictionsAvailable()));
  factory CheckInState.error(String error) => CheckInState._(factory.seventh(CheckInStateError(error)));
}

class CheckInStateInputEmpty extends State {}

class CheckInStateInputEmptyLastBeerCheckIns extends State {
  final List<Beer> beers;

  CheckInStateInputEmptyLastBeerCheckIns(this.beers);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CheckInStateInputEmptyLastBeerCheckIns &&
              runtimeType == other.runtimeType &&
              beers == other.beers;

  @override
  int get hashCode =>
      super.hashCode ^
      beers.hashCode;
}

class CheckInStateSearching extends State {}

class CheckInStateSearchingWithPredictions extends State {
  final List<Beer> previousPredictions;

  CheckInStateSearchingWithPredictions(this.previousPredictions);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CheckInStateSearchingWithPredictions &&
          runtimeType == other.runtimeType &&
          previousPredictions == other.previousPredictions;

  @override
  int get hashCode =>
      super.hashCode ^
      previousPredictions.hashCode;
}

class CheckInStatePredictionsAvailable extends State {
  final List<Beer> predictions;

  CheckInStatePredictionsAvailable(this.predictions);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CheckInStatePredictionsAvailable &&
        runtimeType == other.runtimeType &&
        predictions == other.predictions;

  @override
  int get hashCode =>
      super.hashCode ^
      predictions.hashCode;
}

class CheckInStateNoPredictionsAvailable extends State {}


class CheckInStateError extends State {
  final String error;

  CheckInStateError(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is CheckInStateError &&
        runtimeType == other.runtimeType &&
        error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^
      error.hashCode;
}

class AutoCompleteResponse {
  final List<Beer> predictions;
  final bool status;
  final String errorMessage;

  AutoCompleteResponse._(this.status, this.errorMessage, this.predictions);

  factory AutoCompleteResponse.error(String error) => AutoCompleteResponse._(false, error, []);
  factory AutoCompleteResponse.empty() => AutoCompleteResponse._(true, null, []);
  factory AutoCompleteResponse.success(List<Beer> predictions) => AutoCompleteResponse._(true, null, predictions);

  bool isSuccessful() => status;
  bool isEmpty() => predictions.isEmpty;
  bool isError() => !status;
}