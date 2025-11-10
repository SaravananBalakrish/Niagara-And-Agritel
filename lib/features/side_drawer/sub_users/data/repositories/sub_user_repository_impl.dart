import 'package:dartz/dartz.dart';
import 'package:niagara_smart_drip_irrigation/core/error/failures.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/data/data_sources/sub_user_data_sources.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/entities/sub_user_details_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/entities/sub_user_entity.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/repositories/sub_user_repo.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/usecases/get_sub_user_details_usecase.dart';

class SubUserRepositoryImpl extends SubUserRepo {
  final SubUserDataSources subUserDataSources;
  SubUserRepositoryImpl({required this.subUserDataSources});

  @override
  Future<Either<Failure, List<SubUserEntity>>> getSubUsers(int userId) async{
    try {
      final subUsersList = await subUserDataSources.getSubUsers(userId);
      return Right(subUsersList);
    } catch (e) {
      return Left(ServerFailure('Group Fetching Failure: $e'));
    }
  }

  @override
  Future<Either<Failure, SubUserDetailsEntity>> getSubUserDetails(GetSubUserDetailsParams subUserDetailsParams) async{
    try {
      final subUsersList = await subUserDataSources.getSubUserDetails(subUserDetailsParams);
      return Right(subUsersList);
    } catch (e) {
      return Left(ServerFailure('Group Fetching Failure: $e'));
    }
  }
}