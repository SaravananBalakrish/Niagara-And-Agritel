import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:niagara_smart_drip_irrigation/core/error/failures.dart';
import 'package:niagara_smart_drip_irrigation/core/usecases/usecase.dart';
import 'package:niagara_smart_drip_irrigation/features/side_drawer/data/repositories/fetch_group_repository.dart';

class GroupFetchingUsecase extends UseCase<dynamic, GroupFetchParams> {
  final FetchGroupRepository fetchGroupRepository;
  GroupFetchingUsecase(this.fetchGroupRepository);

  @override
  Future<Either<Failure, dynamic>> call(GroupFetchParams params) {
    return fetchGroupRepository.fetchGroupEntity(params.userId);
  }

}

class GroupFetchParams extends Equatable{
  final int userId;
  const  GroupFetchParams(this.userId);

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}