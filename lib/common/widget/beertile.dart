import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import 'package:beer_me_up/model/beer.dart';
import 'package:beer_me_up/common/hapticfeedback.dart';

import 'package:cached_network_image/cached_network_image.dart';

class BeerTile extends StatelessWidget {
  final Beer beer;
  final String title;
  final String subtitle;
  final String thirdTitle;
  final Widget thirdWidget;
  final bool invertColors;
  final GestureTapCallback onTap;
  final BoxDecoration decoration;

  BeerTile({
    @required this.beer,
    @required this.title,
    this.subtitle,
    this.thirdTitle,
    this.thirdWidget,
    this.onTap,
    this.decoration,
    this.invertColors = false,
  });

  @override
  Widget build(BuildContext context) {
    if( beer == null || title == null ) {
      return Container();
    }

    final List<Widget> children = List();
    children.add(Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        color: invertColors ? Colors.white : Theme.of(context).textTheme.body1.color,
      ),
    ));

    if( subtitle != null ) {
      children.add(Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 15.0,
          color: invertColors ? Colors.white : Theme.of(context).textTheme.body1.color,
        ),
      ));
    }

    if( thirdTitle != null ) {
      children.add(const Padding(padding: EdgeInsets.only(top: 5.0)));
      children.add(Text(
        thirdTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: invertColors ? Colors.grey[200] : Colors.blueGrey[500],
          fontSize: 14.0,
        ),
      ));
    }

    if( thirdWidget != null ) {
      children.add(const Padding(padding: EdgeInsets.only(top: 5.0)));
      children.add(thirdWidget);
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap != null ? () {
          performSelectionHaptic(context);
          onTap();
        } : null,
        child: Semantics(
          enabled: onTap != null,
          child: Container(
            decoration: decoration,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                _buildThumbnailImage(beer),
                const Padding(padding: EdgeInsets.only(right: 16.0)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: children,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailImage(Beer beer) {
    Widget image;
    if (beer.label?.iconUrl == null) {
      image = Container(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Image.asset("images/default_beer.png"),
      );
    } else {
      image = CachedNetworkImage(
        imageUrl: beer.label.iconUrl,
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 12.0, top: 7.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 33.0, maxHeight: 35.0),
            child: Center(
              child: image,
            ),
          ),
        ),
        Image.asset(
          "images/beer_icon_background.png",
          width: 55.0,
        ),
      ],
    );
  }
}