enum BillAcceptorCommand {
  start(0x02),
  reset(0x30),
  accept(0x02),
  holdInEscrow(0x18),
  reject(0x0f),
  requestStatus(0x0c),
  enableBillAcceptor(0x3e),
  disableBillAcceptor(0x5e);

  final int value;

  const BillAcceptorCommand(this.value);
}
