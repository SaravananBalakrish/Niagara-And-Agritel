import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/controller_entity.dart';
import '../repositories/dashboard_repository.dart';

class FetchControllers extends UseCase<List<ControllerEntity>, UserGroupParams> {
  final DashboardRepository repository;
  FetchControllers(this.repository);

  @override
  Future<Either<Failure, List<ControllerEntity>>> call(UserGroupParams params) {
    return repository.fetchControllers(params.userId, params.groupId);
  }
}

class UserGroupParams extends Equatable {
  final int userId;
  final int groupId;
  const UserGroupParams(this.userId, this.groupId);

  @override
  List<Object?> get props => [userId, groupId];
}