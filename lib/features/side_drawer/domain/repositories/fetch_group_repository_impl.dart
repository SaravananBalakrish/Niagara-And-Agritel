import 'package:dartz/dartz.dart';
import 'package:niagara_smart_drip_irrigation/core/error/exceptions.dart';
import 'package:niagara_smart_drip_irrigation/core/error/failures.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/data/datasources/group_data_sources.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/data/repositories/fetch_group_repository.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/entities/group_entity.dart';

class FetchGroupRepositoryImpl extends FetchGroupRepository {
  final GroupDataSources groupDataSources;
  FetchGroupRepositoryImpl({required this.groupDataSources});

  @override
  Future<Either<Failure, List<GroupEntity>>> fetchGroupEntity(int userId) async{
    try {
      final groupData = await groupDataSources.fetchGroups(userId);
      return Right(groupData);
    } catch (e) {
      return Left(ServerFailure('Group Fetching Failure: $e'));
    }
  }

}