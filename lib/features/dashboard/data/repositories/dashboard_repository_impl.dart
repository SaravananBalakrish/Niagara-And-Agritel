import 'package:dartz/dartz.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/domain/entities/controller_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/dashboard/domain/entities/group_entity.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remote;

  DashboardRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<GroupDetailsEntity>>> fetchDashboardGroups(int userId) async {
    try {
      final response = await remote.fetchDashboardGroups(userId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch dashboard groups: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ControllerEntity>>> fetchControllers(int userId, int groupId) async {
    try {
      final response = await remote.fetchControllers(userId, groupId);
      print("response from the fetchControllers :: $response");
      return Right(response);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch controllers: $e'));
    }
  }
}