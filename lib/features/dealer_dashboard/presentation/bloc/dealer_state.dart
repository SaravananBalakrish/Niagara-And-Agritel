 import '../../domain/entites/dealer.dart';

abstract class DealerState {}

class DealerInitial extends DealerState {}

class DealerLoading extends DealerState {}

class DealerLoaded extends DealerState {
  final Dealer dealer;

  DealerLoaded(this.dealer);
}

class DealerError extends DealerState {
  final String message;

  DealerError(this.message);
}
