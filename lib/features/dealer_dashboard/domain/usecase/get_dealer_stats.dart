

import '../entites/dealer.dart';
import '../repositories/dealer_repository.dart';

class GetDealerStats {
  final DealerRepository repository;

  GetDealerStats(this.repository);

  Future<Dealer> call(String dealerId) {
    return repository.getDealerStats(dealerId);
  }
}
