import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/common/mvi/state.dart';

import 'model.dart';

class HistoryState extends Union4Impl<
    HistoryStateLoading,
    HistoryStateLoad,
    HistoryStateEmpty,
    HistoryStateError> {

  static final Quartet<
      HistoryStateLoading,
      HistoryStateLoad,
      HistoryStateEmpty,
      HistoryStateError> factory = const Quartet<
      HistoryStateLoading,
      HistoryStateLoad,
      HistoryStateEmpty,
      HistoryStateError>();

  HistoryState._(Union4<
      HistoryStateLoading,
      HistoryStateLoad,
      HistoryStateEmpty,
      HistoryStateError> union) : super(union);

  factory HistoryState.loading() => HistoryState._(factory.first(HistoryStateLoading()));
  factory HistoryState.load(List<HistoryListItem> items) => HistoryState._(factory.second(HistoryStateLoad(items)));
  factory HistoryState.empty() => HistoryState._(factory.third(HistoryStateEmpty()));
  factory HistoryState.error(String error) => HistoryState._(factory.fourth(HistoryStateError(error)));
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

class HistoryStateEmpty extends State {}

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