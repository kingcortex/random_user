import 'package:random_user/core/utils/dyn_parser.dart';
import 'package:random_user/domain/entities/name.dart';

final class NameModel {
  const NameModel({required this.title, required this.first, required this.last});

  factory NameModel.fromJson(JsonMap json) => NameModel(
        title: dynParser<String>(json['title']),
        first: dynParser<String>(json['first']),
        last: dynParser<String>(json['last']),
      );

  factory NameModel.fromDyn(dynamic value) =>
      NameModel.fromJson(dynParser<JsonMap>(value));

  Map<String, dynamic> toJson() => {
        'title': title,
        'first': first,
        'last': last,
      };

  Name toEntity() => Name(title: title, first: first, last: last);

  final String title;
  final String first;
  final String last;
}
