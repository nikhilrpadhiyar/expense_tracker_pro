abstract class AppException implements Exception {
  const AppException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends AppException {
  const NetworkException({required super.message, super.statusCode});
}

class ApiException extends AppException {
  const ApiException({required super.message, super.statusCode});
}

class CacheException extends AppException {
  const CacheException({required super.message});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Session expired. Please sign in again.',
  });
}

class ValidationException extends AppException {
  const ValidationException({required super.message});
}

class SyncException extends AppException {
  const SyncException({required super.message});
}

class ExportException extends AppException {
  const ExportException({required super.message});
}
