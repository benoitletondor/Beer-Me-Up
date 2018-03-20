import 'package:meta/meta.dart';

import 'package:beer_me_up/model/beer.dart';

class CheckIn {
  final DateTime date;
  final Beer beer;

  CheckIn({
    @required this.date,
    @required this.beer,
  });
}