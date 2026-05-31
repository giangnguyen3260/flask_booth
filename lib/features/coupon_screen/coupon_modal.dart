import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/features/coupon_screen/provider/coupon_provider.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';

class CouponModal extends StatefulWidget {
  const CouponModal({
    super.key,
    required this.provider,
    required this.onClose,
  });

  final CouponProvider provider;
  final VoidCallback onClose;

  @override
  State<CouponModal> createState() => _CouponModalState();
}

class _CouponModalState extends State<CouponModal> {
  final TextEditingController _textEditingController = TextEditingController();

  static const List<List<String>> _keyboardRows = [
    ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Z'],
    ['X', 'C', 'V', 'B', 'N', 'M', 'BACK', 'CLEAR'],
  ];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final modalWidth = (constraints.maxWidth * 0.46).clamp(620.0, 830.0);
        final modalHeight = (constraints.maxHeight * 0.72).clamp(560.0, 710.0);
        return Center(
          child: Container(
            width: modalWidth.w,
            constraints: BoxConstraints(maxHeight: modalHeight.h),
            padding: EdgeInsets.fromLTRB(58.w, 50.h, 58.w, 34.h),
            decoration: BoxDecoration(
              color: FlashyBoothColors.cream,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 34.r,
                  offset: Offset(0, 18.h),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flashyBoothText(
                                context,
                                vi: 'Bạn có voucher không?',
                                en: 'Do you have a voucher?',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: style6072400.copyWith(
                                color: FlashyBoothColors.pink,
                                fontSize: 50.sp,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              flashyBoothSecondaryText(
                                context,
                                vi: 'Bạn có voucher không?',
                                en: 'Do you have a voucher?',
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
                      SizedBox(width: 18.w),
                      _CloseButton(onTap: widget.onClose),
                    ],
                  ),
                  SizedBox(height: 34.h),
                  _CouponInput(controller: _textEditingController),
                  SizedBox(height: 62.h),
                  _Keyboard(rows: _keyboardRows, onKeyTap: _onKeyTap),
                  SizedBox(height: 28.h),
                  _VerifyButton(
                    isLoading: widget.provider.isLoading,
                    onTap: _verify,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    widget.provider.error?.isNotEmpty == true
                        ? widget.provider.error!
                        : flashyBoothText(
                            context,
                            vi: 'Gợi ý: STORMICK10 · BEOBEO · VIP50K · STORMICK20',
                            en: 'Hint: STORMICK10 · BEOBEO · VIP50K · STORMICK20',
                          ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: style24400.copyWith(
                      color: widget.provider.error?.isNotEmpty == true
                          ? FlashyBoothColors.danger
                          : FlashyBoothColors.pinkLight,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _verify() async {
    if (_textEditingController.text.isEmpty) {
      return;
    }
    final couponDetail =
        await widget.provider.validateCoupon(_textEditingController.text);
    if (couponDetail != null && mounted) {
      Navigator.of(context).pop(couponDetail);
    }
  }

  void _onKeyTap(String value) {
    if (value == 'BACK') {
      _removeLast();
      return;
    }
    if (value == 'CLEAR') {
      setState(_textEditingController.clear);
      return;
    }
    setState(() {
      _textEditingController.text = '${_textEditingController.text}$value';
    });
  }

  void _removeLast() {
    if (_textEditingController.text.isEmpty) {
      return;
    }
    setState(() {
      final text = _textEditingController.text;
      _textEditingController.text = text.substring(0, text.length - 1);
    });
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(
        side: BorderSide(color: FlashyBoothColors.pink, width: 2.w),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 46.w,
          height: 46.w,
          child: Icon(
            Icons.close_rounded,
            color: FlashyBoothColors.pink,
            size: 30.r,
          ),
        ),
      ),
    );
  }
}

class _CouponInput extends StatelessWidget {
  const _CouponInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.h,
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.r),
        border: Border.all(color: FlashyBoothColors.pink, width: 2.4.w),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        readOnly: true,
        textAlign: TextAlign.left,
        style: style24400.copyWith(
          color: FlashyBoothColors.pink,
          fontSize: 28.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
        decoration: InputDecoration.collapsed(
          hintText: flashyBoothText(
            context,
            vi: 'Nhập mã voucher...',
            en: 'Enter voucher code...',
          ),
          hintStyle: style24400.copyWith(
            color: FlashyBoothColors.pinkLight.withValues(alpha: 0.58),
            fontSize: 27.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _Keyboard extends StatelessWidget {
  const _Keyboard({required this.rows, required this.onKeyTap});

  final List<List<String>> rows;
  final ValueChanged<String> onKeyTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows.map((row) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            children: row.map((keyValue) {
              final flex = keyValue == 'CLEAR' ? 2 : 1;
              return Expanded(
                flex: flex,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: _KeyboardKey(
                    value: keyValue,
                    onTap: () => onKeyTap(keyValue),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _KeyboardKey extends StatelessWidget {
  const _KeyboardKey({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isBack = value == 'BACK';
    final isClear = value == 'CLEAR';
    final displayValue =
        isClear ? flashyBoothText(context, vi: 'XÓA', en: 'CLEAR') : value;
    return Material(
      color: const Color(0xFFF2E8ED),
      borderRadius: BorderRadius.circular(6.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(6.r),
        onTap: onTap,
        child: Container(
          height: 52.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: FlashyBoothColors.pink.withValues(alpha: 0.12),
            ),
          ),
          child: isBack
              ? Icon(
                  Icons.backspace_outlined,
                  color: FlashyBoothColors.pink,
                  size: 22.r,
                )
              : Text(
                  displayValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style24400.copyWith(
                    color: FlashyBoothColors.pink,
                    fontSize: isClear ? 14.sp : 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
        ),
      ),
    );
  }
}

class _VerifyButton extends StatelessWidget {
  const _VerifyButton({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FlashyBoothColors.pinkLight,
      borderRadius: BorderRadius.circular(7.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(7.r),
        onTap: isLoading ? null : onTap,
        child: SizedBox(
          height: 66.h,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 28.w,
                    height: 28.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    flashyBoothText(
                      context,
                      vi: 'Xác nhận',
                      en: 'Verify',
                    ),
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
