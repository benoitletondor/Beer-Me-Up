import 'package:meta/meta.dart';

class Beer {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final double abv;
  final BeerStyle style;
  final BeerCategory category;

  Beer({
    @required this.id,
    @required this.name,
    this.description,
    this.abv,
    this.thumbnailUrl,
    this.style,
    this.category,
  });
}

class BeerStyle {
  final int id;
  final String name;
  final String shortName;
  final String description;

  BeerStyle({
    @required this.id,
    @required this.name,
    this.shortName,
    this.description,
  });
}

class BeerCategory {
  final int id;
  final String name;

  BeerCategory({
    @required this.id,
    @required this.name,
  });
}