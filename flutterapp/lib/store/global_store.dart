import './auth/store.dart';
import './system/store.dart';

class GlobalStore {
  static final GlobalStore _singleton = GlobalStore._internal();

  factory GlobalStore() => _singleton;

  GlobalStore._internal();

  final AuthGlobalStore auth = AuthGlobalStore();
  final SystemGlobalStore system = SystemGlobalStore();

  Future<void> init() async {
    await auth.init();
    await system.init();
  }
}

final xtmGlobalStore = GlobalStore();
