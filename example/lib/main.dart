import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:flutter/material.dart';
import './pages/exception.dart';
import './pages/white_screen.dart';

Map<String, WidgetBuilder> routes = {
  "/": (context) => HomePage(),
  "/exception": (context) => ExceptionPage(),
  "/white_screen": (context) => WhiteScreenPage()
};

void main() {
  UmengApmSdk(
    name: 'app_demo',
    bver: '1.0.0+9',
    flutterVersion: '3.10.0',
    engineVersion: 'd44b5a94c9',
    enableLog: true,
    errorFilter: {
      "mode": "ignore",
      // "rules": [RegExp('RangeError')],
      "rules": [],
    },
    initFlutterBinding: MyApmWidgetsFlutterBinding.ensureInitialized,
    // onError: (exception, stack) {},
  ).init(appRunner: (observer) {
    return MyApp(observer);
  });
}

class MyApmWidgetsFlutterBinding extends ApmWidgetsFlutterBinding {
  @override
  void handleAppLifecycleStateChanged(AppLifecycleState state) {
    // 添加自己的实现逻辑
    print('AppLifecycleState changed to $state');
    super.handleAppLifecycleStateChanged(state);
  }

  static WidgetsBinding? ensureInitialized() {
    MyApmWidgetsFlutterBinding();
    return WidgetsBinding.instance;
  }
}

// ignore: must_be_immutable
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

class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State {
  @override
  void initState() {
    super.initState();
    UmengCommonSdk.initCommon(
        '6257c4d95f97184f8a4e4aa4', '6479cb79e31d6071ec47f596', 'Umeng');
    UmengCommonSdk.setPageCollectionModeManual();
  }

  void runCustomException() {
    try {
      // 模拟数组越界错误
      List<String> numList = ['1', '2'];
      print(numList[5]);
    } catch (e) {
      ExceptionTrace.captureException(
          exception: Exception(e), extra: {"user": '123'});
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("AlertDialog Title"),
          content: Text("AlertDialog Body"),
          actions: <Widget>[
            TextButton(
              child: Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                  child: Text('dart error page'),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/exception');
                  }),
              TextButton(
                  child: Text('dart error new page'),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ExceptionPage()));
                  }),
              TextButton(
                  child: Text('dart error release page'),
                  onPressed: () async {
                    Navigator.of(context).pushReplacementNamed('/exception');
                  }),
              TextButton(
                child: Text("Show Dialog"),
                onPressed: _showDialog,
              ),
              TextButton(
                  child: Text("dart white screen exception"),
                  onPressed: () async {
                    Navigator.of(context).pushReplacementNamed('/white_screen');
                  }),
              TextButton(
                  child: Text("捕获主动上报 exception"),
                  onPressed: () {
                    runCustomException();
                  }),
            ]),
      ),
    );
  }
}
