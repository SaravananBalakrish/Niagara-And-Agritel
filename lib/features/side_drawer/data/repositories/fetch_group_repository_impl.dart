import 'package:dartz/dartz.dart';
import 'package:niagara_smart_drip_irrigation/core/error/failures.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/data/datasources/group_data_sources.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/repositories/fetch_group_repository.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/entities/group_entity.dart';

class GroupRepositoryImpl extends GroupRepository {
  final GroupDataSources groupDataSources;
  GroupRepositoryImpl({required this.groupDataSources});

  @override
  Future<Either<Failure, List<GroupEntity>>> fetchGroupEntity(int userId) async{
    try {
      final groupData = await groupDataSources.fetchGroups(userId);
      return Right(groupData);
    } catch (e) {
      return Left(ServerFailure('Group Fetching Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> addGroup(int userId, String groupName) async{
    try {
      final groupData = await groupDataSources.addGroups(userId, groupName);
      return Right(groupData);
    } catch (e) {
      return Left(ServerFailure('Group Adding Failure: $e'));
    }
  }
}