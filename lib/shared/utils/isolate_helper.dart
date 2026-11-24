import 'package:flutter/foundation.dart';

class IsolateHelper {
  static Future<R> run<M, R>(
      ComputeCallback<M, R> callback,
      M message,
      ) async {
    return await compute(callback, message);
  }
}
