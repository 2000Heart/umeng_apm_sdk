import 'package:umeng_apm_sdk/src/data/data.dart';
import 'package:umeng_apm_sdk/src/core/apm_shared.dart';
import 'package:umeng_apm_sdk/src/processor/common_data_processor.dart';
import 'package:umeng_apm_sdk/src/utils/helpers.dart';

class PvDataProcessor extends CommonDataProcessor {
  push({required PvData pvData, Map? nativeInfo}) {
    nativeTryCatch(handler: () {
      nativeInfo ??= {};

      final commonLog = CommonData(
        logType: 'pv',
        url: getStore['url'] ?? '-',
        pvId: getStore['pvId'] ?? '-',
        access: nativeInfo!['um_access'] ?? '-',
        accessSubtype: nativeInfo!['um_access_subtype'] ?? '-',
        battery: nativeInfo!['battery'] ?? '-',
        temperature: nativeInfo!['temperature'] ?? '-',
        diskRatio: nativeInfo!['disk_ratio'] ?? '-',
        state: nativeInfo!['state'] ?? '-',
        sid: nativeInfo!['um_session_id'] ?? '-',
      );

      this.addRecord(
          reportType: ReportLogType.pv,
          reportQueueType: ReportQueueType.pre,
          log: PreProcessData(
              commonLog: commonLog, log: pvData, type: ReportLogType.pv));
    });
  }
}
