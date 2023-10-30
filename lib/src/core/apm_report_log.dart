import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:umeng_apm_sdk/src/data/data.dart';
import 'package:umeng_apm_sdk/src/core/apm_shared.dart';
import 'package:umeng_apm_sdk/src/core/apm_request.dart';
import 'package:umeng_apm_sdk/src/utils/helpers.dart';
import 'package:umeng_apm_sdk/src/core/apm_schedule_center.dart';
import 'package:umeng_apm_sdk/src/core/apm_log_queue_manager.dart';
import 'package:umeng_apm_sdk/src/core/apm_cloud_config_manager.dart';

class ApmReportLog extends ApmScheduleCenter {
  int prefLogMergeNumberLimit = 10;

  int exceptionLogMergeNumberLimit = 5;

  late final int exceptionLogMaxSizeLimit = 20 * 1024;

  int pollTime = 5;

  ApmReportLog();

  void subscribe() {
    subscribeEvent({
      "type": ACTIONS.SEND_PV_LOG,
      "handler": (data) {
        logPreProcessHandler(reportLogType: ReportLogType.pv);
      }
    });
  }

  void startTimerPollSendQueue() {
    Timer.periodic(Duration(seconds: pollTime), (Timer t) {
      nativeTryCatch(handler: () {
        logPreProcessHandler(reportLogType: ReportLogType.exception);
      });
    });
  }

  String? _getHeaderLog() {
    return HeaderData(
            name: getStore['name'],
            bver: getStore['bver'],
            flutterVer: getStore['flutterVersion'],
            engineVer: getStore['engineVersion'],
            dartVer: getStore['dartVer'],
            sdkVer: getStore['sdkVersion'],
            fsid: getStore['sessionId'],
            projectType: getStore['projectType'])
        .getSendTypeLog();
  }

  Map<String, dynamic>? _getBaseInfo() {
    return getStore[KEY_BASEINFO];
  }

  Map<String, dynamic>? _logMerge(
      {required List logs, ReportLogType logType = ReportLogType.pv}) {
    if (logs.isEmpty) return null;
    List sendLogs = [];
    logs.forEach((element) {
      Map? obj = element!.get();
      dynamic commonInstance = obj![KEY_COMMON];
      dynamic logInstance = obj[KEY_LOG];
      String commonStr = commonInstance!.getSendTypeLog();
      String logStr = logInstance!.getSendTypeLog();
      if (commonStr.isEmpty || logStr.isEmpty) return;
      sendLogs.add('$commonStr' + '|\$|' + '$logStr');
    });
    String? headerLog = _getHeaderLog();
    Map<String, dynamic>? baseInfo = _getBaseInfo();
    if (baseInfo == null || baseInfo.isEmpty) return null;
    if (headerLog == null || headerLog.isEmpty) return null;
    baseInfo[KEY_FLUTTER] = '$headerLog|^|${sendLogs.join(',')}';

    baseInfo[KEY_TYPE] = (logType == ReportLogType.exception
        ? KEY_FLUTTER_ERROR
        : KEY_FLUTTER_PERF);
    return baseInfo;
  }

  void _requestSendLog(
      {required List logList, ReportLogType logType = ReportLogType.pv}) {
    Map<String, dynamic>? fullLog = _logMerge(logs: logList, logType: logType);

    if (fullLog is Map) {
      final ApmRequest ins = ApmRequest();
      final ApmCloudConfigManager apmCloudConfigManager =
          ApmCloudConfigManager.singleInstance;
      ins.retryHttpClient(
          body: fullLog,
          requestInstance: ins.post,
          maxRetries: 1,
          retryInterval: Duration(seconds: 3),
          successHandler: () async {
            bool isSuccess = await apmCloudConfigManager.recordLogCount(
                logType, logList.length);
            if (isSuccess) {
              DateTime now = DateTime.now();
              apmCloudConfigManager
                  .setLastLogTimestamp(now.millisecondsSinceEpoch);
            } else {
              warnLog('$logType 记数失败');
            }
            return;
          },
          failHandler: () {});
    }
  }

  void logPreProcessHandler({required ReportLogType reportLogType}) {
    int logSize = 0;
    List logList = [];
    nativeTryCatch(handler: () async {
      final ApmLogQueueManager instance = ApmLogQueueManager.singleInstance;
      final Queue? queue = instance.getQueueObject(
          reportType: reportLogType, reportQueueType: ReportQueueType.pre);
      final ApmCloudConfigManager apmCloudConfigManager =
          ApmCloudConfigManager.singleInstance;

      if (queue is Queue && queue.length != 0) {
        await apmCloudConfigManager.initNativeStore();

        int diffVal =
            await apmCloudConfigManager.getRemainingLogCount(reportLogType);
        if (diffVal <= 0) {
          warnLog('$reportLogType 日志到达最高上报限制');
          return;
        }

        switch (reportLogType) {
          case ReportLogType.pv:
            queue.removeWhere((element) {
              var el = element.get();
              if (el![KEY_TYPE] == ReportLogType.pv) {
                logList.add(element);
                return true;
              }
              return false;
            });

            // 发送日志
            _requestSendLog(logList: logList);
            break;

          case ReportLogType.exception:
            int mergeNumber = diffVal >= exceptionLogMergeNumberLimit
                ? exceptionLogMergeNumberLimit
                : diffVal;
            Iterable<dynamic> logs = queue.take(mergeNumber);

            if (logs.length == 0) return;
            printLog('处理异常日志数${logs.length}');

            for (PreProcessData element in logs) {
              logList.add(element);

              Map<String, dynamic>? fullLog =
                  _logMerge(logs: logList, logType: ReportLogType.exception);

              if (fullLog is Map && fullLog!.isNotEmpty) {
                try {
                  String fullLogStr = jsonEncode(fullLog);
                  logSize += getSizeInBytes(fullLogStr);

                  bool result =
                      checkStringSize(fullLogStr, exceptionLogMaxSizeLimit);
                  printLog('累计日志字节大小$logSize');

                  if (result) {
                    if (logList.length == 1) {
                      queue.removeFirst();
                    }
                    logList.removeLast();
                    break;
                  }
                } catch (e) {}
              }
            }

            if (logList.length > 0) {
              logList.forEach((element) {
                queue.removeWhere((el) {
                  return element == el;
                });
              });
            }

            _requestSendLog(logList: logList, logType: ReportLogType.exception);

            break;
          default:
        }
      }
    });
  }
}
