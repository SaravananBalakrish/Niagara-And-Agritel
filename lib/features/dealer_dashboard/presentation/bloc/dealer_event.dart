abstract class DealerEvent {}

class LoadDealerStats extends DealerEvent {
  final String dealerId;

  LoadDealerStats(this.dealerId);
}
