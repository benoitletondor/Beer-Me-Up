import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_stream_friends/flutter_stream_friends.dart';
import 'package:beer_me_up/common/hapticfeedback.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final double size;
  final ValueStreamCallback<int> onTap;
  final double paddingBetweenStars;
  final MainAxisAlignment alignment;

  RatingStars({
    @required this.rating,
    @required this.size,
    this.onTap,
    this.paddingBetweenStars,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment ?? MainAxisAlignment.start,
      children: <Widget>[
        _buildStar(1, rating >= 1, context),
        _buildStar(2, rating >= 2, context),
        _buildStar(3, rating >= 3, context),
        _buildStar(4, rating >= 4, context),
        _buildStar(5, rating >= 5, context),
      ],
    );
  }

  Widget _buildStar(int index, bool selected, BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        enableFeedback: onTap != null,
        onTap: onTap != null ? () {
          performSelectionHaptic(context);
          onTap(index);
        } : null,
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
        child: Container(
          padding: EdgeInsets.all(paddingBetweenStars ?? 0.0),
          child: Icon(
            selected ? Icons.star : Icons.star_border,
            color: Colors.amberAccent[400],
            size: size,
          ),
        ),
      ),
    );
  }

}