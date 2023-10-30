import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';
import 'dart:isolate';

void runIsolate(dynamic message) async {
  List<String> numList = ['1', '2'];
  print(numList[5]);
}

void runFrameworkException() async {
  List<String> numList = ['1', '2'];
  print(numList[5]);
}

void runCustomException() {
  try {
    List<String> numList = ['1', '2'];
    print(numList[5]);
  } catch (e) {
    ExceptionTrace.captureException(
        exception: Exception(e), extra: {"user": '123'});
  }
}

class MainWidget extends StatefulWidget {
  const MainWidget();

  @override
  _MainWidget createState() => _MainWidget();
}

class _MainWidget extends State {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                child: Text("channel invokeMethod error"),
                onPressed: () async {
                  final channel = const MethodChannel('crashy-custom-channel');
                  await channel.invokeMethod('blah');
                }),
            TextButton(
                child: Text("framework exception"),
                onPressed: () {
                  runFrameworkException();
                }),
            TextButton(
                child: Text("捕获主动上报 exception"),
                onPressed: () {
                  runCustomException();
                }),
            TextButton(
                child: Text("瞬间产生20条以上异常"),
                onPressed: () {
                  for (var i = 0; i < 25; i++) {
                    runCustomException();
                  }
                }),
            TextButton(
                child: Text("Isolate exception"),
                onPressed: () async {
                  Isolate isolate = await Isolate.spawn(runIsolate, []);
                  isolate.addErrorListener(RawReceivePort((pair) {
                    var error = pair[0];
                    var stacktrace = pair[1];
                    ExceptionTrace.captureException(
                        exception: Exception(error),
                        stack: stacktrace.toString());
                  }).sendPort);
                }),
          ]),
    );
  }
}

class ExceptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exception Page'),
      ),
      body: Center(
        child: MainWidget(),
      ),
    );
  }
}
