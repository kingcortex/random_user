import 'package:equatable/equatable.dart';

final class Picture extends Equatable {
  const Picture({required this.large, required this.medium, required this.thumbnail});

  final String large;
  final String medium;
  final String thumbnail;

  @override
  List<Object?> get props => [large, medium, thumbnail];
}
