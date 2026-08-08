import 'package:random_user/core/utils/dyn_parser.dart';
import 'package:random_user/domain/entities/user.dart';

import 'location_model.dart';
import 'name_model.dart';
import 'picture_model.dart';

final class UserModel {
  const UserModel({
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

  factory UserModel.fromJson(JsonMap json) {
    final login = dynParser<JsonMap>(json['login']);
    return UserModel(
      id: dynParser<String>(login['uuid']),
      gender: dynParser<String>(json['gender']),
      name: NameModel.fromDyn(json['name']),
      location: LocationModel.fromDyn(json['location']),
      email: dynParser<String>(json['email']),
      phone: dynParser<String>(json['phone']),
      cell: dynParser<String>(json['cell']),
      picture: PictureModel.fromDyn(json['picture']),
      nat: dynParser<String>(json['nat']),
    );
  }

  factory UserModel.fromDyn(dynamic value) =>
      UserModel.fromJson(dynParser<JsonMap>(value));

  Map<String, dynamic> toJson() => {
        'gender': gender,
        'name': name.toJson(),
        'location': location.toJson(),
        'email': email,
        'login': {'uuid': id},
        'phone': phone,
        'cell': cell,
        'picture': picture.toJson(),
        'nat': nat,
      };

  User toEntity() => User(
        id: id,
        gender: gender,
        name: name.toEntity(),
        location: location.toEntity(),
        email: email,
        phone: phone,
        cell: cell,
        picture: picture.toEntity(),
        nat: nat,
      );

  final String id;
  final String gender;
  final NameModel name;
  final LocationModel location;
  final String email;
  final String phone;
  final String cell;
  final PictureModel picture;
  final String nat;
}
