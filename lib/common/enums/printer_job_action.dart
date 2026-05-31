enum PrinterJobAction {
  pause(1),
  resume(2),
  cancel(3),
  restart(4),
  delete(5),
  sentToPrinter(6),
  lastPageEjected(7);

  final int value;

  const PrinterJobAction(this.value);
}
