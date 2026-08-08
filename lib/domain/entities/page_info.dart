import 'package:equatable/equatable.dart';

final class PageInfo extends Equatable {
  const PageInfo({
    required this.seed,
    required this.results,
    required this.page,
    required this.version,
  });

  final String seed;
  final int results;
  final int page;
  final String version;

  @override
  List<Object?> get props => [seed, results, page, version];
}
