import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/sub_user_details_entity.dart';
import '../entities/sub_user_entity.dart';
import '../usecases/get_sub_user_by_phone_usecase.dart';
import '../usecases/get_sub_user_details_usecase.dart';
import '../usecases/update_sub_user_usecase.dart';

abstract class SubUserRepo {
  Future<Either<Failure, List<SubUserEntity>>> getSubUsers(int userId);
  Future<Either<Failure, SubUserDetailsEntity>> getSubUserDetails(GetSubUserDetailsParams subUserDetailsParams);
  Future<Either<Failure, String>> updateSubUserDetails(UpdateSubUserDetailsParams subUserDetailsEntity);
  Future<Either<Failure, dynamic>> getSubUserByPhone(GetSubUserByPhoneParams getSubUserByPhoneParams);
}