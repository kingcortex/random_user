import 'package:equatable/equatable.dart';

final class Name extends Equatable {
  const Name({required this.title, required this.first, required this.last});

  final String title;
  final String first;
  final String last;

  @override
  List<Object?> get props => [title, first, last];
}
