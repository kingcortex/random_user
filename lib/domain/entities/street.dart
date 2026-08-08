import 'package:equatable/equatable.dart';

final class Street extends Equatable {
  const Street({required this.number, required this.name});

  final int number;
  final String name;

  @override
  List<Object?> get props => [number, name];
}
