enum PrinterJobStatus {
  paused(1),
  error(2),
  deleting(4),
  spooling(8),
  printing(16),
  offline(32),
  paperOut(64),
  blockedDevQ(256),
  userIntervention(512),
  restart(1024),
  sendToPrinter(2048),
  deleted(4096),
  completed(8192),
  printed(16384),
  aborted(32768),
  unknown(0);

  final int value;

  const PrinterJobStatus(this.value);

  // Convert integer value to enum
  static PrinterJobStatus fromValue(int value) {
    for (var status in PrinterJobStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    return PrinterJobStatus.unknown;
  }
}
