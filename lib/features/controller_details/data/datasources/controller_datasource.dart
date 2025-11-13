import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/controller_details_model.dart';


abstract class ControllerRemoteDataSource {
  Future<ControllerDetails> getControllerDetails();
}

class ControllerRemoteDataSourceImpl implements ControllerRemoteDataSource {
  final http.Client client;
  ControllerRemoteDataSourceImpl(this.client);

  @override
  Future<ControllerDetails> getControllerDetails() async {
    final url = Uri.parse('https://example.com/api/controller_details');

    final response = await client.get(url);
    if (response.statusCode == 200) {
      return ControllerDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch controller details');
    }
  }
}
