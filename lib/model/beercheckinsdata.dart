import 'package:beer_me_up/model/beer.dart';

class BeerCheckInsData {
  final Beer beer;
  final int numberOfCheckIns;
  final DateTime lastCheckinTime;
  final double drankQuantity;
  final int rating;

  BeerCheckInsData(this.beer, this.numberOfCheckIns, this.lastCheckinTime, this.drankQuantity, this.rating);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BeerCheckInsData &&
              runtimeType == other.runtimeType &&
              beer == other.beer &&
              numberOfCheckIns == other.numberOfCheckIns &&
              lastCheckinTime == other.lastCheckinTime &&
              drankQuantity == other.drankQuantity &&
              rating == other.rating;

  @override
  int get hashCode =>
      beer.hashCode ^
      numberOfCheckIns.hashCode ^
      lastCheckinTime.hashCode ^
      drankQuantity.hashCode ^
      rating != null ? rating.hashCode : 0;
}