class PvData {
  String? enableException;

  PvData({required this.enableException});

  Map<String, dynamic>? getPreproccessTypeLog() {
    return {
      "enableException": enableException,
    };
  }

  String getSendTypeLog() {
    return [enableException].join('|');
  }
}
