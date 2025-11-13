import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/sub_users/domain/entities/sub_user_details_entity.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/sub_user_repo.dart';

class UpdateSubUserDetailsUseCase extends UseCase<dynamic, SubUserDetailsEntity> {
  final SubUserRepo subUserRepo;
  UpdateSubUserDetailsUseCase({required this.subUserRepo});

  @override
  Future<Either<Failure, dynamic>> call(SubUserDetailsEntity subUserDetailsEntity) {
    return subUserRepo.updateSubUserDetails(subUserDetailsEntity);
  }
}

class UpdateSubUserDetailsParams extends Equatable {
  final SubUserDetailsEntity subUserDetailsEntity;
  const UpdateSubUserDetailsParams({required this.subUserDetailsEntity});

  @override
  List<Object?> get props => [subUserDetailsEntity];
}