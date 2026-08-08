import 'package:random_user/core/utils/dyn_parser.dart';
import 'package:random_user/domain/entities/picture.dart';

final class PictureModel {
  const PictureModel({
    required this.large,
    required this.medium,
    required this.thumbnail,
  });

  factory PictureModel.fromJson(JsonMap json) => PictureModel(
        large: dynParser<String>(json['large']),
        medium: dynParser<String>(json['medium']),
        thumbnail: dynParser<String>(json['thumbnail']),
      );

  factory PictureModel.fromDyn(dynamic value) =>
      PictureModel.fromJson(dynParser<JsonMap>(value));

  Map<String, dynamic> toJson() => {
        'large': large,
        'medium': medium,
        'thumbnail': thumbnail,
      };

  Picture toEntity() => Picture(large: large, medium: medium, thumbnail: thumbnail);

  final String large;
  final String medium;
  final String thumbnail;
}
