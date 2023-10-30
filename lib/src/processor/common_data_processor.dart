import 'package:umeng_apm_sdk/src/data/data.dart';
import 'package:umeng_apm_sdk/src/core/apm_shared.dart';
import 'package:umeng_apm_sdk/src/core/apm_schedule_center.dart';
import 'package:umeng_apm_sdk/src/core/apm_log_queue_manager.dart';

class CommonDataProcessor extends ApmScheduleCenter {
  CommonDataProcessor();
  void addRecord(
      {required ReportLogType reportType,
      required ReportQueueType reportQueueType,
      required PreProcessData log,
      Function? callback}) {
    ApmLogQueueManager.singleInstance.addRecord(
        reportType: reportType,
        reportQueueType: reportQueueType,
        log: log,
        callback: callback);
  }
}
