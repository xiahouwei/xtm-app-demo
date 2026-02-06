class TraceidManage {
  final String version;
  final String platform;
  final String traceFlag;
  TraceidManage({this.version, this.platform, this.traceFlag});
  final _traceIdLength = 32;
  final _spanLength = 16;
  int _incrementIndex = 1;
  String padTraceId(String str) {
    if (str.length >= _traceIdLength) {
      return str.substring(0, _traceIdLength);
    }
    return str.padLeft(_traceIdLength, '0');
  }

  String encodeProjectToSpanId(String str) {
    final hex = str.runes.map((r) => r.toRadixString(16).padLeft(2, '0')).join('');
    if (hex.length >= _spanLength) {
      return hex.substring(0, _spanLength);
    }
    return hex.padLeft(_spanLength, '0');
  }

  String createTraceId(String key) {
    final spanId = encodeProjectToSpanId(platform);
    final current = _incrementIndex;
    _incrementIndex = _incrementIndex >= 99 ? 1 : _incrementIndex + 1;
    final count = current.toString().padLeft(2, '0');
    final traceId = padTraceId('${key}${DateTime.now().millisecondsSinceEpoch}${count}');
    return '${version}-${traceId}-${spanId}-${traceFlag}';
  }
}
