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
import 'package:project_l/common/extensions/size_extension.dart';
import 'package:project_l/common/util/background_mask_utils.dart';
import 'package:project_l/common/util/printer_utils.dart';
import 'package:project_l/common/util/remote_image_utils.dart';
import 'package:project_l/remote/models/kiosk_command.dart';
import 'package:project_l/config/injetable_config.dart';
import 'package:project_l/common/models/app_theme_config.dart';
import 'package:project_l/remote/models/app_data.dart';
import 'package:project_l/remote/models/qr_detail.dart';
import 'package:project_l/remote/service/app_service.dart';
import 'package:uuid/uuid.dart';

@singleton
class AppState extends ChangeNotifier with LogMixin {
  static const String _fallbackAppDataAsset =
      'assets/dummy/photobooth_info.json';
  static const int _maxAdminDataBackups = 10;
  static const String _adminDataBackupFolder = 'admin_data_backups';
  static const String _adminDataCurrentFile = 'admin_data_current.json';
  static const String _uploadQueueFolder = 'upload_queue';
  static const String _fallbackBackgroundAsset =
      'assets/branding/screen_1_reference.png';
  static const String _fallbackBackgroundIconAsset =
      'assets/branding/flashy_booth_logo.jpg';
  static const Duration adminUpdateCheckInterval = Duration(minutes: 5);
  static const Duration _startupRemoteDataTimeout = Duration(seconds: 12);
  static const Duration _adminDataReloadTimeout = Duration(seconds: 20);
  static const Duration _adminVersionCheckTimeout = Duration(seconds: 8);
  static const int _assetResolveBatchSize = 12;

  Locale locate = const Locale("vi");
  final RemoteImageUtils remoteImageUtils;
  final BackgroundMaskUtils backgroundMaskUtils = BackgroundMaskUtils();
  ImageParam imageParam = ImageParam();

  final RestClient restClient;
  final NetworkProvider networkProvider;
  AppData appData = const AppData();
  Map<String, dynamic> appConfig = {};
  String kioskCode = '';
  String kioskSecret = '';
  bool _printerConnected = true;
  String? _printerErrorCode;
  String _printerCode = '';
  String _printerName = '';
  String remoteApiBaseUrl = '';
  String appVersion = '';
  String currentScreen = 'STANDBY';
  String cameraMode = 'canon';
  bool _hasLocalRuntimeConfig = false;
  bool _hasConfiguredRemoteApi = false;
  final CameraPowerUtil cameraPowerUtil = getIt.get();
  final CameraUtils cameraUtils = getIt.get();
  async.Timer? _heartbeatTimer;
  bool _isExecutingPrintCommand = false;
  bool _isRetryingPendingUploads = false;
  String activeAdminDataVersion = '';
  String latestAdminDataVersion = '';
  bool hasPendingAdminUpdate = false;
  bool isCheckingAdminUpdate = false;
  DateTime? lastAdminUpdateCheckAt;

  final PrinterUtils _printerUtils;

  AppState({
    required this.restClient,
    required this.remoteImageUtils,
    required this.networkProvider,
    required PrinterUtils printerUtils,
  }) : _printerUtils = printerUtils;

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
      async.unawaited(sendPrinterStatusReport());
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

    final cameraPowerPort = _readConfigValue(cameraConfig, const ["port"]);
    if (!isMockCameraMode && cameraPowerPort.isNotEmpty) {
      cameraPowerUtil.cameraPowerConfig = cameraConfig;
      cameraPowerUtil.connect();
    }

    var billAcceptorUtils = getIt.get<BillAcceptorUtils>();
    if (!isMockCameraMode && billAcceptorConfig.isNotEmpty) {
      billAcceptorUtils.billAcceptorConfig = billAcceptorConfig;
      billAcceptorUtils.connect();
    } else if (!isMockCameraMode) {
      logE("Bill acceptor config is empty");
    }

