import 'package:project_l/common/constants/enum/bill_acceptor_type_enum.dart';
import 'package:project_l/common/constants/failure.dart';

enum BillAcceptorResponseEnum {
  powerOn,
  status,
  firstBillType,
  secondBillType,
  thirdBillType,
  fourthBillType,
  fifthBillType,
  sixthBillType,
  stacking,
  reject,
  motorFailure,
  checksumError,
  billJam,
  billRemove,
  stackerOpen,
  sensorProblem,
  billFish,
  stackerProblem,
  billReject,
  invalidCommand,
  reserved,
  responseWhenErrorStatusIsExclusion,
  billAcceptorEnableStatus,
  billAcceptorInhibitStatus,
  unknown;

  static BillAcceptorResponseEnum fromValue(String value) {
    return BillAcceptorResponseEnum.values.firstWhere(
        (element) => element.name == value,
        orElse: () => BillAcceptorResponseEnum.unknown);
  }
}

extension BillAcceptorResponseEnumExtension on BillAcceptorResponseEnum {
  BillAcceptorTypeEnum getType() {
    switch (this) {
      case BillAcceptorResponseEnum.powerOn:
      case BillAcceptorResponseEnum.status:
      case BillAcceptorResponseEnum.reserved:
      case BillAcceptorResponseEnum.responseWhenErrorStatusIsExclusion:
      case BillAcceptorResponseEnum.billAcceptorEnableStatus:
      case BillAcceptorResponseEnum.billAcceptorInhibitStatus:
      case BillAcceptorResponseEnum.stacking:
      case BillAcceptorResponseEnum.reject:
        return BillAcceptorTypeEnum.information;
      case BillAcceptorResponseEnum.firstBillType:
      case BillAcceptorResponseEnum.secondBillType:
      case BillAcceptorResponseEnum.thirdBillType:
      case BillAcceptorResponseEnum.fourthBillType:
      case BillAcceptorResponseEnum.fifthBillType:
      case BillAcceptorResponseEnum.sixthBillType:
        return BillAcceptorTypeEnum.cashValue;
      case BillAcceptorResponseEnum.motorFailure:
      case BillAcceptorResponseEnum.checksumError:
      case BillAcceptorResponseEnum.billJam:
      case BillAcceptorResponseEnum.billRemove:
      case BillAcceptorResponseEnum.stackerOpen:
      case BillAcceptorResponseEnum.sensorProblem:
      case BillAcceptorResponseEnum.billFish:
      case BillAcceptorResponseEnum.stackerProblem:
      case BillAcceptorResponseEnum.billReject:
      case BillAcceptorResponseEnum.invalidCommand:
        return BillAcceptorTypeEnum.error;
      case BillAcceptorResponseEnum.unknown:
        return BillAcceptorTypeEnum.unknown;
    }
  }

  int getMoneyValue() {
    switch (this) {
      case BillAcceptorResponseEnum.firstBillType:
        return 5000;
      case BillAcceptorResponseEnum.secondBillType:
        return 10000;

      case BillAcceptorResponseEnum.thirdBillType:
        return 20000;

      case BillAcceptorResponseEnum.fourthBillType:
        return 50000;

      case BillAcceptorResponseEnum.fifthBillType:
        return 100000;

      case BillAcceptorResponseEnum.sixthBillType:
        return 200000;
      default:
        throw InternalError(
            message: "This enum is not BillAcceptorTypeEnum.cashValue");
    }
  }
}

class BillAcceptorResponse {}
