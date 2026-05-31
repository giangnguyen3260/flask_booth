import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:project_l/common/constants/enum/bill_acceptor_response.dart';
import 'package:project_l/common/constants/enum/bill_acceptor_type_enum.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/common/util/bill_acceptor_utils.dart';
import 'package:project_l/common/util/camera_power_util.dart';
import 'package:project_l/features/payment_screen/provider/payment_screen_listen_state.dart';
import 'package:project_l/remote/models/coupon_detail.dart';

@injectable
class PaymentScreenProvider extends BaseProvider<PaymentScreenListenState> {
  final Queue<BillAcceptorResponseEnum> _cash = Queue();

  final BillAcceptorUtils _billAcceptorUtils;
  final CameraPowerUtil _cameraPowerUtil;

  double currentAmount = 0;
  double totalPayable = 0;
  double beforeDiscount = 0;
  bool _hasCompletedPayment = false;

  PaymentScreenProvider(this._billAcceptorUtils, this._cameraPowerUtil);

  void initBillAcceptor() {
    if (appState.isMockPaymentMode) {
      notifyListeners();
      return;
    }
    _billAcceptorUtils.listen(onData: (data) {
      _billAcceptorListen(data);
    });
    Future.delayed(const Duration(milliseconds: 500), () async {
      _billAcceptorUtils.disable();
      await Future.delayed(const Duration(milliseconds: 500));
      _billAcceptorUtils.enable();
    });
  }

  void enableBillAcceptor() {
    _billAcceptorUtils.enable();
  }

  void addManualAmount(double amount) {
    currentAmount += amount;
    notifyListeners();
    checkMoneyValue();
  }

  void _billAcceptorListen(BillAcceptorResponseEnum data) {
    var type = data.getType();
    if (type == BillAcceptorTypeEnum.cashValue) {
      if (_billAcceptorUtils.accept()) {
        _cameraPowerUtil.turnOnCamera();
        _cash.add(data);
      }
    } else if (data == BillAcceptorResponseEnum.stacking) {
      while (_cash.isNotEmpty) {
        final cashMoney = _cash.removeFirst().getMoneyValue();
        currentAmount = currentAmount + cashMoney;
      }
      notifyListeners();
      checkMoneyValue();
    }
  }

  void onApplyCoupon(CouponDetail couponDetail) {
    if (!couponDetail.isEmpty) {
      beforeDiscount = totalPayable;
      if ((couponDetail.discountType ?? '') == "FIXED") {
        totalPayable = (totalPayable - (couponDetail.discount ?? 0))
            .clamp(0, beforeDiscount);
      } else if ((couponDetail.discountType ?? '') == "PERCENTAGE") {
        final rawDiscount = couponDetail.discount ?? 0;
        final discountRate = rawDiscount > 1 ? rawDiscount / 100 : rawDiscount;
        totalPayable = (totalPayable - (totalPayable * discountRate))
            .clamp(0, beforeDiscount);
      }
      appState.updateCoupon(couponDetail.code ?? '');
      notifyListeners();
      checkMoneyValue();
    }
  }

  checkMoneyValue() {
    if (_hasCompletedPayment) {
      return;
    }
    if (currentAmount >= totalPayable) {
      _hasCompletedPayment = true;
      Future.delayed(Duration(milliseconds: 500), () {
        resetBillAcceptor();
        navigator.replaceAll([ShootingGuideRouteRoute()]);
      });
    }
  }

  void resetBillAcceptor() {
    _billAcceptorUtils.disable();
  }

  @override
  void dispose() {
    super.dispose();
    resetBillAcceptor();
    _billAcceptorUtils.closeSection();
  }
}
