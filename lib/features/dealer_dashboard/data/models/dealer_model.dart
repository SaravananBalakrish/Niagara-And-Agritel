
import '../../domain/entites/dealer.dart';

class DealerModel extends Dealer {
  DealerModel({
    required super.id,
    required super.name,
    required super.totalSales,
    required super.activeDevices,
    required super.pendingOrders,
  });

  factory DealerModel.fromJson(Map<String, dynamic> json) {
    return DealerModel(
      id: json['id'],
      name: json['name'],
      totalSales: json['total_sales'],
      activeDevices: json['active_devices'],
      pendingOrders: json['pending_orders'],
    );
  }
}
