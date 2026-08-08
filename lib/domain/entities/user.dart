import 'package:equatable/equatable.dart';

import 'location.dart';
import 'name.dart';
import 'picture.dart';

final class User extends Equatable {
  const User({
    required this.id,
    required this.gender,
    required this.name,
    required this.location,
    required this.email,
    required this.phone,
    required this.cell,
    required this.picture,
    required this.nat,
  });

  final String id;
  final String gender;
  final Name name;
  final Location location;
  final String email;
  final String phone;
  final String cell;
  final Picture picture;
  final String nat;

  @override
  List<Object?> get props => [
        id,
        gender,
        name,
        location,
        email,
        phone,
        cell,
        picture,
        nat,
      ];
}
