// ignore_for_file: must_be_immutable

import 'package:flutter_test/flutter_test.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';
import 'package:flutter/material.dart';
import '../../example/lib/pages/exception.dart';

Map<String, WidgetBuilder> routes = {"/": (context) => ExceptionPage()};

class MyApp extends StatelessWidget {
  MyApp([this._navigatorObserver]);

  NavigatorObserver? _navigatorObserver;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: routes,
      initialRoute: "/",
      navigatorObservers: <NavigatorObserver>[
        _navigatorObserver ?? ApmNavigatorObserver.singleInstance
      ],
    );
  }
}

void main() {
  setUp(() {});
  tearDown(() {});

  group("Core apm_init_options Group Test", () {
    test('UmengApmSdk init', () {
      expect(
          () => UmengApmSdk(
                  name: 'app_demo',
                  bver: '1.0.0+1',
                  flutterVersion: '3.10.0',
                  engineVersion: 'd44b5a94c9',
                  enableLog: true,
                  errorFilter: {
                    "mode": "match",
                    "rules": [RegExp('RangeError')],
                  }).init(appRunner: (observer) {
                return MyApp(observer);
              }),
          returnsNormally);
    });
  });
}
