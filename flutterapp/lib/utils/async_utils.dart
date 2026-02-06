import 'dart:async';

class AsyncUtils {
  static Future<T> PromiseFunction<T>(Function(Completer<T>) fn) {
    Completer<T> promise = Completer();
    fn(promise);
    return promise.future;
  }
}
