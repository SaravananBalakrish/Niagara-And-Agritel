import 'package:dartz/dartz.dart';
import 'package:niagara_smart_drip_irrigation/features/controller_details/domain/entities/controller_details_entities.dart';

abstract class ControllerRepository {
  Future<Either<String, ControllerDetailsEntities>> getControllerDetails(String deviceId);
}
