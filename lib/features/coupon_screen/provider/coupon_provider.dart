import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/coupon_screen/provider/coupon_listen_state.dart';
import 'package:project_l/remote/models/coupon_detail.dart';

@Injectable()
class CouponProvider extends BaseProvider<CouponListenState> {
  bool isLoading = false;
  String? error;

  void resetState() {
    isLoading = false;
    error = "";
    notifyListeners();
  }

  Future<void> checkCoupon(String id) async {
    final couponDetail = await validateCoupon(id);
    if (couponDetail != null) {
      navigator.maybePop(couponDetail);
    }
  }

  Future<CouponDetail?> validateCoupon(String id) async {
    final couponCode = id.trim();
    isLoading = true;
    error = "";
    notifyListeners();

    try {
      CouponDetail couponDetail = await appService.validCoupon(couponCode);
      if (couponDetail.isEmpty) {
        throw Exception();
      }
      return couponDetail;
    } catch (e) {
      error = _resolveErrorMessage(e) ?? "Coupon không hợp lệ!";
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? _resolveErrorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        final apiError = data['error'];
        if (apiError is Map<String, dynamic>) {
          final message = apiError['message'];
          if (message is String && message.isNotEmpty) {
            return message;
          }
        }
        final message = data['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
      if (error.message != null && error.message!.isNotEmpty) {
        return error.message;
      }
    }
    return null;
  }
}
