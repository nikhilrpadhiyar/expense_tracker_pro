import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({required this.message});
  final String message;

  @override
  List<Object> get props => <Object>[message];
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

class ApiFailure extends Failure {
  const ApiFailure({required super.message, this.statusCode});
  final int? statusCode;

  @override
  List<Object> get props => <Object>[message, statusCode ?? 0];
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Session expired. Please sign in again.',
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class SyncFailure extends Failure {
  const SyncFailure({required super.message});
}

class ExportFailure extends Failure {
  const ExportFailure({required super.message});
}
