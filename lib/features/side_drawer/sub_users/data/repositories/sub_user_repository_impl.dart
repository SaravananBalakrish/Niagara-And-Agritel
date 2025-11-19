import 'package:dartz/dartz.dart';

import '../../../../../core/error/base_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../domain/entities/sub_user_details_entity.dart';
import '../../domain/entities/sub_user_entity.dart';
import '../../domain/repositories/sub_user_repo.dart';
import '../../domain/usecases/get_sub_user_by_phone_usecase.dart';
import '../../domain/usecases/get_sub_user_details_usecase.dart';
import '../../domain/usecases/update_sub_user_usecase.dart';
import '../data_sources/sub_user_data_sources.dart';

class SubUserRepositoryImpl extends BaseRepository implements SubUserRepo {
  final SubUserDataSources subUserDataSources;
  SubUserRepositoryImpl({required this.subUserDataSources});

  @override
  Future<Either<Failure, List<SubUserEntity>>> getSubUsers(int userId) async {
    return await safeCall(
          () => subUserDataSources.getSubUsers(userId),
      context: 'getSubUsers(userId: $userId)',
    );
  }

  @override
  Future<Either<Failure, SubUserDetailsEntity>> getSubUserDetails(GetSubUserDetailsParams params) async {
    return await safeCall(
          () => subUserDataSources.getSubUserDetails(params),
      context: 'getSubUserDetails(params: $params)',
    );
  }

  @override
  Future<Either<Failure, String>> updateSubUserDetails(UpdateSubUserDetailsParams params) async {
    return await safeCall(
          () => subUserDataSources.updateSubUserDetails(params),
      context: 'updateSubUserDetails(params: $params)',
    );
  }

  @override
  Future<Either<Failure, dynamic>> getSubUserByPhone(GetSubUserByPhoneParams params) async {
    return await safeCallDynamic(
          () => subUserDataSources.getSubUserByPhone(params),
      context: 'getSubUserByPhone(params: $params)',
    );
  }
}