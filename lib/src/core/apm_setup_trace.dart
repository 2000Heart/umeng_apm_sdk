import 'apm_schedule_center.dart';

import 'package:umeng_apm_sdk/src/utils/helpers.dart';
import 'package:umeng_apm_sdk/src/core/apm_shared.dart';

class ApmSetupTrace extends ApmScheduleCenter {
  ApmSetupTrace() {
    // 订阅事件
    subscribeEvent({
      "type": ACTIONS.SET_DART_VERSION,
      "handler": (data) {
        String? dartVer = getDartVersion();
        if (dartVer is String) {
          setStoreProperty(name: 'dartVer', value: dartVer);
        }
      }
    });

    subscribeEvent({
      "type": ACTIONS.SET_SESSION_ID,
      "handler": (data) {
        String? sessionId = createSessionId();
        setStoreProperty(name: 'sessionId', value: sessionId);
      }
    });

    subscribeEvent({
      "type": ACTIONS.SET_PAGE_NAME,
      "handler": (route) {
        String? pageName = route!.settings!.name;
        setStoreProperty(name: 'url', value: pageName);
      }
    });

    subscribeEvent({
      "type": ACTIONS.SET_PV_ID,
      "handler": (String? data) {
        String? sessionId = createSessionId();
        setStoreProperty(name: 'pvId', value: data != null ? data : sessionId);
      }
    });
  }
}
