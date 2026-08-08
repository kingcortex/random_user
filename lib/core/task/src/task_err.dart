import 'package:flutter/foundation.dart';

@immutable
final class TaskErr {
  const TaskErr({this.code, this.message, this.type});

  static const connectivityIssueCode = 2000;

  static const empty = TaskErr();

  @internal
  factory TaskErr.fromJson(Map<String, dynamic> json) {
    return TaskErr(
      code: json['code'] as int?,
      message: json['message'] as String?,
      type: json['type'],
    );
  }

  factory TaskErr.message(String message, {int? code, dynamic type}) {
    return TaskErr(message: message, code: code, type: type);
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'message': message, 'type': type};
  }

  final String? message;
  final int? code;
  final dynamic type;

  String get displayMessage => message ?? 'An unknown error occurred';

  bool get isConnectivityIssue => code == connectivityIssueCode;

  bool get isEmpty => this == TaskErr.empty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskErr &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code &&
          type == other.type;

  @override
  int get hashCode => Object.hash(message, code, type);
}
