import 'package:equatable/equatable.dart';

import 'street.dart';

final class Location extends Equatable {
  const Location({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.postcode,
  });

  final Street street;
  final String city;
  final String state;
  final String country;
  final String postcode;

  @override
  List<Object?> get props => [street, city, state, country, postcode];
}
