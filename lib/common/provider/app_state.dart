import 'dart:async' as async;
import 'dart:convert';
import 'dart:io';

import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_l/common/log/log_mixin.dart';
import 'package:project_l/common/models/effect.dart';
import 'package:project_l/common/models/image_param.dart';
import 'package:project_l/common/models/matrix_param.dart';
import 'package:project_l/common/remote/network_provider.dart';
import 'package:project_l/common/util/bill_acceptor_utils.dart';
import 'package:project_l/common/util/camera_power_util.dart';
import 'package:project_l/common/util/camera_utils.dart';
import 'package:project_l/common/util/background_mask_utils.dart';
import 'package:project_l/common/util/remote_image_utils.dart';
import 'package:project_l/config/injetable_config.dart';
import 'package:project_l/common/models/app_theme_config.dart';
import 'package:project_l/remote/models/app_data.dart';
import 'package:project_l/remote/service/app_service.dart';
import 'package:uuid/uuid.dart';

@singleton
class AppState extends ChangeNotifier with LogMixin {
  Locale locate = const Locale("vi");
  final RemoteImageUtils remoteImageUtils;
  final BackgroundMaskUtils backgroundMaskUtils = BackgroundMaskUtils();
  ImageParam imageParam = ImageParam();

  final RestClient restClient;
  final NetworkProvider networkProvider;
  AppData appData = const AppData();
  Map<String, dynamic> appConfig = {};
  String kioskCode = '';
  String remoteApiBaseUrl = '';
  String appVersion = '';
  String currentScreen = 'STANDBY';
  String cameraMode = 'canon';
  bool _hasLocalRuntimeConfig = false;
  final CameraPowerUtil cameraPowerUtil = getIt.get();
  final CameraUtils cameraUtils = getIt.get();
  async.Timer? _heartbeatTimer;

  AppState({
    required this.restClient,
    required this.remoteImageUtils,
    required this.networkProvider,
  });

  bool isInitSuccess = false;

  List<FramesInfo> get frameInfos => appData.framesInfo ?? [];

  AppThemeConfig get themeConfig => AppThemeConfig.fromAppData(appData);

  FramesInfo? findByCode(String frameCd) {
    if (frameInfos.isEmpty) {
      return null;
    }
    for (final frameInfo in frameInfos) {
      if (frameInfo.frameCd == frameCd) {
        return frameInfo;
      }
    }
    return null;
  }

  Future<void> init() async {
    try {
      await _loadLocalConfig();
      await _loadAppVersion();
      await _loadRemoteData();
      _applyDefaultLocale();
      isInitSuccess = true;
      notifyListeners();
      _startHeartbeat();
    } catch (e, stackTrace) {
      logE(e, stackTrace: stackTrace);
      isInitSuccess = false;
      notifyListeners();
    }
  }

