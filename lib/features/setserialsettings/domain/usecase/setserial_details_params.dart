import 'package:equatable/equatable.dart';

class SetSerialParams extends Equatable {
  final int userId;
  final int controllerId;

  const SetSerialParams({
    required this.userId,
    required this.controllerId,
  });

  @override
  List<Object?> get props => [userId, controllerId];
}
