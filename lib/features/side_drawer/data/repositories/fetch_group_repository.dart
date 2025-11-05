import 'package:dartz/dartz.dart';
import 'package:niagara_smart_drip_irrigation/core/error/failures.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/domain/entities/group_entity.dart';

abstract class FetchGroupRepository {
  Future<Either<Failure, List<GroupEntity>>> fetchGroupEntity(int userId);
}