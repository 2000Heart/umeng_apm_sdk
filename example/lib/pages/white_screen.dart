import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';
import 'dart:isolate';

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
                child: Text("white screen exception"), onPressed: () async {}),
          ]),
    );
  }
}

class WhiteScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 数组越界 主动造成渲染异常导致白屏
    const arr = [];
    arr[1];
    return Scaffold(
      appBar: AppBar(
        title: Text('white screen Page'),
      ),
      body: Center(
        child: MainWidget(),
      ),
    );
  }
}
