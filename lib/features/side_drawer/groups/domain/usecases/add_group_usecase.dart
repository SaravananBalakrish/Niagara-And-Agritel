import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/fetch_group_repository.dart';

class GroupAddingUsecase extends UseCase<dynamic, GroupAddingParams> {
  final GroupRepository fetchGroupRepository;
  GroupAddingUsecase(this.fetchGroupRepository);

  @override
  Future<Either<Failure, dynamic>> call(GroupAddingParams updateSubUserDetailsParams) {
    return fetchGroupRepository.addGroup(updateSubUserDetailsParams.userId, updateSubUserDetailsParams.groupName);
  }
}

class GroupAddingParams extends Equatable{
  final int userId;
  final String groupName;
  const  GroupAddingParams(this.userId, this.groupName);

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}
