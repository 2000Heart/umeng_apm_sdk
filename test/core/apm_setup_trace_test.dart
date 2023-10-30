import 'package:flutter_test/flutter_test.dart';
import 'package:umeng_apm_sdk/src/core/apm_setup_trace.dart';

void main() {
  setUp(() {});
  tearDown(() {});

  group("Core apm_setup_trace Group Test", () {
    test('ApmSetupTrace', () {
      expect(() => ApmSetupTrace(), returnsNormally);
    });
  });
}
