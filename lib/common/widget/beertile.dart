import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/model/checkin.dart';

class BeerTile extends StatelessWidget {
  static final _dateFormatter = new DateFormat.Hm();

  final Beer beer;
  final CheckIn associatedCheckin;
  final GestureTapCallback onTap;

  BeerTile({
    @required this.beer,
    this.onTap,
    this.associatedCheckin,
  });

  @override
  Widget build(BuildContext context) {
    String subtitle;
    if( associatedCheckin != null ) {
      String quantity;
      switch(associatedCheckin.quantity) {
        case CheckInQuantity.PINT:
          quantity = "Pint";
          break;
        case CheckInQuantity.HALF_PINT:
          quantity = "Half pint";
          break;
        case CheckInQuantity.BOTTLE:
          quantity = "Bottle";
          break;
      }

      subtitle = "$quantity - ${_dateFormatter.format(associatedCheckin.date)}";
    } else if( beer.style?.shortName != null ) {
      subtitle = beer.style.shortName;
    } else if( beer.style?.name != null ) {
      subtitle = beer.style.name;
    }

    return new ListTile(
      leading: buildThumbnailImage(beer),
      title: new Text(beer.name),
      subtitle: subtitle != null ? new Text(subtitle) : null,
      onTap: onTap,
    );
  }

  static Widget buildThumbnailImage(Beer beer) {
    if( beer.label?.iconUrl == null ) {
      return new Icon(const IconData(0xe900, fontFamily: "beers"));
    }

    return new Image.network(beer.label.iconUrl);
  }
}