import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'cancel_handle.dart';
import 'exceptions.dart';

/// Transport-agnostic HTTP client interface.
///
/// Returns parsed [T] directly — the caller is responsible for knowing the
/// expected type. Throws [NetworkException] (or a subclass) on failure;
/// Dio's own types never leak past this boundary.
abstract class HttpClient {
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  });

  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  });

  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  });

  Future<T> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  });

  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  });

  Future<void> download({
    required String url,
    required String savePath,
    required void Function(int received, int total) onProgress,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  });
}

class HttpClientImpl implements HttpClient {
  HttpClientImpl({required this.dio}) {
    _setupInterceptors();
  }

  final Dio dio;

  void _setupInterceptors() {
    if (kDebugMode) {
      // Log request line + errors only. Headers/bodies are off by default to
      // avoid leaking auth tokens or PII into the device log.
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: true,
        ),
      );
    }
  }

  Options _options(bool requiresAuth, Map<String, dynamic>? headers) {
    return Options(
      // Auth interceptor reads this flag to inject the Bearer token.
      extra: {'requiresAuth': requiresAuth},
      headers: headers,
    );
  }

  CancelToken? _cancelToken(CancelHandle? handle) =>
      handle is DioCancelHandle ? handle.token : null;

  NetworkException _handleDioError(DioException error) {
    final message = _extractErrorMessage(error.response?.data);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return TransportException.timeout(message);
      case DioExceptionType.connectionError:
        return TransportException.noConnection(message);
      case DioExceptionType.cancel:
        return TransportException.cancelled(message);
      case DioExceptionType.badCertificate:
        return TransportException.badCertificate(message);
      case DioExceptionType.badResponse:
        return _handleBadResponse(error, message);
      case DioExceptionType.unknown:
        return UnknownNetworkException(originalError: error);
    }
  }

  NetworkException _handleBadResponse(DioException error, String? message) {
    final statusCode = error.response?.statusCode;

    if (statusCode == null) {
      return ServerException(message: message);
    }

    return switch (statusCode) {
      401 || 403 => UnauthorizedException(code: statusCode, message: message),
      404 => NotFoundException(message: message),
      >= 400 && < 500 =>
        ValidationException(code: statusCode, message: message),
      _ => ServerException(code: statusCode, message: message),
    };
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    final top = data['message'];
    if (top is String) return top;

    final nested = data['data'];
    if (nested is Map<String, dynamic>) {
      final inner = nested['message'];
      if (inner is String) return inner;
    }
    return null;
  }

  @override
  Future<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  }) async {
    try {
      final response = await dio.get<T>(
        endpoint,
        queryParameters: queryParameters,
        options: _options(requiresAuth, headers),
        cancelToken: _cancelToken(cancelHandle),
      );
      if (response.data == null) {
        throw NetworkException('Aucune donnée de réponse pour GET $endpoint');
      }
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<T> post<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  }) async {
    try {
      final response = await dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _options(requiresAuth, headers),
        cancelToken: _cancelToken(cancelHandle),
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<T> put<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  }) async {
    try {
      final response = await dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _options(requiresAuth, headers),
        cancelToken: _cancelToken(cancelHandle),
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<T> patch<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  }) async {
    try {
      final response = await dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _options(requiresAuth, headers),
        cancelToken: _cancelToken(cancelHandle),
      );
      if (response.data == null) {
        throw NetworkException('Aucune donnée de réponse pour PATCH $endpoint');
      }
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<T> delete<T>({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  }) async {
    try {
      final response = await dio.delete<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _options(requiresAuth, headers),
        cancelToken: _cancelToken(cancelHandle),
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> download({
    required String url,
    required String savePath,
    required void Function(int received, int total) onProgress,
    bool requiresAuth = false,
    CancelHandle? cancelHandle,
  }) async {
    try {
      await dio.download(
        url,
        savePath,
        options: _options(requiresAuth, null),
        onReceiveProgress: onProgress,
        cancelToken: _cancelToken(cancelHandle),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
