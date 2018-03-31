import 'package:sealed_unions/sealed_unions.dart';

import 'package:beer_me_up/model/checkin.dart';

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
  factory HistoryState.load(List<CheckIn> checkIns, bool hasMore) => new HistoryState._(factory.second(new HistoryStateLoad(checkIns, hasMore)));
  factory HistoryState.error(String error) => new HistoryState._(factory.third(new HistoryStateError(error)));
}

class HistoryStateLoading {}
class HistoryStateLoad {
  final List<CheckIn> checkIns;
  final bool hasMore;

  HistoryStateLoad(this.checkIns, this.hasMore);
}
class HistoryStateError {
  final String error;

  HistoryStateError(this.error);
}