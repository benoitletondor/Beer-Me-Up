import 'package:sealed_unions/sealed_unions.dart';

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

class HistoryStateLoading {}
class HistoryStateLoad {
  final List<HistoryListItem> items;

  HistoryStateLoad(this.items);
}
class HistoryStateError {
  final String error;

  HistoryStateError(this.error);
}