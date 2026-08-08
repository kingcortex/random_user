import 'package:random_user/core/utils/dyn_parser.dart';
import 'package:random_user/domain/entities/street.dart';

final class StreetModel {
  const StreetModel({required this.number, required this.name});

  factory StreetModel.fromJson(JsonMap json) => StreetModel(
        number: dynParser<int>(json['number']),
        name: dynParser<String>(json['name']),
      );

  factory StreetModel.fromDyn(dynamic value) =>
      StreetModel.fromJson(dynParser<JsonMap>(value));

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
      };

  Street toEntity() => Street(number: number, name: name);

  final int number;
  final String name;
}
