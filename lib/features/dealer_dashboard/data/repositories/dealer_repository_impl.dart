

import '../../../../core/services/api_client.dart';
import '../../domain/entites/dealer.dart';
import '../../domain/repositories/dealer_repository.dart';
import '../models/dealer_model.dart';

class DealerRepositoryImpl implements DealerRepository {
  final ApiClient client;

  DealerRepositoryImpl(this.client);

  @override
  Future<Dealer> getDealerStats(String dealerId) async {
    final response = await client.get('/dealer/$dealerId/stats');
    return DealerModel.fromJson(response);
  }
}
