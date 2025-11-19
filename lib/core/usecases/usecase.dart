import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base class for all async use cases.
/// [Type] = return type on success.
/// [Params] = input type (use `NoParams` if none).
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params updateSubUserDetailsParams);
}

/// Base class for real-time / continuous data use cases (MQTT, WebSocket, Streams).
/// Emits Either<Failure, Type> continuously.
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// Base class for synchronous/local use cases (e.g. cache read, flavor config).
abstract class SyncUseCase<Type, Params> {
  Either<Failure, Type> call(Params params);
}

/// Use when no parameters are required.
class NoParams {
  const NoParams();
}
