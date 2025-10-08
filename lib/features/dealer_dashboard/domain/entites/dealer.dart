class Dealer {
  final String id;
  final String name;
  final int totalSales;
  final int activeDevices;
  final int pendingOrders;

  Dealer({
    required this.id,
    required this.name,
    required this.totalSales,
    required this.activeDevices,
    required this.pendingOrders,
  });
}
