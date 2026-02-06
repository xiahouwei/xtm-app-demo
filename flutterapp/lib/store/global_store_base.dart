abstract class GlobalStoreBase<T> {
  T state;

  GlobalStoreBase();

  Future<void> init();
}
