import 'dart:math' as Log;

import 'failure.dart';
import 'exception_mapper.dart';
import '../../core/utils/logger.dart';

class ErrorHandler {
  static Failure handle(Object e, [StackTrace? s]) {
    final msg = ExceptionMapper.map(e);
    Log.e;
    return Failure(msg);
  }
}
