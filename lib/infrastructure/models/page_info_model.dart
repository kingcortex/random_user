import 'package:random_user/core/utils/dyn_parser.dart';
import 'package:random_user/domain/entities/page_info.dart';

final class PageInfoModel {
  const PageInfoModel({
    required this.seed,
    required this.results,
    required this.page,
    required this.version,
  });

  factory PageInfoModel.fromJson(JsonMap json) => PageInfoModel(
        seed: dynParser<String>(json['seed']),
        results: dynParser<int>(json['results']),
        page: dynParser<int>(json['page']),
        version: dynParser<String>(json['version']),
      );

  factory PageInfoModel.fromDyn(dynamic value) =>
      PageInfoModel.fromJson(dynParser<JsonMap>(value));

  Map<String, dynamic> toJson() => {
        'seed': seed,
        'results': results,
        'page': page,
        'version': version,
      };

  PageInfo toEntity() =>
      PageInfo(seed: seed, results: results, page: page, version: version);

  final String seed;
  final int results;
  final int page;
  final String version;
}
