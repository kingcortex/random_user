import 'package:random_user/core/utils/dyn_parser.dart';
import 'package:random_user/domain/entities/location.dart';

import 'street_model.dart';

final class LocationModel {
  const LocationModel({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
  });

  factory LocationModel.fromJson(JsonMap json) => LocationModel(
        street: StreetModel.fromDyn(json['street']),
        city: dynParser<String>(json['city']),
        state: dynParser<String>(json['state']),
        country: dynParser<String>(json['country']),
        postcode: dynParser<String>(json['postcode']),
      );

  factory LocationModel.fromDyn(dynamic value) =>
      LocationModel.fromJson(dynParser<JsonMap>(value));

  Map<String, dynamic> toJson() => {
        'street': street.toJson(),
        'city': city,
        'state': state,
        'country': country,
        'postcode': postcode,
      };

  Location toEntity() => Location(
        street: street.toEntity(),
        city: city,
        state: state,
        country: country,
        postcode: postcode,
      );

  final StreetModel street;
  final String city;
  final String state;
  final String country;
  final String postcode;
}
