import 'core/flavor/flavor_config.dart';
import 'app.dart';

Future<void> main() async {
  FlavorConfig.setup(Flavor.niagara);
  await appMain(); // shared bootstrap (initializes DI, then runApp)
}