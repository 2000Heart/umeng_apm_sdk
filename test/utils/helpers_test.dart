import 'package:flutter_test/flutter_test.dart';
import 'package:umeng_apm_sdk/src/utils/utils.dart';

void main() {
  setUp(() {});
  tearDown(() {});

  group("utils Group Test", () {
    test('nativeTryCatch', () {
      expect(
          () => nativeTryCatch(handler: () {
                // 数组越界
                const arr = [];
                print(arr[2]);
              }),
          throwsA(isA<Exception>()));
      expect(() => nativeTryCatch(handler: () {}), returnsNormally);
    });

    test('getRandomStr', () {
      expect(getRandomStr(len: 10), matches(RegExp(r'^[a-zA-Z0-9]{10}$')));
    });

    test('isNowDay', () {
      expect(
          isNowDay(timestamp: DateTime.now().millisecondsSinceEpoch), isTrue);
      expect(isNowDay(timestamp: 0), isFalse);
    });

    test('getSizeInBytes', () {
      final int result = getSizeInBytes('字节');
      expect(result, greaterThan(0));
    });

    test('getSizeInBytes', () {
      final bool result = checkStringSize("字符串", 100);
      expect(result, isFalse);
    });

    test('jsonParse', () {
      final Map? result = jsonParse('{"name": "John Smith", "age": 30}');
      final Map? result2 = jsonParse('123');
      expect(
          result, equals(<String, dynamic>{"name": "John Smith", "age": 30}));
      expect(result2, anyOf(isNull, isA<Map>()));
    });

    test('getDartVersion', () {
      expect(getDartVersion(),
          matches(RegExp(r'^(\d+\.\d+\.\d+)\s+\(.*\) \((.*)\) on "(.*)"$')));
    });

    test('createSessionId', () {
      expect(createSessionId(), matches(RegExp(r'^[a-zA-Z0-9]{23}$')));
    });
  });
}
