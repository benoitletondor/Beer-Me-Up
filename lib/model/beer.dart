import 'package:meta/meta.dart';

class Beer {
  final String id;
  final String name;
  final String description;
  final BeerLabel label;
  final double abv;
  final BeerStyle style;
  final BeerCategory category;

  Beer({
    @required this.id,
    @required this.name,
    this.description,
    this.abv,
    this.label,
    this.style,
    this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Beer &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              description == other.description &&
              label == other.label &&
              abv == other.abv &&
              style == other.style &&
              category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      label.hashCode ^
      abv.hashCode ^
      style.hashCode ^
      category.hashCode;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BeerStyle &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              shortName == other.shortName &&
              description == other.description;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      shortName.hashCode ^
      description.hashCode;
}

class BeerCategory {
  final int id;
  final String name;

  BeerCategory({
    @required this.id,
    @required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BeerCategory &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode;
}

class BeerLabel {
  final String iconUrl;
  final String mediumUrl;
  final String largeUrl;

  BeerLabel({
    this.iconUrl,
    this.mediumUrl,
    this.largeUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BeerLabel &&
              runtimeType == other.runtimeType &&
              iconUrl == other.iconUrl &&
              mediumUrl == other.mediumUrl &&
              largeUrl == other.largeUrl;

  @override
  int get hashCode =>
      iconUrl.hashCode ^
      mediumUrl.hashCode ^
      largeUrl.hashCode;
}