  Future<void> _loadLocalConfig() async {
    try {
      final supportDirectory = await getApplicationSupportDirectory();
      final configDirectory = Platform.environment['PTB_APP_CONFIG_PATH']
                  ?.trim()
                  .isNotEmpty ==
              true
          ? Platform.environment['PTB_APP_CONFIG_PATH']!.trim()
          : Platform.isWindows
              ? '${supportDirectory.path.split('Roaming').first}Local\\Project_L\\app_config.json'
              : '${supportDirectory.path}/project_l/app_config.json';

      logD("************* Config ***************");
      logD(configDirectory);

      final file = File(configDirectory);
      final jsonConfig = await file.readAsString();
      appConfig = jsonDecode(jsonConfig) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      appConfig = {};
    }

    final cameraConfig = _readConfigSection("camera");
    final billAcceptorConfig = _readConfigSection("bill_acceptor");
    final kioskConfig = _readConfigSection("kiosk");
    final serverConfig = _readConfigSection("server");
    final remoteApiConfig = _readConfigSection("remote_api");
    _hasLocalRuntimeConfig = appConfig.isNotEmpty;

    if (!isMockCameraMode && cameraConfig.isNotEmpty) {
      cameraPowerUtil.cameraPowerConfig = cameraConfig;
      cameraPowerUtil.connect();
    }

    var billAcceptorUtils = getIt.get<BillAcceptorUtils>();
    if (!isMockCameraMode && billAcceptorConfig.isNotEmpty) {
      billAcceptorUtils.billAcceptorConfig = billAcceptorConfig;
      billAcceptorUtils.connect();
    }

    kioskCode =
        _readConfigValue(kioskConfig, const ["kioskCode", "kiosk_code"]);
    cameraMode =
        (Platform.environment['PTB_CAMERA_MODE'] ?? '').trim().isNotEmpty
            ? Platform.environment['PTB_CAMERA_MODE']!.trim()
            : _readConfigValue(
                cameraConfig,
                const ["mode", "cameraMode", "camera_mode"],
              );
    if (cameraMode.isEmpty) {
      cameraMode = (!kReleaseMode &&
              (Platform.isMacOS || Platform.isWindows || Platform.isLinux))
          ? 'mock'
          : 'canon';
    }
    remoteApiBaseUrl = Platform.environment['PTB_BASE_URL'] ??
        _readConfigValue(
          remoteApiConfig,
          const ["baseUrl", "base_url"],
        );
    if (remoteApiBaseUrl.isEmpty) {
      remoteApiBaseUrl = Platform.environment['APP_BASE_URL'] ??
          _readConfigValue(
            serverConfig,
            const ["baseUrl", "base_url"],
          );
    }
    if (remoteApiBaseUrl.isEmpty &&
        !kReleaseMode &&
        (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
      remoteApiBaseUrl = 'http://127.0.0.1:8080';
    }
    if (remoteApiBaseUrl.isNotEmpty) {
      networkProvider.setBaseUrl(remoteApiBaseUrl);
    }
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  Future<void> _loadRemoteData() async {
    final remoteData = await restClient.initData();
    appData = remoteData;
    final List<FramesInfo> tempData = [];
    for (FramesInfo frameInfo in frameInfos) {
      var tempFrameFileName = _lastPathSegment(frameInfo.frameUrlTempDis ?? "");
      var mainFrameFileName = _lastPathSegment(frameInfo.frameUrl ?? "");
      if (tempFrameFileName.isEmpty || mainFrameFileName.isEmpty) continue;

      var tempFramePath = await remoteImageUtils.downloadAndSaveFile(
          frameInfo.frameUrlTempDis!, tempFrameFileName);
      var mainFramePath = await remoteImageUtils.downloadAndSaveFile(
          frameInfo.frameUrl!, mainFrameFileName);

      frameInfo = frameInfo.copyWith(
          frameUrlTempDis: tempFramePath, frameUrl: mainFramePath);
      List<BackgroundInfo> tempBackgroundInfo = [];
      for (BackgroundInfo backgroundCategory
          in (frameInfo.backgroundInfo ?? [])) {
        var backgroundCateFileName =
            _lastPathSegment(backgroundCategory.bgCateIcon ?? "");
        if (backgroundCateFileName.isNotEmpty &&
            (backgroundCategory.bgCateIcon ?? "").isNotEmpty) {
          var backgroundCateFilePath =
              await remoteImageUtils.downloadAndSaveFile(
            backgroundCategory.bgCateIcon!,
            backgroundCateFileName,
          );
          backgroundCategory = backgroundCategory.copyWith(
            bgCateIcon: backgroundCateFilePath,
          );
        }
        List<Background> tempBackground = [];
        for (Background background in (backgroundCategory.background ?? [])) {
          var backgroundFileName = _lastPathSegment(background.bgUrl ?? "");
          if (backgroundFileName.isEmpty) continue;
          var backgroundFilePath = await remoteImageUtils.downloadAndSaveFile(
              background.bgUrl!, backgroundFileName);
          if ((background.maskJson ?? []).isNotEmpty) {
            backgroundFilePath =
                await backgroundMaskUtils.resolveMaskedBackgroundPath(
                    backgroundFilePath, background.getMaskAreas());
          }
          background = background.copyWith(bgUrl: backgroundFilePath);
          tempBackground.add(background);
        }
        backgroundCategory =
            backgroundCategory.copyWith(background: tempBackground);
        tempBackgroundInfo.add(backgroundCategory);
      }
      tempData.add(frameInfo.copyWith(backgroundInfo: tempBackgroundInfo));
    }
    appData = appData.copyWith(framesInfo: tempData);
  }

  Future<void> reloadRemoteData() async {
    final previousData = appData;
    final previousSelectedFrameCode = imageParam.selectedFrame.frameCd;
    final previousSelectedBackgroundCode = imageParam.selectedBackground.bgCd;
    try {
      await _loadRemoteData();
      _syncSelectedFrameFromRemote(previousSelectedFrameCode);
      _syncSelectedBackgroundFromRemote(previousSelectedBackgroundCode);
      notifyListeners();
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      appData = previousData;
      notifyListeners();
      rethrow;
    }
  }

  void _syncSelectedFrameFromRemote(String? frameCd) {
    if (frameCd == null || frameCd.trim().isEmpty) {
      return;
    }
    final refreshedFrame = findByCode(frameCd);
    if (refreshedFrame != null) {
      imageParam = imageParam.copyWith(selectedFrame: refreshedFrame);
    }
  }

  void _syncSelectedBackgroundFromRemote(String? bgCd) {
    if (bgCd == null || bgCd.trim().isEmpty) {
      return;
    }
    final currentFrame = imageParam.selectedFrame;
    final backgroundInfo = currentFrame.backgroundInfo ?? [];
    for (final category in backgroundInfo) {
      for (final background in category.background ?? []) {
        if (background.bgCd == bgCd) {
          imageParam = imageParam.copyWith(selectedBackground: background);
          return;
        }
      }
    }
  }

  void updateImages(List<String> images) {
    imageParam = imageParam.copyWith(images: images);
  }

  void updateVideos(List<String> videos) {
    imageParam = imageParam.copyWith(videos: videos);
  }

  void updateFlip(bool isFlipped) {
    imageParam = imageParam.copyWith(isFlipped: isFlipped);
  }

  void updateFrame(FramesInfo frameInfo) {
    final canonicalFrame = _resolveCanonicalFrame(frameInfo);
    imageParam = imageParam.copyWith(
      selectedFrame: canonicalFrame,
    );
  }

  void updateBackground(Background background) {
    imageParam = imageParam.copyWith(
      selectedBackground: background,
    );
  }

  void updateFilter(ColorFilterGenerator filter) {
    imageParam = imageParam.copyWith(
      colorFilter: filter,
    );
  }

  void updateEffect(Effect effect) {
    imageParam = imageParam.copyWith(
      effect: effect,
    );
  }

  void updatePansAndScales(List<MatrixParam> matrix) {
    imageParam = imageParam.copyWith(
      pansAndScales: matrix,
    );
  }

  void updatePrintQuantity(int quantity) {
    imageParam = imageParam.copyWith(
      printQuantity: quantity,
    );
  }

  void updateCoupon(String coupon) {
    imageParam = imageParam.copyWith(
      couponCode: coupon,
    );
  }

  void updateLocale(Locale locale) {
    if (locate.languageCode == locale.languageCode) {
      return;
    }
    locate = locale;
    notifyListeners();
  }

  void updateLanguageCode(String languageCode) {
    final normalized = languageCode.trim().toLowerCase();
    if (normalized == 'en') {
      updateLocale(const Locale('en'));
      return;
    }
    updateLocale(const Locale('vi'));
  }

  void _applyDefaultLocale() {
    updateLanguageCode(themeConfig.defaultLanguage);
  }

  void resetFlow() {
    imageParam = const ImageParam();
    currentScreen = 'STANDBY';
    notifyListeners();
  }

  bool get isMockCameraMode => cameraMode.toLowerCase() == 'mock';

  bool get isMockPaymentMode =>
      (Platform.environment['PTB_PAYMENT_MODE'] ?? '').trim().toLowerCase() ==
          'mock' ||
      (!kReleaseMode &&
          (Platform.isMacOS || Platform.isWindows || Platform.isLinux) &&
          !_hasLocalRuntimeConfig);

  void setCurrentScreen(String screenCd) {
    currentScreen = screenCd;
  }

  Future<void> sendHeartbeat() async {
    if (kioskCode.isEmpty) {
      return;
    }
    try {
      await restClient.sendHeartbeat(
        kioskCode,
        {
          "appVersion": appVersion,
          "currentScreen": currentScreen,
          "currentSessionId": imageParam.session,
          "metadata": {
            "printQuantity": imageParam.printQuantity,
            "selectedFrame": imageParam.selectedFrame.frameCd,
            "couponCode": imageParam.couponCode,
          },
        },
      );
    } catch (e, stackTrace) {
      logE(e, stackTrace: stackTrace);
    }
  }

  Future<void> sendEvent({
    required String eventType,
    String? saleNo,
    String? errorMessage,
    Map<String, Object?>? payload,
  }) async {
    if (kioskCode.isEmpty) {
      return;
    }
    try {
      await restClient.sendEvent(
        kioskCode,
        {
          "eventType": eventType,
          "saleNo": saleNo ?? imageParam.session,
          "payload": payload ?? const {},
          "errorMessage": errorMessage,
          "occurredAt": DateTime.now().toUtc().toIso8601String(),
        },
      );
    } catch (e, stackTrace) {
      logE(e, stackTrace: stackTrace);
    }
  }

  String getGuideText() {
    final value = getAppConfigValue("GUIDE_TEXT");
    if (value.isEmpty) {
      return "Tự động chụp khi vượt quá số giây";
    }
    return value;
  }

  String getAppConfigValue(String configKey) {
    final items = appData.configInfo?.appConfig ?? [];
    AppConfigItem? config;
    for (final item in items) {
      if ((item.configKey ?? "").toUpperCase() == configKey.toUpperCase()) {
        config = item;
        break;
      }
    }
    final value = config?.value;
    if (value == null || value.isEmpty) {
      return "";
    }
    const preferredFields = [
      "guideText",
      "text",
      "message",
      "content",
      "value"
    ];
    for (final field in preferredFields) {
      final dynamic fieldValue = value[field];
      if (fieldValue != null && fieldValue.toString().trim().isNotEmpty) {
        return fieldValue.toString();
      }
    }
    final firstEntry = value.values.isNotEmpty ? value.values.first : null;
    return firstEntry?.toString() ?? "";
  }

  void reset() {
    imageParam = ImageParam(
      session: Uuid().v4(),
    );
    async.unawaited(sendEvent(
      eventType: "SESSION_RESET",
      saleNo: imageParam.session,
      payload: {
        "session": imageParam.session,
      },
    ));
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = async.Timer.periodic(const Duration(seconds: 30), (_) {
      async.unawaited(sendHeartbeat());
    });
    async.unawaited(sendHeartbeat());
  }

  Map<String, dynamic> _readConfigSection(String key) {
    final section = appConfig[key];
    if (section is Map<String, dynamic>) {
      return section;
    }
    return <String, dynamic>{};
  }

  String _readConfigValue(Map<String, dynamic> section, List<String> keys) {
    for (final key in keys) {
      final value = section[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    return "";
  }

  String _lastPathSegment(String value) {
    if (value.trim().isEmpty) {
      return "";
    }
    return value.split("/").last;
  }

  FramesInfo _resolveCanonicalFrame(FramesInfo frameInfo) {
    final frameCd = frameInfo.frameCd?.trim();
    if (frameCd != null && frameCd.isNotEmpty) {
      final matchedByCode = frameInfos.firstWhere(
        (item) =>
            (item.frameCd ?? '').trim().toLowerCase() == frameCd.toLowerCase(),
        orElse: () => frameInfo,
      );
      if (matchedByCode.frameCd != null) {
        return matchedByCode;
      }
    }

    final targetNumOfPhotos = frameInfo.frameSetting?.numOfPhotos ?? 0;
    final targetVertical = frameInfo.isVertical();
    final matchedByLayout = frameInfos.firstWhere(
      (item) =>
          (item.frameSetting?.numOfPhotos ?? 0) == targetNumOfPhotos &&
          item.isVertical() == targetVertical,
      orElse: () => frameInfo,
    );
    return matchedByLayout;
  }
}
