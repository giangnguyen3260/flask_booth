import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/remote/network_provider.dart';
import 'package:project_l/remote/models/app_data.dart';
import 'package:project_l/remote/models/coupon_detail.dart';
import 'package:project_l/remote/models/kiosk_event_response.dart';
import 'package:project_l/remote/models/kiosk_heartbeat_response.dart';
import 'package:project_l/remote/models/main_info_version.dart';
import 'package:project_l/remote/models/printer_status_response.dart';
import 'package:project_l/remote/models/qr_detail.dart';
import 'package:retrofit/retrofit.dart';

part 'app_service.g.dart';

@RestApi()
@singleton
abstract class RestClient {
  @FactoryMethod()
  factory RestClient(NetworkProvider networkProvider) =>
      _RestClient(networkProvider.appDio);

  @GET('/pub/main-info')
  Future<AppData> initData();

  @GET('/pub/main-info/version')
  Future<MainInfoVersion> fetchMainInfoVersion();

  @POST('/pub/kiosks/{kioskCode}/heartbeat')
  Future<KioskHeartbeatResponse> sendHeartbeat(
    @Path() String kioskCode,
    @Body() Map<String, Object?> request,
  );

  @POST('/pub/kiosks/{kioskCode}/events')
  Future<KioskEventResponse> sendEvent(
    @Path() String kioskCode,
    @Body() Map<String, Object?> request,
  );

  @GET('/coupons/validate/{id}')
  Future<CouponDetail> validCoupon(@Path() String id);

  @MultiPart()
  @POST('/pub/submit')
  Future<QRDetail> submit({
    @Part(name: "saleNo") required String saleNo,
    @Part(name: "frameId") required String frameId,
    @Part(name: "img") required List<MultipartFile> img,
    @Part(name: "video") required List<MultipartFile> video,
    @Part(name: "cuKey") String? cuKey,
    @Part(name: "amount") required double amount,
    @Part(name: "printQuantity") required int printQuantity,
  });

  @POST('/pub/printers/status')
  Future<PrinterStatusResponse> reportPrinterStatus(
    @Body() Map<String, Object?> request,
  );
}
