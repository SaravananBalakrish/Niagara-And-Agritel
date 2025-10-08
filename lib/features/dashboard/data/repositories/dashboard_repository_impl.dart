import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remote;

  DashboardRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, dynamic>> fetchDashboardGroups(int userId) async {
    try {
      final response = await remote.fetchDashboardGroups(userId);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch dashboard groups: $e'));
    }
  }
}