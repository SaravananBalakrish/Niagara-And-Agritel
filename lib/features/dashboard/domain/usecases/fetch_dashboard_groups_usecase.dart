import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/dashboard_repository.dart';

class FetchDashboardGroups extends UseCase<dynamic, DashboardGroupsParams> {
  final DashboardRepository repository;
  FetchDashboardGroups(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(DashboardGroupsParams params) {
    return repository.fetchDashboardGroups(params.userId);
  }
}

class DashboardGroupsParams extends Equatable {
  final int userId;
  const DashboardGroupsParams(this.userId);

  @override
  List<Object?> get props => [userId];
}