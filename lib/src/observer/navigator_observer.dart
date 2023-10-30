import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:umeng_apm_sdk/src/core/apm_shared.dart';
import 'package:umeng_apm_sdk/src/store/global.dart';
import 'package:umeng_apm_sdk/src/utils/helpers.dart';
import 'package:umeng_apm_sdk/src/data/pv_data.dart';
import 'package:umeng_apm_sdk/src/processor/pv_data_processor.dart';
import 'package:umeng_apm_sdk/src/core/apm_pubsub_event_center.dart';
import 'package:umeng_apm_sdk/src/core/apm_method_channel.dart';

class ApmNavigatorObserver extends NavigatorObserver {
  ApmNavigatorObserver() {
    _instance = this;
  }
  List pageStack = [];

  static ApmNavigatorObserver? _instance;

  static ApmNavigatorObserver get singleInstance =>
      _instance ??= ApmNavigatorObserver();

  Future<void> _addPageStack(Route? route) async {
    if (route != null) {
      ApmPubsubEventCenter().dispatchMultiEvent([
        {"type": ACTIONS.SET_PAGE_NAME, "data": route},
        {"type": ACTIONS.SET_PV_ID, "data": null}
      ]);
      String? pvId = GlobalStore.singleInstance.getStore[KEY_PVID];
      if (pvId != null) {
        pageStack.add({'route': route, 'pvId': pvId});
      }
      // 记录pv
      Map<String, dynamic>? nativeInfo =
          await ApmMethodChannel.getNativeParams();
      PvDataProcessor()
          .push(pvData: PvData(enableException: 'Y'), nativeInfo: nativeInfo);
      ApmPubsubEventCenter().dispatchEvent(ACTIONS.SEND_PV_LOG, null);
    }
  }

  void _removePageStack(Route? route) {
    if (route != null) {
      pageStack.remove(route);
    }
  }

  void _selectCurrentPageStack() {
    if (pageStack.length > 0) {
      pageStack.forEach((el) {
        Route? route = el!['route'];
        if (route != null) {
          bool isCurrent = route.isCurrent;
          if (isCurrent) {
            ApmPubsubEventCenter().dispatchMultiEvent([
              {"type": ACTIONS.SET_PAGE_NAME, "data": route},
              {"type": ACTIONS.SET_PV_ID, "data": el![KEY_PVID]}
            ]);
          }
        }
      });
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    nativeTryCatch(handler: () {
      _addPageStack(route);
    });
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    nativeTryCatch(handler: () {
      _addPageStack(newRoute);
    });
  }

  // 路由从导航栈被弹出时
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    nativeTryCatch(handler: () {
      _removePageStack(route);
      _selectCurrentPageStack();
    });
  }

  // 路由从导航栈被移除时
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    nativeTryCatch(handler: () {
      _removePageStack(route);
      _selectCurrentPageStack();
    });
  }
}
