import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/money_format.dart';
import 'package:project_l/features/choose_frame_quantity/provider/choose_frame_quantity_listen_state.dart';
import 'package:project_l/features/choose_frame_quantity/provider/choose_frame_quantity_provider.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';

@RoutePage()
class ChooseFrameQuantityScreen extends StatefulWidget {
  const ChooseFrameQuantityScreen({super.key});

  @override
  State<ChooseFrameQuantityScreen> createState() =>
      _ChooseFrameQuantityScreenState();
}

class _ChooseFrameQuantityScreenState extends BasePageState<
    ChooseFrameQuantityListenState,
    ChooseFrameQuantityProvider,
    ChooseFrameQuantityScreen> {
  @override
  bool isShowNext(ChooseFrameQuantityProvider provider) {
    return false;
  }

  @override
  bool isShowCountDown() {
    return false;
  }

  @override
  bool isFooterEnabled() {
    return false;
  }

  @override
  bool allowToBack(ChooseFrameQuantityProvider provider) {
    return false;
  }

  @override
  void onNext(ChooseFrameQuantityProvider provider) {
    super.onNext(provider);
    appState.updatePrintQuantity(provider.frameQty);
    navigator.push(PaymentRouteRoute(totalPrice: provider.totalPrice));
  }

  @override
  int countDuration() {
    return getCounterAtIndex(2);
  }

  @override
  Widget buildPage(BuildContext context, maxWidth, maxHeight) {
    return Stack(
      children: [
        const FlashyBoothReferenceBackground(),
        const FlashyBoothStepBar(currentIndex: 1),
        Positioned(
          top: 30.h,
          right: 112.w,
          child: const FlashyBoothLanguagePill(),
        ),
        Positioned(
          top: 48.h,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                flashyBoothText(
                  context,
                  vi: 'Vui lòng chọn số lượng ảnh',
                  en: 'Please select photo quantity',
                ),
                style: style6072400.copyWith(
                  color: FlashyBoothColors.pink,
                  fontWeight: FontWeight.w900,
                  fontSize: 56.sp,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                flashyBoothSecondaryText(
                  context,
                  vi: 'Vui lòng chọn số lượng ảnh',
                  en: 'Select number of photos',
                ),
                style: style24400.copyWith(
                  color: FlashyBoothColors.pinkLight,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          top: 170.h,
          child: Center(
            child: Container(
              width: 780.w,
              padding: EdgeInsets.symmetric(horizontal: 58.w, vertical: 48.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.68),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: FlashyBoothColors.pink.withValues(alpha: 0.12),
                  width: 1.4.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: FlashyBoothColors.pink.withValues(alpha: 0.10),
                    blurRadius: 34.r,
                    offset: Offset(0, 16.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _QuantityIconButton(
                        icon: Icons.remove_rounded,
                        enabled: provider.frameQty > provider.printQuantity,
                        onTap: provider.reduceFrame,
                      ),
                      SizedBox(width: 64.w),
                      _QuantityDisplay(value: provider.frameQty),
                      SizedBox(width: 64.w),
                      _QuantityIconButton(
                        icon: Icons.add_rounded,
                        enabled: provider.frameQty < provider.addPhotoLimit,
                        onTap: provider.increaseFrame,
                      ),
                    ],
                  ),
                  SizedBox(height: 36.h),
                  _PricePill(price: provider.totalPrice.toMoney),
                  SizedBox(height: 22.h),
                  _PriceNote(provider: provider),
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
            onTap: () => navigator.pop(),
          ),
        ),
        Positioned(
          right: 134.w,
          bottom: 40.h,
          child: FlashyBoothRoundNavButton(
            label: flashyBoothText(context, vi: 'Tiếp', en: 'Next'),
            subLabel: flashyBoothSecondaryText(
              context,
              vi: 'Tiếp',
              en: 'Next',
            ),
            onTap: () => onNext(provider),
          ),
        ),
      ],
    );
  }
}

class _QuantityIconButton extends StatelessWidget {
  const _QuantityIconButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: enabled ? 1 : 0.5),
      shape: CircleBorder(
        side: BorderSide(
          color: FlashyBoothColors.pink.withValues(alpha: enabled ? 1 : 0.32),
          width: 3.w,
        ),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 98.w,
          height: 98.w,
          child: Icon(
            icon,
            size: 54.r,
            color: FlashyBoothColors.pink.withValues(alpha: enabled ? 1 : 0.32),
          ),
        ),
      ),
    );
  }
}

class _QuantityDisplay extends StatelessWidget {
  const _QuantityDisplay({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 292.w,
      height: 292.w,
      decoration: BoxDecoration(
        color: FlashyBoothColors.pink,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: FlashyBoothColors.pink.withValues(alpha: 0.24),
            blurRadius: 30.r,
            offset: Offset(0, 14.h),
          ),
        ],
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            value.toString(),
            key: ValueKey(value),
            style: TextStyle(
              fontFamily: 'Lexend',
              color: Colors.white,
              fontSize: 118.sp,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 184.w,
        maxWidth: 300.w,
      ),
      child: Container(
        height: 54.h,
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        decoration: BoxDecoration(
          color: FlashyBoothColors.pink,
          borderRadius: BorderRadius.circular(999.r),
        ),
        alignment: Alignment.center,
        child: Text(
          '$priceđ',
          style: style2432500.copyWith(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PriceNote extends StatelessWidget {
  const _PriceNote({required this.provider});

  final ChooseFrameQuantityProvider provider;

  @override
  Widget build(BuildContext context) {
    final extraEnabled =
        provider.addPhotoNumber > 0 && provider.additionPrice > 0;
    final text = extraEnabled
        ? flashyBoothText(
            context,
            vi: 'Giá cơ bản ${provider.price.toMoney}đ. Thêm ${provider.addPhotoNumber} ảnh +${provider.additionPrice.toMoney}đ.',
            en: 'Base price ${provider.price.toMoney}đ. Add ${provider.addPhotoNumber} photos +${provider.additionPrice.toMoney}đ.',
          )
        : flashyBoothText(
            context,
            vi: 'Giá cơ bản ${provider.price.toMoney}đ.',
            en: 'Base price ${provider.price.toMoney}đ.',
          );
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 740.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style24400.copyWith(
          color: FlashyBoothColors.muted,
          fontWeight: FontWeight.w700,
          fontSize: 22.sp,
        ),
      ),
    );
  }
}
