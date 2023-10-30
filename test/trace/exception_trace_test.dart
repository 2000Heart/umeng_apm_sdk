import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:umeng_apm_sdk/src/trace/exception_trace.dart';

void main() {
  setUp(() {});
  tearDown(() {});
  WidgetsFlutterBinding.ensureInitialized();
  group("Trace exception_trace Group Test", () {
    test('ExceptionTrace.captureException', () {
      expect(
          () => ExceptionTrace.captureException(exception: Exception('test')),
          returnsNormally);
    });

    test('ExceptionTrace.zonedGuardedErrorHandler', () {
      expect(
          () => ExceptionTrace.zonedGuardedErrorHandler(
              exception: Exception('test'), stack: 'stack'),
          returnsNormally);
    });
  });
}
