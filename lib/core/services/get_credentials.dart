// core/services/some_service.dart
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';

class SomeService {
  final AuthLocalDataSource authLocalDataSource;

  SomeService() : authLocalDataSource = GetIt.instance<AuthLocalDataSource>();

  Future<void> performAction() async {
    final user = await authLocalDataSource.getCachedAuthData();
    if (user != null) {
      // print('Performing action for user: ${user.id}, token: ${user.accessToken}');
      // Use user.id, user.accessToken, etc.
    } else {
      print('No user logged in');
    }
  }
}