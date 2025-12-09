
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/datasources/setserial_datasource.dart';
import '../../data/repositories/setserial_details_repositories.dart';


class SetSerialRepositoryImpl implements SetSerialRepository {
  final SetSerialDataSource remoteDataSource;

  SetSerialRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, dynamic>> getSetSerialDetails(
      int userId,
      int controllerId,
      ) async {
    try {
      final result = await remoteDataSource.loadSerial(
          userId: userId,
          controllerId: controllerId,

      );

      return Right(result);
    } catch (e) {
      return Left(ServerFailure('Controller Fetching Failure: $e'));
    }
  }

  @override
  // TODO: implement dataSource
  SetSerialDataSource get dataSource => throw UnimplementedError();

  @override
  Future<List> loadSerial({required int userId, required int controllerId}) {
    // TODO: implement loadSerial
    throw UnimplementedError();
  }

  @override
  Future<String> resetSerial({required int userId, required int controllerId, required List<int> nodeIds, required String sentSms}) {
    // TODO: implement resetSerial
    throw UnimplementedError();
  }

  @override
  Future<String> sendSerial({required int userId, required int controllerId, required List<Map<String, dynamic>> sendList, required String sentSms}) {
    // TODO: implement sendSerial
    throw UnimplementedError();
  }

  @override
  Future<String> viewSerial({required int userId, required int controllerId, required String sentSms}) {
    // TODO: implement viewSerial
    throw UnimplementedError();
  }


 }


