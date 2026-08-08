import 'package:equatable/equatable.dart';
import 'package:random_user/core/task/src/task_err.dart';

enum Status { initial, loading, success, error }

typedef AsyncTask = AsyncValue<bool>;

final class AsyncValue<T> extends Equatable {
  static AsyncValue<T> decode<T>(
    Map<String, dynamic> json,
    T Function(dynamic json) decoder,
  ) {
    return AsyncValue.fromJson(json, decoder: decoder);
  }

  static Map<String, dynamic> encode<T>(
    AsyncValue<T> asyncValue,
    Object? Function(T value) encoder,
  ) {
    return asyncValue.toJson(encoder);
  }

  const AsyncValue({
    this.value,
    this.status = Status.initial,
    this.message = TaskErr.empty,
  });

  factory AsyncValue.fromJson(
    Map<String, dynamic> json, {
    required T Function(Object? json) decoder,
  }) {
    return AsyncValue(
      value: json['value'] != null ? decoder(json['value']) : null,
      status: Status.values.firstWhere((e) => e.name == json['status']),
      message: json['message'] != null
          ? TaskErr.fromJson(json['message'] as Map<String, dynamic>)
          : TaskErr.empty,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) encoder) {
    return {
      'value': value != null ? encoder(value as T) : null,
      'status': switch (status) {
        Status.loading => Status.initial,
        _ => status,
      }.name,
      'message': message.toJson(),
    };
  }

  final T? value;
  final Status status;
  final TaskErr message;

  T? call() => value;

  T unwrap() {
    if (value != null) {
      return value!;
    } else {
      throw StateError('Cannot unwrap a null value');
    }
  }

  T unwrapOr(T defaultValue) {
    return value ?? defaultValue;
  }

  bool get isLoading => status == Status.loading;

  bool get isSuccess => status == Status.success;

  bool get isError => status == Status.error;

  bool get isInitial => status == Status.initial;

  AsyncValue<T> toLoading() => AsyncValue(status: Status.loading, value: value);

  AsyncValue<T> toSuccess(T value) =>
      AsyncValue(value: value, status: Status.success);

  AsyncValue<T> toError(TaskErr error) =>
      AsyncValue(status: Status.error, message: error, value: value);

  AsyncValue<T> toInitial() => AsyncValue();

  AsyncValue<T> changeValue(T value) =>
      AsyncValue(value: value, status: status, message: message);

  AsyncValue<R> map<R>(R Function(T value) mapper) => AsyncValue<R>(
    value: value != null ? mapper(value as T) : null,
    status: status,
    message: message,
  );

  @override
  List<Object?> get props => [value, status, message];
}
