import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

import 'model.dart';

class HistoryState extends Union3Impl<
    HistoryStateLoading,
    HistoryStateLoad,
    HistoryStateError> {

  static final Triplet<
      HistoryStateLoading,
      HistoryStateLoad,
      HistoryStateError> factory = const Triplet<
      HistoryStateLoading,
      HistoryStateLoad,
      HistoryStateError>();

  HistoryState._(Union3<
      HistoryStateLoading,
      HistoryStateLoad,
      HistoryStateError> union) : super(union);

  factory HistoryState.loading() => new HistoryState._(factory.first(new HistoryStateLoading()));
  factory HistoryState.load(List<HistoryListItem> items) => new HistoryState._(factory.second(new HistoryStateLoad(items)));
  factory HistoryState.error(String error) => new HistoryState._(factory.third(new HistoryStateError(error)));
}

class HistoryStateLoading extends State {}

class HistoryStateLoad extends State {
  final List<HistoryListItem> items;

  HistoryStateLoad(this.items);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is HistoryStateLoad &&
        runtimeType == other.runtimeType &&
        items == other.items;

  @override
  int get hashCode =>
      super.hashCode ^
      items.hashCode;
}

class HistoryStateError extends State {
  final String error;

  HistoryStateError(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
        other is HistoryStateError &&
        runtimeType == other.runtimeType &&
        error == other.error;

  @override
  int get hashCode =>
      super.hashCode ^
      error.hashCode;
}