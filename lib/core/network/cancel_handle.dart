import 'package:dio/dio.dart';

/// Handle returned to the caller so an in-flight request can be cancelled.
abstract class CancelHandle {
  void cancel();
  bool get isCanceled;
}

/// Concrete [CancelHandle] backed by Dio's [CancelToken].
///
/// Usage:
/// ```dart
/// final handle = DioCancelHandle();
/// final future = client.get(..., cancelHandle: handle);
/// // later:
/// handle.cancel();
/// ```
class DioCancelHandle implements CancelHandle {
  DioCancelHandle() : _token = CancelToken();

  final CancelToken _token;

  /// Internal: passed to Dio. Don't use from app code.
  CancelToken get token => _token;

  @override
  void cancel() => _token.cancel();

  @override
  bool get isCanceled => _token.isCancelled;
}
