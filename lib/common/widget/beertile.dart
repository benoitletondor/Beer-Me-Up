import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/common/hapticfeedback.dart';

class BeerTile extends StatelessWidget {
  final Beer beer;
  final String title;
  final String subtitle;
  final String thirdTitle;
  final GestureTapCallback onTap;

  BeerTile({
    @required this.beer,
    @required this.title,
    this.subtitle,
    this.thirdTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if( beer == null || title == null ) {
      return new Container();
    }

    final List<Widget> children = new List();
    children.add(new Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: new TextStyle(
        color: Colors.blueGrey[900],
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
    ));

    if( subtitle != null ) {
      children.add(new Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          color: Colors.blueGrey[900],
          fontSize: 15.0,
        ),
      ));
    }

    if( thirdTitle != null ) {
      children.add(new Padding(padding: EdgeInsets.only(top: 5.0)));
      children.add(new Text(
        thirdTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(
          color: Colors.blueGrey[500],
          fontSize: 14.0,
        ),
      ));
    }

    return new InkWell(
      onTap: onTap != null ? () {
        performSelectionHaptic(context);
        onTap();
      } : null,
      child: new Semantics(
        enabled: onTap != null,
        child: new Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          child: new Row(
            children: <Widget>[
              _buildThumbnailImage(beer),
              new Padding(padding: EdgeInsets.only(right: 16.0)),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailImage(Beer beer) {
    Widget image;
    if (beer.label?.iconUrl == null) {
      image = new Icon(const IconData(0xe900, fontFamily: "beers"));
    } else {
      image = new Image.network(
        beer.label.iconUrl,
      );
    }

    return new Stack(
      children: <Widget>[
        new Image.asset(
          "images/beer_icon_background.png",
          width: 55.0,
        ),
        new Container(
          padding: new EdgeInsets.only(left: 16.0, top: 7.0),
          child: new ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 25.0, maxHeight: 35.0),
            child: new Center(
              child: image,
            ),
          ),
        ),
      ],
    );
  }
}