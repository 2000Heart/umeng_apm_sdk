import 'package:flutter/widgets.dart';

class ApmWidgetsFlutterBinding extends WidgetsFlutterBinding {
  @override
  void handleAppLifecycleStateChanged(AppLifecycleState state) {
    super.handleAppLifecycleStateChanged(state);
  }

  static WidgetsBinding? ensureInitialized() {
    ApmWidgetsFlutterBinding();
    return WidgetsBinding.instance;
  }
}