    kioskCode =
        _readConfigValue(kioskConfig, const ["kioskCode", "kiosk_code"]);
    kioskSecret = _readConfigValue(
      kioskConfig,
      const ["kioskSecret", "kiosk_secret", "apiSecret", "api_secret"],
    );
    if (kioskSecret.isEmpty) {
      kioskSecret = _readConfigValue(
        remoteApiConfig,
        const ["kioskSecret", "kiosk_secret", "apiSecret", "api_secret"],
      );
    }
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
    final ptbBaseUrl = Platform.environment['PTB_BASE_URL']?.trim() ?? '';
    final remoteApiConfigBaseUrl = _readConfigValue(
      remoteApiConfig,
      const ["baseUrl", "base_url"],
    );
    final appBaseUrl = Platform.environment['APP_BASE_URL']?.trim() ?? '';
    final serverConfigBaseUrl = _readConfigValue(
      serverConfig,
      const ["baseUrl", "base_url"],
    );
    remoteApiBaseUrl =
        ptbBaseUrl.isNotEmpty ? ptbBaseUrl : remoteApiConfigBaseUrl;
    if (remoteApiBaseUrl.isEmpty) {
      remoteApiBaseUrl =
          appBaseUrl.isNotEmpty ? appBaseUrl : serverConfigBaseUrl;
    }
    if (remoteApiBaseUrl.isEmpty) {
      remoteApiBaseUrl = networkProvider.appDio.options.baseUrl;
    }
    _hasConfiguredRemoteApi = remoteApiBaseUrl.isNotEmpty;
    if (remoteApiBaseUrl.isNotEmpty) {
      networkProvider.setBaseUrl(remoteApiBaseUrl);
    }
    final printerConfig = _readConfigSection("printer");
    _printerCode = _readConfigValue(
      printerConfig,
      const ["printerCode", "printer_code"],
    );
    _printerName = _readConfigValue(
      printerConfig,
      const ["name", "printerName", "printer_name"],
    );
    if (_printerCode.isEmpty && kioskCode.isNotEmpty) {
      _printerCode = '$kioskCode-P1';
    }
    if (_printerName.isEmpty && kioskCode.isNotEmpty) {
      _printerName = kioskCode;
    }
    if (kioskCode.isNotEmpty && kioskSecret.isNotEmpty) {
      networkProvider.setKioskCredentials(kioskCode, kioskSecret);
    }
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
  }

  Future<void> _loadRemoteData() async {
    final stopwatch = Stopwatch()..start();
    AppData remoteData;
    if (_shouldUseFallbackAppData) {
      logD('Loading fallback app data from $_fallbackAppDataAsset');
      remoteData = await _loadFallbackAppData();
      await _applyPreparedAppData(await _prepareAppData(remoteData));
      logD(
          'Startup app data loaded from fallback in ${stopwatch.elapsedMilliseconds}ms');
      return;
    }

    final localData = await _loadLocalAdminData();
    if (localData != null) {
      await _applyPreparedAppData(localData);
      logD(
          'Startup app data loaded from local cache in ${stopwatch.elapsedMilliseconds}ms');
      return;
    }

    try {
      remoteData = await _fetchRemoteAppData(_startupRemoteDataTimeout);
      final prepareStopwatch = Stopwatch()..start();
      final preparedData = await _prepareAppData(remoteData);
      logD(
          'Startup app data prepared in ${prepareStopwatch.elapsedMilliseconds}ms');
      await _saveAdminDataLocal(preparedData);
      await _applyPreparedAppData(preparedData);
      logD(
          'Startup app data loaded from remote in ${stopwatch.elapsedMilliseconds}ms');
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      logD('Loading fallback app data from $_fallbackAppDataAsset');
      remoteData = await _loadFallbackAppData();
      await _applyPreparedAppData(await _prepareAppData(remoteData));
      logD(
          'Startup app data loaded from fallback after remote error in ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  Future<AppData> _loadFallbackAppData() async {
    final jsonText = await rootBundle.loadString(_fallbackAppDataAsset);
    final jsonMap = jsonDecode(jsonText) as Map<String, Object?>;
    return AppData.fromJson(jsonMap);
  }

  Future<AppData> _fetchRemoteAppData(Duration timeout) async {
    final apiStopwatch = Stopwatch()..start();
    final remoteData = await restClient.initData().timeout(timeout);
    logD(
      '/pub/main-info completed in ${apiStopwatch.elapsedMilliseconds}ms '
      '(timeout=${timeout.inSeconds}s)',
    );
    return remoteData;
  }

  Future<AppData> _prepareAppData(AppData remoteData) async {
    final frameInfos = remoteData.framesInfo ?? [];
    final backgroundCount = frameInfos.fold<int>(
      0,
      (count, frame) =>
          count +
          (frame.backgroundInfo ?? []).fold<int>(
            0,
            (categoryCount, category) =>
                categoryCount + (category.background ?? []).length,
          ),
    );
    logD(
      'Preparing app data assets: frames=${frameInfos.length} '
      'backgrounds=$backgroundCount batch=$_assetResolveBatchSize',
    );

    final preparedFrames = await _mapInBatches<FramesInfo, FramesInfo?>(
      frameInfos,
      _assetResolveBatchSize,
      _prepareFrameInfo,
    );
    final tempData = preparedFrames.whereType<FramesInfo>().toList();
    if (tempData.isEmpty && (remoteData.framesInfo ?? []).isNotEmpty) {
      throw StateError('No usable frame assets were resolved from admin data');
    }
    logD('Prepared app data assets: usableFrames=${tempData.length}');
    return remoteData.copyWith(framesInfo: tempData);
  }

  Future<FramesInfo?> _prepareFrameInfo(FramesInfo frameInfo) async {
    final framePaths = await Future.wait<String?>([
      _resolveOptionalImagePath(frameInfo.frameUrlTempDis),
      _resolveOptionalImagePath(frameInfo.frameUrl),
    ]);
    final tempFramePath = framePaths[0];
    final mainFramePath = framePaths[1];

    final preparedFrame = frameInfo.copyWith(
      frameUrlTempDis: tempFramePath,
      frameUrl: mainFramePath ?? tempFramePath,
    );
    final tempBackgroundInfo =
        await _mapInBatches<BackgroundInfo, BackgroundInfo>(
      frameInfo.backgroundInfo ?? [],
      _assetResolveBatchSize,
      _prepareBackgroundCategory,
    );

    if (!tempBackgroundInfo.any((cat) => (cat.background ?? []).isNotEmpty)) {
      tempBackgroundInfo.add(await _fallbackBackgroundInfo(preparedFrame));
    }
    // Include frame if it has at least one usable background, even without a frame overlay image.
    final hasUsableBackgrounds =
        tempBackgroundInfo.any((cat) => (cat.background ?? []).isNotEmpty);
    if (hasUsableBackgrounds || preparedFrame.frameUrl != null) {
      return preparedFrame.copyWith(backgroundInfo: tempBackgroundInfo);
    }
    return null;
  }

  Future<BackgroundInfo> _prepareBackgroundCategory(
    BackgroundInfo backgroundCategory,
  ) async {
    final iconFuture = _resolveOptionalImagePath(backgroundCategory.bgCateIcon);
    final preparedBackgrounds = await _mapInBatches<Background, Background?>(
      backgroundCategory.background ?? [],
      _assetResolveBatchSize,
      _prepareBackground,
    );
    final backgroundCateFilePath = await iconFuture;
    return backgroundCategory.copyWith(
      bgCateIcon: backgroundCateFilePath,
      background: preparedBackgrounds.whereType<Background>().toList(),
    );
  }

  Future<Background?> _prepareBackground(Background background) async {
    var backgroundFilePath = await _resolveOptionalImagePath(background.bgUrl);
    if (backgroundFilePath == null) {
      return null;
    }
    if ((background.maskJson ?? []).isNotEmpty) {
      backgroundFilePath =
          await backgroundMaskUtils.resolveMaskedBackgroundPath(
        backgroundFilePath,
        background.getMaskAreas(),
      );
    }
    return background.copyWith(bgUrl: backgroundFilePath);
  }

  Future<List<R>> _mapInBatches<T, R>(
    List<T> items,
    int batchSize,
    Future<R> Function(T item) mapper,
  ) async {
    final results = <R>[];
    for (var index = 0; index < items.length; index += batchSize) {
      final end =
          index + batchSize > items.length ? items.length : index + batchSize;
      results.addAll(await Future.wait(items.sublist(index, end).map(mapper)));
    }
    return results;
  }

  Future<String?> _resolveOptionalImagePath(String? source) async {
    final value = source?.trim() ?? "";
    if (value.isEmpty) {
      return null;
    }
    try {
      final resolved = await _resolveImagePath(value);
      return resolved.isEmpty ? null : resolved;
    } catch (error, stackTrace) {
      if (!_shouldUseFallbackAppData) {
        rethrow;
      }
      logE(error, stackTrace: stackTrace);
      logD('Skip local fallback asset that could not be resolved: $value');
      return null;
    }
  }

  Future<BackgroundInfo> _fallbackBackgroundInfo(FramesInfo frameInfo) async {
    logE(
      'Frame ${frameInfo.frameCd ?? 'unknown'} has no usable admin '
      'background asset; using bundled fallback background.',
    );
    final backgroundPath = await _copyAssetToDocument(_fallbackBackgroundAsset);
    final iconPath = await _copyAssetToDocument(_fallbackBackgroundIconAsset);
    final frameCode = frameInfo.frameCd ?? 'unknown';
    return BackgroundInfo(
      bgCateCd: 'FALLBACK-CATE-$frameCode',
      bgCateNm: 'Default',
      bgCateIcon: iconPath,
      background: [
        Background(
          bgCd: 'FALLBACK-BG-$frameCode',
          bgNm: 'Default',
          bgUrl: backgroundPath,
        ),
      ],
    );
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
    return !kReleaseMode && !_hasLocalRuntimeConfig && !_hasConfiguredRemoteApi;
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
    final basePath = baseUri.path.endsWith('/')
        ? baseUri.path.substring(0, baseUri.path.length - 1)
        : baseUri.path;
    return baseUri
        .replace(
          path: '$basePath${assetUri.path}',
          query: assetUri.hasQuery ? assetUri.query : null,
          fragment: assetUri.hasFragment ? assetUri.fragment : null,
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
      final remoteData = _shouldUseFallbackAppData
          ? await _loadFallbackAppData()
          : await _fetchRemoteAppData(_adminDataReloadTimeout);
      final prepareStopwatch = Stopwatch()..start();
      final preparedData = await _prepareAppData(remoteData);
      logD(
        'Reload app data prepared in '
        '${prepareStopwatch.elapsedMilliseconds}ms',
      );
      await _saveAdminDataLocal(preparedData);
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
      final stopwatch = Stopwatch()..start();
      final result = await restClient
          .fetchMainInfoVersion()
          .timeout(_adminVersionCheckTimeout);
      logD(
        '/pub/main-info/version completed in '
        '${stopwatch.elapsedMilliseconds}ms',
      );
      final version = result.version?.toString().trim() ?? '';
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
    bool uploadNow = true,
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
    final imageBytes = _fileLength(durableImagePath);
    final videoBytes = durableVideoPaths.fold<int>(
      0,
      (total, videoPath) => total + _fileLength(videoPath),
    );
    final totalUploadBytes = imageBytes + videoBytes;
    logD(
      'Upload payload prepared: saleNo=$saleNo imgCount=1 '
      'videoCount=${durableVideoPaths.length} '
      'image=${_formatBytes(imageBytes)} video=${_formatBytes(videoBytes)} '
      'total=${_formatBytes(totalUploadBytes)}',
    );
    final job = <String, Object?>{
      'saleNo': saleNo,
      'frameId': frameId,
      'imagePath': durableImagePath,
      'videoPaths': durableVideoPaths,
      'imageBytes': imageBytes,
      'videoBytes': videoBytes,
      'totalUploadBytes': totalUploadBytes,
      'cuKey': cuKey,
      'amount': amount,
      'printQuantity': printQuantity,
      'status': 'pending_upload',
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    await _upsertUploadJob(job);
    if (!uploadNow) {
      logD(
        'Upload queued for later: saleNo=$saleNo '
        'total=${_formatBytes(totalUploadBytes)}',
      );
      return null;
    }
    try {
      job['status'] = 'uploading';
      job['updatedAt'] = DateTime.now().toUtc().toIso8601String();
      await _upsertUploadJob(job);
      final response = await _submitUploadJob(job).timeout(
        const Duration(seconds: 25),
      );
      job['status'] = 'uploaded';
      job['qrUrl'] = response.qrUrl;
      await _cleanupUploadedQueueFiles(job);
      job['updatedAt'] = DateTime.now().toUtc().toIso8601String();
      await _upsertUploadJob(job);
      return response;
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      job['status'] = _isPermanentUploadError(error)
          ? 'failed_permanent'
          : 'failed_retryable';
      job['error'] = _uploadErrorMessage(error);
      job['updatedAt'] = DateTime.now().toUtc().toIso8601String();
      await _upsertUploadJob(job);
      return null;
    }
  }

  Future<void> retryPendingUploads() async {
    if (_isRetryingPendingUploads) {
      logD('Upload queue retry skipped: already running');
      return;
    }

    _isRetryingPendingUploads = true;
    try {
      final jobs = await _readUploadJobs();
      var changed = false;
      for (final job in jobs) {
        final status = (job['status'] ?? '').toString();
        if (status != 'pending_upload' && status != 'failed_retryable') {
          continue;
        }

        final invalidReason = _validateUploadJobForRetry(job);
        if (invalidReason != null) {
          job['status'] = 'failed_permanent';
          job['error'] = invalidReason;
          job['updatedAt'] = DateTime.now().toUtc().toIso8601String();
          changed = true;
          await _writeUploadJobs(jobs);
          logE(
            'Upload queue job marked permanent failed: '
            'saleNo=${job['saleNo']} reason=$invalidReason',
          );
          continue;
        }

        job['status'] = 'uploading';
        job['updatedAt'] = DateTime.now().toUtc().toIso8601String();
        changed = true;
        await _writeUploadJobs(jobs);
        try {
          final response = await _submitUploadJob(job).timeout(
            const Duration(seconds: 25),
          );
          job['status'] = 'uploaded';
          job['qrUrl'] = response.qrUrl;
          job.remove('error');
          await _cleanupUploadedQueueFiles(job);
        } catch (error, stackTrace) {
          logE(error, stackTrace: stackTrace);
          job['status'] = _isPermanentUploadError(error)
              ? 'failed_permanent'
              : 'failed_retryable';
          job['error'] = _uploadErrorMessage(error);
          job['retryCount'] = ((job['retryCount'] as num?)?.toInt() ?? 0) + 1;
        }
        job['updatedAt'] = DateTime.now().toUtc().toIso8601String();
        await _writeUploadJobs(jobs);
      }
      if (changed) {
        logD('Upload queue retry completed');
      }
    } finally {
      _isRetryingPendingUploads = false;
    }
  }

  String? _validateUploadJobForRetry(Map<String, Object?> job) {
    final saleNo = (job['saleNo'] ?? '').toString().trim();
    if (saleNo.isEmpty) {
      return 'saleNo is blank';
    }

    final frameId = (job['frameId'] ?? '').toString().trim();
    if (frameId.isEmpty) {
      return 'frameId is blank';
    }

    final imagePath = (job['imagePath'] ?? '').toString().trim();
    if (imagePath.isEmpty) {
      return 'imagePath is blank';
    }
    if (!File(imagePath).existsSync()) {
      return 'imagePath does not exist';
    }

    for (final videoPath in _readJobVideoPaths(job)) {
      if (videoPath.trim().isEmpty) {
        continue;
      }
      if (!File(videoPath).existsSync()) {
        return 'videoPath does not exist';
      }
    }

    return null;
  }

  bool _isPermanentUploadError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode ?? 0;
      return statusCode >= 400 &&
          statusCode < 500 &&
          statusCode != 408 &&
          statusCode != 429;
    }
    return false;
  }

  String _uploadErrorMessage(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      final message = responseData ?? error.message;
      return 'HTTP $statusCode: $message';
    }
    return error.toString();
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

  void updatePayableAmount(double amount) {
    imageParam = imageParam.copyWith(
      payableAmount: amount,
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

  void updatePrinterConnectionStatus({
    required bool connected,
    String? errorCode,
  }) {
    _printerConnected = connected;
    _printerErrorCode = connected ? null : errorCode;
  }

  bool get isMockCameraMode => cameraMode.toLowerCase() == 'mock';

  bool get isCanonCameraMode => cameraMode.toLowerCase() == 'canon';

  bool get isWebcamCameraMode => cameraMode.toLowerCase() == 'webcam';

  bool get isMockPaymentMode =>
      (Platform.environment['PTB_PAYMENT_MODE'] ?? '').trim().toLowerCase() ==
          'mock' ||
      _shouldUseFallbackAppData ||
      (!kReleaseMode &&
          (Platform.isMacOS || Platform.isWindows || Platform.isLinux) &&
          !_hasLocalRuntimeConfig);

  String get videoExportMode {
    final value = _readConfigValue(
      _readConfigSection('video'),
      const ['mode', 'videoMode', 'video_mode'],
    ).toLowerCase();
    if (value == 'merge' || value == 'slideshow' || value == 'skip') {
      return value;
    }
    if (value.isNotEmpty) {
      logE('Invalid video export mode "$value", fallback to slideshow');
    }
    return 'slideshow';
  }

  void setCurrentScreen(String screenCd) {
    currentScreen = screenCd;
  }

  Future<void> sendHeartbeat() async {
    if (kioskCode.isEmpty) {
      return;
    }
    try {
      final response = await restClient.sendHeartbeat(
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
      final pending = response.pendingCommands ?? 0;
      if (pending > 0 && currentScreen == 'STANDBY') {
        async.unawaited(checkAndExecutePendingCommands());
      }
    } catch (e, stackTrace) {
      logE(e, stackTrace: stackTrace);
    }
  }

  Future<void> checkAndExecutePendingCommands() async {
    if (kioskCode.isEmpty || currentScreen != 'STANDBY') return;
    if (_isExecutingPrintCommand) return;
    _isExecutingPrintCommand = true;
    try {
      final commands = await restClient.fetchPendingCommands(kioskCode);
      for (final command in commands) {
        if ((command.commandType ?? '').toUpperCase() != 'PRINT') continue;
        await _executePrintCommand(command);
      }
    } catch (e, stackTrace) {
      logE(e, stackTrace: stackTrace);
    } finally {
      _isExecutingPrintCommand = false;
    }
  }

  Future<void> _executePrintCommand(KioskCommand command) async {
    final commandId = command.commandId ?? '';
    final payload = command.payload;
    final imageUrl = payload?.imageUrl ?? '';
    if (commandId.isEmpty || imageUrl.isEmpty) return;

    final previousScreen = currentScreen;
    currentScreen = 'AUTO_PRINTING';
    logD('AutoPrint executing commandId=$commandId imageUrl=$imageUrl');
    try {
      final fileName = 'autoprint_${commandId}_${imageUrl.split('/').last}';
      final localPath =
          await remoteImageUtils.downloadAndSaveFile(imageUrl, fileName);
      if (localPath.isEmpty || !File(localPath).existsSync()) {
        throw StateError('AutoPrint download failed: $imageUrl');
      }

      final isCut = payload?.isCut ?? false;
      final quantity = payload?.printQuantity ?? 1;
      final copies = isCut ? (quantity / 2).ceil() : quantity;

      final orientationStr = (payload?.orientation ?? '').toLowerCase();
      final sizeForOrientation =
          orientationStr == 'landscape' ? const Size(2, 1) : const Size(1, 2);

      await _printerUtils
          .printImage(
            file: File(localPath),
            numCut: copies < 1 ? 1 : copies,
            orientation: sizeForOrientation.orientation,
          )
          .timeout(const Duration(seconds: 45));

      logD('AutoPrint done commandId=$commandId');
      updatePrinterConnectionStatus(connected: true);

      await restClient.acknowledgeCommand(
        kioskCode,
        commandId,
        {'status': 'COMPLETED'},
      );
    } catch (e, stackTrace) {
      logE(e, stackTrace: stackTrace);
      updatePrinterConnectionStatus(
          connected: false, errorCode: 'AUTO_PRINT_FAILED');
      try {
        await restClient.acknowledgeCommand(
          kioskCode,
          commandId,
          {'status': 'FAILED', 'error': e.toString()},
        );
      } catch (ackError) {
        logE('AutoPrint failed to acknowledge FAILED status: $ackError');
      }
    } finally {
      currentScreen = previousScreen;
      async.unawaited(sendPrinterStatusReport());
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

  Future<void> sendPrinterStatusReport() async {
    if (kioskCode.isEmpty || _printerCode.isEmpty) return;
    try {
      final printerHardwareStatus = await _printerUtils.getPrinterStatus();
      final status = _mapPrinterStatus(
        connected: _printerConnected,
        errorCode: _printerErrorCode,
      );
      await restClient.reportPrinterStatus({
        'printers': [
          {
            'printerCode': _printerCode,
            'name': _printerName,
            'status': status,
            'paperPercent': printerHardwareStatus.paperPercent,
            'inkPercent': printerHardwareStatus.inkPercent,
            'printedCount': _printerUtils.printedCount,
            'metadata': <String, Object?>{},
          }
        ],
      });
    } catch (e, stackTrace) {
      logE(e, stackTrace: stackTrace);
    }
  }

  String _mapPrinterStatus({
    required bool connected,
    String? errorCode,
  }) {
    if (!connected) return 'OFFLINE';
    if (errorCode != null && errorCode.isNotEmpty) return 'CRITICAL';
    return 'ONLINE';
  }

  String getGuideText() {
    final value = getAppConfigValue("GUIDE_TEXT");
    if (value.isEmpty) {
      return "Tự động chụp khi vượt quá số giây";
    }
    return value;
  }

  bool get isShotReviewEnabled {
    return getAppConfigBool("ENABLE_SHOT_REVIEW") ||
        getAppConfigBool("SHOT_REVIEW_ENABLED") ||
        getAppConfigBool("ALLOW_RETAKE_AFTER_SHOT");
  }

  bool getAppConfigBool(String configKey) {
    final value = getAppConfigValue(configKey).trim().toLowerCase();
    return value == "true" || value == "1" || value == "y" || value == "yes";
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
      "enabled",
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

  Future<void> _saveAdminDataLocal(AppData preparedData) async {
    await _replaceCurrentAdminData(preparedData);
    await _saveAdminDataBackup(preparedData);
  }

  Future<void> _replaceCurrentAdminData(AppData preparedData) async {
    final directory = await _appDocumentSubDirectory(_adminDataBackupFolder);
    final file = File(path.join(directory.path, _adminDataCurrentFile));
    final tempFile = File(
      '${file.path}.${DateTime.now().microsecondsSinceEpoch}.tmp',
    );
    final payload = jsonEncode(preparedData.toJson());
    await tempFile.writeAsString(payload, flush: true);

    Object? lastError;
    StackTrace? lastStackTrace;
    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        if (!tempFile.existsSync()) {
          await tempFile.writeAsString(payload, flush: true);
        }
        if (file.existsSync()) {
          await file.delete();
        }
        await tempFile.rename(file.path);
        return;
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }
    Error.throwWithStackTrace(lastError!, lastStackTrace!);
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
        .where((file) =>
            file.path.toLowerCase().endsWith('.json') &&
            path.basename(file.path) != _adminDataCurrentFile)
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

  Future<AppData?> _loadLocalAdminData() async {
    final currentData = await _loadCurrentAdminData();
    if (currentData != null) {
      return currentData;
    }
    return _loadLatestAdminDataBackup();
  }

  Future<AppData?> _loadCurrentAdminData() async {
    final directory = await _appDocumentSubDirectory(_adminDataBackupFolder);
    final file = File(path.join(directory.path, _adminDataCurrentFile));
    if (!file.existsSync()) {
      return null;
    }
    try {
      final jsonMap = jsonDecode(await file.readAsString());
      if (jsonMap is Map<String, dynamic>) {
        return AppData.fromJson(jsonMap);
      }
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
    }
    return null;
  }

  Future<AppData?> _loadLatestAdminDataBackup() async {
    final backupDirectory =
        await _appDocumentSubDirectory(_adminDataBackupFolder);
    final files = backupDirectory
        .listSync()
        .whereType<File>()
        .where((file) =>
            file.path.toLowerCase().endsWith('.json') &&
            path.basename(file.path) != _adminDataCurrentFile)
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

  Future<void> _cleanupUploadedQueueFiles(Map<String, Object?> job) async {
    try {
      final saleNo = (job['saleNo'] ?? '').toString();
      if (saleNo.trim().isEmpty) {
        return;
      }

      final queueDirectory = await _appDocumentSubDirectory(_uploadQueueFolder);
      final sessionDirectory = Directory(
        path.join(queueDirectory.path, 'files', _sanitizePathSegment(saleNo)),
      );
      final sessionPath = path.normalize(sessionDirectory.absolute.path);
      final candidates = <String>[
        (job['imagePath'] ?? '').toString(),
        ..._readJobVideoPaths(job),
      ];

      for (final candidate in candidates) {
        if (candidate.trim().isEmpty) {
          continue;
        }
        final candidatePath = path.normalize(File(candidate).absolute.path);
        if (!path.equals(candidatePath, sessionPath) &&
            !path.isWithin(sessionPath, candidatePath)) {
          logE('Skip upload cleanup outside queue session: $candidate');
          continue;
        }
        final file = File(candidatePath);
        if (file.existsSync()) {
          await file.delete();
        }
      }

      if (sessionDirectory.existsSync()) {
        await sessionDirectory.delete(recursive: true);
      }
      job['cleanedAt'] = DateTime.now().toUtc().toIso8601String();
      logD('Upload queue files cleaned: saleNo=$saleNo');
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
    }
  }

  List<String> _readJobVideoPaths(Map<String, Object?> job) {
    final rawVideoPaths = job['videoPaths'];
    if (rawVideoPaths is List) {
      return rawVideoPaths.map((item) => item.toString()).toList();
    }
    return <String>[];
  }

  int _fileLength(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      return 0;
    }
    try {
      return file.lengthSync();
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      return 0;
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)} KB';
    }
    final mb = kb / 1024;
    if (mb < 1024) {
      return '${mb.toStringAsFixed(2)} MB';
    }
    final gb = mb / 1024;
    return '${gb.toStringAsFixed(2)} GB';
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
      final payload = (await file.readAsString()).trim();
      if (payload.isEmpty) {
        await file.writeAsString('[]', flush: true);
        return [];
      }
      final decoded = jsonDecode(payload);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((item) => Map<String, Object?>.from(item))
            .toList();
      }
    } catch (error, stackTrace) {
      logE(error, stackTrace: stackTrace);
      await file.writeAsString('[]', flush: true);
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
    final imageBytes = _fileLength(imagePath);
    final videoBytes = videoPaths.fold<int>(
      0,
      (total, videoPath) => total + _fileLength(videoPath),
    );
    final totalUploadBytes = imageBytes + videoBytes;
    logD(
      'Upload payload submit: saleNo=${job['saleNo']} imgCount=1 '
      'videoCount=${videoFiles.length}/${videoPaths.length} '
      'image=${_formatBytes(imageBytes)} video=${_formatBytes(videoBytes)} '
      'total=${_formatBytes(totalUploadBytes)}',
    );
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
