import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/group_entity.dart';

abstract class GroupRepository {
  Future<Either<Failure, List<GroupEntity>>> fetchGroupEntity(int userId);
  Future<Either<Failure, String>> addGroup(int userId, String groupName);
}