/// Network exception hierarchy.
///
/// [NetworkException] is the sealed base. All thrown network errors in the
/// HTTP client layer are one of its subclasses:
///
///   * [TransportException] — no HTTP response (timeout, no internet, cancel,
///     bad cert). Use the named factories for typed matching.
///   * [UnauthorizedException] — 401 / 403
///   * [NotFoundException] — 404
///   * [ValidationException] — other 4xx
///   * [ServerException] — 5xx, or no status code
///   * [UnknownNetworkException] — fallback for unknown Dio errors
library;

/// Base network exception. Can be thrown directly for generic cases (e.g.
/// empty response body). Prefer a typed subclass when you can.
class NetworkException implements Exception {
  const NetworkException(this.message, {this.code, this.originalError});

  /// Human-readable message (French, suitable for direct display).
  final String message;

  /// HTTP status code, when available.
  final int? code;

  /// Original error (e.g. the [DioException]) for debugging.
  final Object? originalError;

  @override
  String toString() {
    final codePart = code != null ? '($code)' : '';
    return 'NetworkException$codePart: $message';
  }
}

/// Transport-level error: no HTTP response was received.
///
/// No status code (the request never reached a status-bearing response).
class TransportException extends NetworkException {
  const TransportException._(super.message);

  factory TransportException.timeout([String? message]) =>
      TransportException._(message ?? 'La demande a expiré');

  factory TransportException.noConnection([String? message]) =>
      TransportException._(message ?? 'Pas de connexion Internet');

  factory TransportException.cancelled([String? message]) =>
      TransportException._(message ?? 'La requête a été annulée');

  factory TransportException.badCertificate([String? message]) =>
      TransportException._(message ?? 'Certificat invalide');
}

class UnauthorizedException extends NetworkException {
  const UnauthorizedException({required int code, String? message})
      : super(
          message ?? "Vous n'êtes pas autorisé à accéder à cette ressource",
          code: code,
        );
}

class NotFoundException extends NetworkException {
  const NotFoundException({String? message})
      : super(message ?? 'Non trouvé', code: 404);
}

class ValidationException extends NetworkException {
  const ValidationException({required int code, String? message})
      : super(message ?? 'Erreur de validation', code: code);
}

class ServerException extends NetworkException {
  const ServerException({int? code, String? message})
      : super(message ?? 'Erreur du serveur', code: code);
}

class UnknownNetworkException extends NetworkException {
  const UnknownNetworkException({String? message, Object? originalError})
      : super(
          message ?? 'Erreur réseau inconnue',
          originalError: originalError,
        );
}
