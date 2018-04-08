import 'package:beer_me_up/model/beer.dart';

class BeerCheckInsData {
  final Beer beer;
  final int numberOfCheckIns;
  final DateTime lastCheckinTime;
  final double drankQuantity;

  BeerCheckInsData(this.beer, this.numberOfCheckIns, this.lastCheckinTime, this.drankQuantity);
}