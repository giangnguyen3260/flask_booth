import 'dart:async' as async;
import 'dart:convert';
import 'dart:io';

import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
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
import 'package:project_l/remote/models/qr_detail.dart';
import 'package:project_l/remote/service/app_service.dart';
import 'package:uuid/uuid.dart';

@singleton
class AppState extends ChangeNotifier with LogMixin {
  static const String _fallbackAppDataAsset =
      'assets/dummy/local_main_info.json';
  static const int _maxAdminDataBackups = 10;
  static const String _adminDataBackupFolder = 'admin_data_backups';
  static const String _uploadQueueFolder = 'upload_queue';
  static const Duration adminUpdateCheckInterval = Duration(minutes: 5);

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
  String activeAdminDataVersion = '';
  String latestAdminDataVersion = '';
  bool hasPendingAdminUpdate = false;
  bool isCheckingAdminUpdate = false;
  DateTime? lastAdminUpdateCheckAt;

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
    } else {
      remoteApiBaseUrl = networkProvider.appDio.options.baseUrl;
    }
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  Future<void> _loadRemoteData() async {
    AppData remoteData;
    if (_shouldUseFallbackAppData) {
      logD('Loading fallback app data from $_fallbackAppDataAsset');
      remoteData = await _loadFallbackAppData();
      await _applyPreparedAppData(await _prepareAppData(remoteData));
      return;
    }
    try {
      remoteData = await restClient.initData();
      final preparedData = await _prepareAppData(remoteData);
      await _saveAdminDataBackup(preparedData);
      await _applyPreparedAppData(preparedData);
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      final backupData = await _loadLatestAdminDataBackup();
      if (backupData != null) {
        logD('Loading latest admin data backup');
        await _applyPreparedAppData(backupData);
        return;
      }
      logD('Loading fallback app data from $_fallbackAppDataAsset');
      remoteData = await _loadFallbackAppData();
      await _applyPreparedAppData(await _prepareAppData(remoteData));
    }
  }

  Future<AppData> _loadFallbackAppData() async {
    final jsonText = await rootBundle.loadString(_fallbackAppDataAsset);
    final jsonMap = jsonDecode(jsonText) as Map<String, Object?>;
    return AppData.fromJson(jsonMap);
  }

  Future<AppData> _prepareAppData(AppData remoteData) async {
    final List<FramesInfo> tempData = [];
    for (FramesInfo frameInfo in remoteData.framesInfo ?? []) {
      var tempFramePath = await _resolveImagePath(frameInfo.frameUrlTempDis);
      var mainFramePath = await _resolveImagePath(frameInfo.frameUrl);
      if (tempFramePath.isEmpty && mainFramePath.isEmpty) continue;

      frameInfo = frameInfo.copyWith(
        frameUrlTempDis: tempFramePath.isNotEmpty ? tempFramePath : null,
        frameUrl: mainFramePath.isNotEmpty ? mainFramePath : tempFramePath,
      );
      List<BackgroundInfo> tempBackgroundInfo = [];
      for (BackgroundInfo backgroundCategory
          in (frameInfo.backgroundInfo ?? [])) {
        var backgroundCateFilePath =
            await _resolveImagePath(backgroundCategory.bgCateIcon);
        if (backgroundCateFilePath.isNotEmpty) {
          backgroundCategory = backgroundCategory.copyWith(
            bgCateIcon: backgroundCateFilePath,
          );
        }
        List<Background> tempBackground = [];
        for (Background background in (backgroundCategory.background ?? [])) {
          var backgroundFilePath = await _resolveImagePath(background.bgUrl);
          if (backgroundFilePath.isEmpty) continue;
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
    if (tempData.isEmpty && (remoteData.framesInfo ?? []).isNotEmpty) {
      throw StateError('No usable frame assets were resolved from admin data');
    }
    return remoteData.copyWith(framesInfo: tempData);
  }

  Future<void> _applyPreparedAppData(AppData preparedData) async {
    appData = preparedData;
    activeAdminDataVersion = _adminDataVersion(preparedData);
    latestAdminDataVersion = latestAdminDataVersion.isEmpty
        ? activeAdminDataVersion
        : latestAdminDataVersion;
    hasPendingAdminUpdate =
        _isDifferentVersion(latestAdminDataVersion, activeAdminDataVersion);
  }

  bool get _shouldUseFallbackAppData {
    final override =
        (Platform.environment['PTB_USE_LOCAL_MAIN_INFO'] ?? '').toLowerCase();
    if (override == 'false' || override == '0') {
      return false;
    }
    if (override == 'true' || override == '1') {
      return true;
    }
    return !kReleaseMode && !_hasLocalRuntimeConfig;
  }

  Future<String> _resolveImagePath(String? source) async {
    final value = source?.trim() ?? "";
    if (value.isEmpty) {
      return "";
    }
    if (value.startsWith('assets/')) {
      return _copyAssetToDocument(value);
    }
    if (value.startsWith('file://')) {
      return Uri.parse(value).toFilePath(windows: Platform.isWindows);
    }
    if (File(value).existsSync()) {
      return value;
    }
    final remoteUrl = _normalizeRemoteAssetUrl(value);
    final fileName = _lastPathSegment(remoteUrl);
    if (fileName.isEmpty) {
      return "";
    }
    return remoteImageUtils.downloadAndSaveFile(remoteUrl, fileName);
  }

  String _normalizeRemoteAssetUrl(String value) {
    final assetUri = Uri.tryParse(value);
    final baseUri = Uri.tryParse(remoteApiBaseUrl);
    if (assetUri == null ||
        baseUri == null ||
        !assetUri.hasScheme ||
        assetUri.host.isEmpty) {
      return value;
    }
    final assetHost = assetUri.host.toLowerCase();
    if (assetHost != 'localhost' && assetHost != '127.0.0.1') {
      return value;
    }
    if (baseUri.host.isEmpty ||
        baseUri.host == 'localhost' ||
        baseUri.host == '127.0.0.1') {
      return value;
    }
    return assetUri
        .replace(
          scheme: baseUri.scheme,
          host: baseUri.host,
          port: baseUri.hasPort ? baseUri.port : null,
        )
        .toString();
  }

  Future<String> _copyAssetToDocument(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final directory = await getApplicationDocumentsDirectory();
    final targetDirectory = Directory(
      path.join(directory.path, 'project_l', 'fallback_assets'),
    );
    if (!targetDirectory.existsSync()) {
      targetDirectory.createSync(recursive: true);
    }
    final file =
        File(path.join(targetDirectory.path, _lastPathSegment(assetPath)));
    await file.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      flush: true,
    );
    return file.path;
  }

  Future<void> reloadRemoteData() async {
    final previousData = appData;
    final previousActiveVersion = activeAdminDataVersion;
    final previousLatestVersion = latestAdminDataVersion;
    final previousPendingUpdate = hasPendingAdminUpdate;
    final previousSelectedFrameCode = imageParam.selectedFrame.frameCd;
    final previousSelectedBackgroundCode = imageParam.selectedBackground.bgCd;
    try {
      final remoteData = await restClient.initData();
      final preparedData = await _prepareAppData(remoteData);
      await _saveAdminDataBackup(preparedData);
      await _applyPreparedAppData(preparedData);
      latestAdminDataVersion = activeAdminDataVersion;
      hasPendingAdminUpdate = false;
      _syncSelectedFrameFromRemote(previousSelectedFrameCode);
      _syncSelectedBackgroundFromRemote(previousSelectedBackgroundCode);
      notifyListeners();
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      appData = previousData;
      activeAdminDataVersion = previousActiveVersion;
      latestAdminDataVersion = previousLatestVersion;
      hasPendingAdminUpdate = previousPendingUpdate;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> checkForAdminDataUpdate({bool force = false}) async {
    if (_shouldUseFallbackAppData || isCheckingAdminUpdate) {
      return;
    }
    final now = DateTime.now();
    if (!force &&
        lastAdminUpdateCheckAt != null &&
        now.difference(lastAdminUpdateCheckAt!) < adminUpdateCheckInterval) {
      return;
    }
    isCheckingAdminUpdate = true;
    notifyListeners();
    try {
      final response =
          await networkProvider.appDio.get('/pub/main-info/version');
      final data = response.data;
      final version = _readVersionValue(data);
      if (version.isNotEmpty) {
        latestAdminDataVersion = version;
        hasPendingAdminUpdate =
            _isDifferentVersion(latestAdminDataVersion, activeAdminDataVersion);
      }
      lastAdminUpdateCheckAt = now;
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
    } finally {
      isCheckingAdminUpdate = false;
      notifyListeners();
    }
  }

  Future<QRDetail?> submitOrQueueResult({
    required String saleNo,
    required String frameId,
    required String imagePath,
    required List<String> videoPaths,
    required double amount,
    required int printQuantity,
    String? cuKey,
  }) async {
    final durableImagePath = await _copyUploadFile(
      saleNo: saleNo,
      sourcePath: imagePath,
    );
    final durableVideoPaths = <String>[];
    for (final videoPath in videoPaths) {
      durableVideoPaths.add(
        await _copyUploadFile(saleNo: saleNo, sourcePath: videoPath),
      );
    }
    final job = <String, Object?>{
      'saleNo': saleNo,
      'frameId': frameId,
      'imagePath': durableImagePath,
      'videoPaths': durableVideoPaths,
      'cuKey': cuKey,
      'amount': amount,
      'printQuantity': printQuantity,
      'status': 'pending_upload',
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      return await _submitUploadJob(job);
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      await _upsertUploadJob(job);
      return null;
    }
  }

  Future<void> retryPendingUploads() async {
    final jobs = await _readUploadJobs();
    var changed = false;
    for (final job in jobs) {
      final status = (job['status'] ?? '').toString();
      if (status != 'pending_upload' && status != 'failed_retryable') {
        continue;
      }
      job['status'] = 'uploading';
      job['updatedAt'] = DateTime.now().toUtc().toIso8601String();
      changed = true;
      await _writeUploadJobs(jobs);
      try {
        final response = await _submitUploadJob(job);
        job['status'] = 'uploaded';
        job['qrUrl'] = response.qrUrl;
      } catch (error, stackTrace) {
        logE(error, stackTrace: stackTrace);
        job['status'] = 'failed_retryable';
      }
      job['updatedAt'] = DateTime.now().toUtc().toIso8601String();
      await _writeUploadJobs(jobs);
    }
    if (changed) {
      logD('Upload queue retry completed');
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
      _shouldUseFallbackAppData ||
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

  String _adminDataVersion(AppData data) {
    final version = data.configInfo?.configVersion;
    return version == null ? '' : version.toString();
  }

  String _readVersionValue(Object? data) {
    if (data is Map) {
      final version = data['version'] ?? data['configVersion'];
      return version?.toString().trim() ?? '';
    }
    return '';
  }

  bool _isDifferentVersion(String latestVersion, String activeVersion) {
    if (latestVersion.trim().isEmpty || activeVersion.trim().isEmpty) {
      return false;
    }
    return latestVersion.trim() != activeVersion.trim();
  }

  Future<Directory> _appDocumentSubDirectory(String folder) async {
    final directory = await getApplicationDocumentsDirectory();
    final targetDirectory = Directory(
      path.join(directory.path, 'project_l', folder),
    );
    if (!targetDirectory.existsSync()) {
      await targetDirectory.create(recursive: true);
    }
    return targetDirectory;
  }

  String _sanitizePathSegment(String value) {
    final sanitized = value.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    return sanitized.isEmpty ? 'unknown' : sanitized;
  }

  Future<void> _saveAdminDataBackup(AppData preparedData) async {
    final backupDirectory =
        await _appDocumentSubDirectory(_adminDataBackupFolder);
    final version = _sanitizePathSegment(_adminDataVersion(preparedData));
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final file = File(
      path.join(backupDirectory.path, '${timestamp}_$version.json'),
    );
    await file.writeAsString(jsonEncode(preparedData.toJson()), flush: true);
    await _pruneAdminDataBackups(backupDirectory);
  }

  Future<void> _pruneAdminDataBackups(Directory backupDirectory) async {
    final files = backupDirectory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.json'))
        .toList()
      ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    for (var index = _maxAdminDataBackups; index < files.length; index++) {
      try {
        await files[index].delete();
      } catch (error, stackTrace) {
        logE(error, stackTrace: stackTrace);
      }
    }
  }

  Future<AppData?> _loadLatestAdminDataBackup() async {
    final backupDirectory =
        await _appDocumentSubDirectory(_adminDataBackupFolder);
    final files = backupDirectory
        .listSync()
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.json'))
        .toList()
      ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
    for (final file in files) {
      try {
        final jsonMap = jsonDecode(await file.readAsString());
        if (jsonMap is Map<String, dynamic>) {
          return AppData.fromJson(jsonMap);
        }
      } catch (error, stackTrace) {
        logE(error, stackTrace: stackTrace);
      }
    }
    return null;
  }

  Future<String> _copyUploadFile({
    required String saleNo,
    required String sourcePath,
  }) async {
    final source = File(sourcePath);
    if (!source.existsSync()) {
      throw StateError('Upload source file does not exist: $sourcePath');
    }
    final queueDirectory = await _appDocumentSubDirectory(_uploadQueueFolder);
    final sessionDirectory = Directory(
      path.join(queueDirectory.path, 'files', _sanitizePathSegment(saleNo)),
    );
    if (!sessionDirectory.existsSync()) {
      await sessionDirectory.create(recursive: true);
    }
    final target =
        File(path.join(sessionDirectory.path, path.basename(sourcePath)));
    if (target.path == source.path) {
      return target.path;
    }
    await source.copy(target.path);
    return target.path;
  }

  Future<File> _uploadJobsFile() async {
    final queueDirectory = await _appDocumentSubDirectory(_uploadQueueFolder);
    return File(path.join(queueDirectory.path, 'jobs.json'));
  }

  Future<List<Map<String, Object?>>> _readUploadJobs() async {
    final file = await _uploadJobsFile();
    if (!file.existsSync()) {
      return [];
    }
    try {
      final decoded = jsonDecode(await file.readAsString());
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((item) => Map<String, Object?>.from(item))
            .toList();
      }
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
    }
    return [];
  }

  Future<void> _writeUploadJobs(List<Map<String, Object?>> jobs) async {
    final file = await _uploadJobsFile();
    await file.writeAsString(jsonEncode(jobs), flush: true);
  }

  Future<void> _upsertUploadJob(Map<String, Object?> job) async {
    final jobs = await _readUploadJobs();
    final saleNo = (job['saleNo'] ?? '').toString();
    final existingIndex = jobs.indexWhere(
      (item) => (item['saleNo'] ?? '').toString() == saleNo,
    );
    if (existingIndex >= 0) {
      jobs[existingIndex] = job;
    } else {
      jobs.add(job);
    }
    await _writeUploadJobs(jobs);
  }

  Future<QRDetail> _submitUploadJob(Map<String, Object?> job) async {
    final imagePath = (job['imagePath'] ?? '').toString();
    final rawVideoPaths = job['videoPaths'];
    final videoPaths = rawVideoPaths is List
        ? rawVideoPaths.map((item) => item.toString()).toList()
        : <String>[];
    final videoFiles = <MultipartFile>[];
    for (final videoPath in videoPaths) {
      if (File(videoPath).existsSync()) {
        videoFiles.add(await MultipartFile.fromFile(videoPath));
      }
    }
    return restClient.submit(
      saleNo: (job['saleNo'] ?? '').toString(),
      cuKey: job['cuKey']?.toString(),
      frameId: (job['frameId'] ?? '').toString(),
      img: [await MultipartFile.fromFile(imagePath)],
      video: videoFiles,
      amount: (job['amount'] as num?)?.toDouble() ?? 0,
      printQuantity: (job['printQuantity'] as num?)?.toInt() ?? 0,
    );
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
