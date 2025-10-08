import '../entites/dealer.dart';

abstract class DealerRepository {
  Future<Dealer> getDealerStats(String dealerId);
}
