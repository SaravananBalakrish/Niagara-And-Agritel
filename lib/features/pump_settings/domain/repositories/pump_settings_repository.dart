import 'package:dartz/dartz.dart';
import 'package:niagara_smart_drip_irrigation/core/error/failures.dart';
import 'package:niagara_smart_drip_irrigation/features/pump_settings/domain/entities/settings_menu_entity.dart';

abstract class PumpSettingsRepository {
  Future<Either<Failure, List<SettingsMenuEntity>>> getSettingsMenuList(int userId, int subUserId, int controllerId);
}