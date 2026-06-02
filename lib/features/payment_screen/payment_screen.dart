import 'dart:math' as math;
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/money_format.dart';
import 'package:project_l/config/injetable_config.dart';
import 'package:project_l/features/coupon_screen/coupon_modal.dart';
import 'package:project_l/features/coupon_screen/provider/coupon_provider.dart';
import 'package:project_l/features/payment_screen/provider/payment_screen_listen_state.dart';
import 'package:project_l/features/payment_screen/provider/payment_screen_provider.dart';
import 'package:project_l/remote/models/app_data.dart';
import 'package:project_l/remote/models/coupon_detail.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';

@RoutePage()
class PaymentScreenScreen extends StatefulWidget {
  const PaymentScreenScreen({
    super.key,
    this.totalPrice = 100000,
  });

  final double totalPrice;

  @override
  State<PaymentScreenScreen> createState() => _PaymentScreenScreenState();
}

class _PaymentScreenScreenState extends BasePageState<PaymentScreenListenState,
    PaymentScreenProvider, PaymentScreenScreen> {
  bool _isPaymentStep = false;
  bool _billAcceptorStarted = false;

  @override
  bool isShowCountDown() {
    return false;
  }

  @override
  int countDuration() {
    return getCounterAtIndex(3);
  }

  @override
  bool isShowNext(PaymentScreenProvider provider) {
    return false;
  }

  @override
  bool isFooterEnabled() {
    return false;
  }

  @override
  void afterFirstBuild() {
    super.afterFirstBuild();
    provider.totalPayable = widget.totalPrice;
  }

  @override
  Widget renderFooter(provider) {
    return const SizedBox.shrink();
  }

  @override
  bool allowToBack(PaymentScreenProvider provider) {
    return false;
  }

  @override
  Widget buildPage(BuildContext context, maxWidth, maxHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_isPaymentStep) {
          return _buildPaymentStep(constraints);
        }

        final contentWidth = math.min(constraints.maxWidth * 0.74, 1120.w);
        final frame = appState.imageParam.selectedFrame;
        final frameName = (frame.frameCd ?? 'Frame').replaceAll('_', '-');
        final quantity = appState.imageParam.printQuantity;
        final basePrice = frame.price ?? widget.totalPrice;
        final payable = provider.totalPayable > 0
            ? provider.totalPayable
            : widget.totalPrice;
        final extraPrice = math.max(0, payable - basePrice);

        return Stack(
          children: [
            const FlashyBoothReferenceBackground(),
            const FlashyBoothStepBar(currentIndex: 2),
            Positioned(
              top: 30.h,
              right: 112.w,
              child: const FlashyBoothLanguagePill(),
            ),
            Positioned(
              top: 74.h,
              left: 180.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flashyBoothText(
                      context,
                      vi: 'Xác nhận đơn hàng',
                      en: 'Order Summary',
                    ),
                    style: style6072400.copyWith(
                      color: FlashyBoothColors.pink,
                      fontSize: 58.sp,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    flashyBoothSecondaryText(
                      context,
                      vi: 'Xác nhận đơn hàng',
                      en: 'Order Summary',
                    ),
                    style: style24400.copyWith(
                      color: FlashyBoothColors.pinkLight,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 58.w, vertical: 46.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.68),
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: FlashyBoothColors.pink.withValues(alpha: 0.12),
                      width: 1.3.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: FlashyBoothColors.pink.withValues(alpha: 0.10),
                        blurRadius: 36.r,
                        offset: Offset(0, 16.h),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _PaymentFramePreview(),
                            SizedBox(height: 24.h),
                            Text(
                              frameName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: style24400.copyWith(
                                color: FlashyBoothColors.pinkLight,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 72.w),
                      Flexible(
                        flex: 7,
                        child: _OrderSummaryCard(
                          frameName: frameName,
                          quantity: quantity,
                          basePrice: basePrice,
                          extraPrice: extraPrice.toDouble(),
                          total: payable,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 134.w,
              bottom: 40.h,
              child: FlashyBoothRoundNavButton(
                label: flashyBoothText(context, vi: 'Sửa lại', en: 'Edit'),
                subLabel: flashyBoothSecondaryText(
                  context,
                  vi: 'Sửa lại',
                  en: 'Edit',
                ),
                onTap: () => navigator.pop(),
              ),
            ),
            Positioned(
              right: 134.w,
              bottom: 40.h,
              child: FlashyBoothRoundNavButton(
                label: flashyBoothText(context, vi: 'Xác nhận', en: 'Pay'),
                subLabel: flashyBoothSecondaryText(
                  context,
                  vi: 'Xác nhận',
                  en: 'Pay',
                ),
                onTap: _showPaymentStep,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentStep(BoxConstraints constraints) {
    final contentWidth = math.min(constraints.maxWidth * 0.58, 860.w);
    final payable =
        provider.totalPayable > 0 ? provider.totalPayable : widget.totalPrice;
    final paid = provider.currentAmount;
    final remaining = math.max(0, payable - paid);
    return Stack(
      children: [
        const FlashyBoothReferenceBackground(),
        const FlashyBoothStepBar(currentIndex: 3),
        Positioned(
          top: 30.h,
          right: 112.w,
          child: const FlashyBoothLanguagePill(),
        ),
        Positioned(
          top: 62.h,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                flashyBoothText(
                  context,
                  vi: 'Thanh toán',
                  en: 'Payment',
                ),
                style: style6072400.copyWith(
                  color: FlashyBoothColors.pink,
                  fontSize: 58.sp,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                flashyBoothSecondaryText(
                  context,
                  vi: 'Thanh toán',
                  en: 'Payment',
                ),
                style: style24400.copyWith(
                  color: FlashyBoothColors.pinkLight,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 164.h,
          right: math.max(170.w, constraints.maxWidth * 0.11),
          child: _VoucherButton(onTap: _openCoupon),
        ),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 54.w, vertical: 42.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.68),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: FlashyBoothColors.pink.withValues(alpha: 0.12),
                  width: 1.3.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: FlashyBoothColors.pink.withValues(alpha: 0.10),
                    blurRadius: 36.r,
                    offset: Offset(0, 16.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PaymentDueHero(amount: payable),
                  SizedBox(height: 28.h),
                  Row(
                    children: [
                      Expanded(
                        child: _PaymentMetricTile(
                          label: flashyBoothText(
                            context,
                            vi: 'Đã nạp',
                            en: 'Paid',
                          ),
                          amount: paid,
                        ),
                      ),
                      18.horizontalSpace,
                      Expanded(
                        child: _PaymentMetricTile(
                          label: flashyBoothText(
                            context,
                            vi: 'Còn thiếu',
                            en: 'Remaining',
                          ),
                          amount: remaining.toDouble(),
                          highlighted: remaining > 0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 26.h),
                  _PaymentInstructionButton(onTap: provider.checkMoneyValue),
                  if (appState.isMockPaymentMode) ...[
                    SizedBox(height: 22.h),
                    _MockCashPanel(),
                  ],
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 134.w,
          bottom: 40.h,
          child: FlashyBoothRoundNavButton(
            label: flashyBoothText(context, vi: 'Trước', en: 'Back'),
            subLabel: flashyBoothSecondaryText(
              context,
              vi: 'Trước',
              en: 'Back',
            ),
            onTap: () {
              provider.resetBillAcceptor();
              setState(() {
                _isPaymentStep = false;
                _billAcceptorStarted = false;
              });
            },
          ),
        ),
      ],
    );
  }

  void _showPaymentStep() {
    setState(() {
      _isPaymentStep = true;
    });
    if (!_billAcceptorStarted) {
      _billAcceptorStarted = true;
      provider.initBillAcceptor();
    }
  }

  void _openCoupon() {
    provider.resetBillAcceptor();
    final couponProvider = getIt.get<CouponProvider>();
    couponProvider.resetState();
    showGeneralDialog<CouponDetail?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Voucher',
      barrierColor: Colors.black.withValues(alpha: 0.68),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return AnimatedBuilder(
          animation: couponProvider,
          builder: (context, child) {
            return Material(
              type: MaterialType.transparency,
              child: CouponModal(
                provider: couponProvider,
                onClose: () => Navigator.of(dialogContext).pop(),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    ).then((CouponDetail? value) {
      if (value != null) {
        logD("USED COUPON  ${value.code}");
        provider.onApplyCoupon(value);
      }
      provider.enableBillAcceptor();
    });
  }
}

class _PaymentFramePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_PaymentScreenScreenState>()!;
    final frame = state.appState.imageParam.selectedFrame;
    final path = frame.frameUrlTempDis ?? frame.frameUrl ?? '';
    final frameSize = frame.getSize();
    final aspectRatio = frameSize.$1 / frameSize.$2;
    final cardHeight = frame.isVerticalHint() ? 300.h : 210.h;
    final cardWidth = cardHeight * aspectRatio;
    return Container(
      width: cardWidth + 28.w,
      height: cardHeight + 28.h,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: FlashyBoothColors.pink.withValues(alpha: 0.12),
            blurRadius: 24.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: FlashyBoothColors.pinkPale.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            Positioned.fill(
              child: _PaymentFrameSlots(frame: frame),
            ),
            if (path.isNotEmpty && File(path).existsSync())
              Positioned.fill(
                child: Image.file(
                  File(path),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PaymentFrameSlots extends StatelessWidget {
  const _PaymentFrameSlots({required this.frame});

  final FramesInfo frame;

  @override
  Widget build(BuildContext context) {
    final frameSize = frame.getSize();
    final areas = frame.getDisplayTransparentAreas(
      fallbackCount: frame.frameSetting?.numOfPhotos ?? 0,
    );
    if (areas.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleWidth = constraints.maxWidth / frameSize.$1;
        final scaleHeight = constraints.maxHeight / frameSize.$2;
        return Stack(
          children: List.generate(areas.length, (index) {
            final area = areas[index];
            return Positioned(
              left: area[0] * scaleWidth,
              top: area[1] * scaleHeight,
              width: area[2] * scaleWidth,
              height: area[3] * scaleHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFD8D5CF),
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.86),
                    width: 1.2.w,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
    required this.frameName,
    required this.quantity,
    required this.basePrice,
    required this.extraPrice,
    required this.total,
  });

  final String frameName;
  final int quantity;
  final double basePrice;
  final double extraPrice;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SummaryRow(
          label: flashyBoothText(context, vi: 'Khung', en: 'Frame'),
          value: frameName,
        ),
        _SummaryRow(
          label: flashyBoothText(context, vi: 'Số bản in', en: 'Print copies'),
          value: flashyBoothText(
            context,
            vi: '$quantity bản',
            en: '$quantity copies',
          ),
        ),
        _SummaryRow(
          label: flashyBoothText(context, vi: 'Giá cơ bản', en: 'Base price'),
          value: '${basePrice.toMoney}đ',
        ),
        _SummaryRow(
          label: flashyBoothText(
            context,
            vi: 'Bản in thêm',
            en: 'Extra prints',
          ),
          value: extraPrice > 0 ? '${extraPrice.toMoney}đ' : '0đ',
        ),
        SizedBox(height: 20.h),
        _TotalPill(total: total),
      ],
    );
  }
}

class _PaymentDueHero extends StatelessWidget {
  const _PaymentDueHero({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: FlashyBoothColors.pink,
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: FlashyBoothColors.pink.withValues(alpha: 0.24),
            blurRadius: 26.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            flashyBoothText(
              context,
              vi: 'Cần thanh toán',
              en: 'Amount due',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Lexend',
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 23.sp,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          16.verticalSpace,
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${amount.toMoney}đ',
              style: style6072400.copyWith(
                color: Colors.white,
                fontSize: 70.sp,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMetricTile extends StatelessWidget {
  const _PaymentMetricTile({
    required this.label,
    required this.amount,
    this.highlighted = false,
  });

  final String label;
  final double amount;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: highlighted
            ? FlashyBoothColors.pinkPale
            : Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: FlashyBoothColors.pink
              .withValues(alpha: highlighted ? 0.26 : 0.12),
          width: 1.3.w,
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style24400.copyWith(
              color: FlashyBoothColors.pinkLight,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          8.verticalSpace,
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${amount.toMoney}đ',
              style: style32500.copyWith(
                color: FlashyBoothColors.pink,
                fontSize: 32.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockCashPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: FlashyBoothColors.pink.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          Text(
            flashyBoothText(
              context,
              vi: 'Test tiền mặt',
              en: 'Test cash',
            ),
            style: style24400.copyWith(
              color: FlashyBoothColors.pinkLight,
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          12.verticalSpace,
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10.w,
            runSpacing: 10.h,
            children: const [
              _DenominationButton(amount: 10000),
              _DenominationButton(amount: 20000),
              _DenominationButton(amount: 50000),
              _DenominationButton(amount: 100000),
              _DenominationButton(amount: 200000),
            ],
          ),
          14.verticalSpace,
          _CompleteMockPaymentButton(),
        ],
      ),
    );
  }
}

class _CompleteMockPaymentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_PaymentScreenScreenState>()!;
    return Material(
      color: FlashyBoothColors.pink,
      borderRadius: BorderRadius.circular(999.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: state.provider.completeMockPayment,
        child: SizedBox(
          width: 260.w,
          height: 48.h,
          child: Center(
            child: Text(
              flashyBoothText(
                context,
                vi: 'Thanh toan thu',
                en: 'Mock payment',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style24400.copyWith(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DenominationButton extends StatelessWidget {
  const _DenominationButton({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_PaymentScreenScreenState>()!;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: () => state.provider.addManualAmount(amount),
        child: Container(
          width: 136.w,
          height: 46.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999.r),
            border: Border.all(color: FlashyBoothColors.pink, width: 1.8.w),
          ),
          child: Text(
            '+ ${amount.toMoney}đ',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style24400.copyWith(
              color: FlashyBoothColors.pink,
              fontSize: 17.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentInstructionButton extends StatelessWidget {
  const _PaymentInstructionButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FlashyBoothColors.pink,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: onTap,
        child: SizedBox(
          width: 480.w,
          height: 74.h,
          child: Center(
            child: Text(
              flashyBoothText(
                context,
                vi: 'Vui lòng bỏ tiền vào máy',
                en: 'Please insert cash',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style32500.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 76.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: FlashyBoothColors.pink.withValues(alpha: 0.10),
            width: 1.2.h,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style24400.copyWith(
                color: FlashyBoothColors.pinkLight,
                fontSize: 27.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(width: 24.w),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: style32500.copyWith(
                color: FlashyBoothColors.pink,
                fontSize: 30.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalPill extends StatelessWidget {
  const _TotalPill({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 108.h,
      padding: EdgeInsets.symmetric(horizontal: 36.w),
      decoration: BoxDecoration(
        color: FlashyBoothColors.pink,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Text(
            flashyBoothText(context, vi: 'Tổng cộng', en: 'Total'),
            style: style32500.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${total.toMoney}đ',
                style: style6072400.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VoucherButton extends StatelessWidget {
  const _VoucherButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(999.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: FlashyBoothColors.pink.withValues(alpha: 0.72),
                width: 2.w,
              ),
            ),
            child: Text(
              flashyBoothText(
                context,
                vi: 'Bạn có voucher không?',
                en: 'Do you have a voucher?',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style24400.copyWith(
                color: FlashyBoothColors.pink,
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
