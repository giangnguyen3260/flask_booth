// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppDataImpl _$$AppDataImplFromJson(Map<String, dynamic> json) =>
    _$AppDataImpl(
      framesInfo: (json['framesInfo'] as List<dynamic>?)
          ?.map((e) => FramesInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      configInfo: json['configInfo'] == null
          ? null
          : ConfigInfo.fromJson(json['configInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AppDataImplToJson(_$AppDataImpl instance) =>
    <String, dynamic>{
      'framesInfo': instance.framesInfo,
      'configInfo': instance.configInfo,
    };

_$ConfigInfoImpl _$$ConfigInfoImplFromJson(Map<String, dynamic> json) =>
    _$ConfigInfoImpl(
      timer: (json['timer'] as List<dynamic>?)
          ?.map((e) => Timer.fromJson(e as Map<String, dynamic>))
          .toList(),
      configVersion: (json['configVersion'] as num?)?.toInt(),
      appConfig: (json['appConfig'] as List<dynamic>?)
          ?.map((e) => AppConfigItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ConfigInfoImplToJson(_$ConfigInfoImpl instance) =>
    <String, dynamic>{
      'timer': instance.timer,
      'configVersion': instance.configVersion,
      'appConfig': instance.appConfig,
    };

_$TimerImpl _$$TimerImplFromJson(Map<String, dynamic> json) => _$TimerImpl(
      screenIndex: (json['screenIndex'] as num?)?.toInt(),
      screenCd: json['screenCd'] as String?,
      nextScreenCd: json['nextScreenCd'] as String?,
      value: (json['value'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TimerImplToJson(_$TimerImpl instance) =>
    <String, dynamic>{
      'screenIndex': instance.screenIndex,
      'screenCd': instance.screenCd,
      'nextScreenCd': instance.nextScreenCd,
      'value': instance.value,
    };

_$AppConfigItemImpl _$$AppConfigItemImplFromJson(Map<String, dynamic> json) =>
    _$AppConfigItemImpl(
      configKey: json['configKey'] as String?,
      version: (json['version'] as num?)?.toInt(),
      value: json['value'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AppConfigItemImplToJson(_$AppConfigItemImpl instance) =>
    <String, dynamic>{
      'configKey': instance.configKey,
      'version': instance.version,
      'value': instance.value,
    };

_$FramesInfoImpl _$$FramesInfoImplFromJson(Map<String, dynamic> json) =>
    _$FramesInfoImpl(
      frameCd: json['frameCd'] as String?,
      frameUrl: json['frameUrl'] as String?,
      frameUrlTempDis: json['frameUrlTempDis'] as String?,
      verticalYn: json['verticalYn'] as String?,
      cutYn: json['cutYn'] as String?,
      transparent: json['transparent'] as String?,
      width: json['width'] as String?,
      height: json['height'] as String?,
      printQuantity: json['printQuantity'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      frameSetting: json['frameSetting'] == null
          ? null
          : FrameSetting.fromJson(json['frameSetting'] as Map<String, dynamic>),
      backgroundInfo: (json['backgroundInfo'] as List<dynamic>?)
          ?.map((e) => BackgroundInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FramesInfoImplToJson(_$FramesInfoImpl instance) =>
    <String, dynamic>{
      'frameCd': instance.frameCd,
      'frameUrl': instance.frameUrl,
      'frameUrlTempDis': instance.frameUrlTempDis,
      'verticalYn': instance.verticalYn,
      'cutYn': instance.cutYn,
      'transparent': instance.transparent,
      'width': instance.width,
      'height': instance.height,
      'printQuantity': instance.printQuantity,
      'price': instance.price,
      'currency': instance.currency,
      'frameSetting': instance.frameSetting,
      'backgroundInfo': instance.backgroundInfo,
    };

_$BackgroundInfoImpl _$$BackgroundInfoImplFromJson(Map<String, dynamic> json) =>
    _$BackgroundInfoImpl(
      bgCateCd: json['bgCateCd'] as String?,
      bgCateNm: json['bgCateNm'] as String?,
      bgCateIcon: json['bgCateIcon'] as String?,
      background: (json['background'] as List<dynamic>?)
          ?.map((e) => Background.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BackgroundInfoImplToJson(
        _$BackgroundInfoImpl instance) =>
    <String, dynamic>{
      'bgCateCd': instance.bgCateCd,
      'bgCateNm': instance.bgCateNm,
      'bgCateIcon': instance.bgCateIcon,
      'background': instance.background,
    };

_$BackgroundImpl _$$BackgroundImplFromJson(Map<String, dynamic> json) =>
    _$BackgroundImpl(
      bgCd: json['bgCd'] as String?,
      bgNm: json['bgNm'] as String?,
      bgUrl: json['bgUrl'] as String?,
      maskJson: (json['maskJson'] as List<dynamic>?)
          ?.map((e) => BackgroundMaskArea.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BackgroundImplToJson(_$BackgroundImpl instance) =>
    <String, dynamic>{
      'bgCd': instance.bgCd,
      'bgNm': instance.bgNm,
      'bgUrl': instance.bgUrl,
      'maskJson': instance.maskJson,
    };

_$BackgroundMaskAreaImpl _$$BackgroundMaskAreaImplFromJson(
        Map<String, dynamic> json) =>
    _$BackgroundMaskAreaImpl(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$$BackgroundMaskAreaImplToJson(
        _$BackgroundMaskAreaImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'width': instance.width,
      'height': instance.height,
      'type': instance.type,
    };

_$FrameSettingImpl _$$FrameSettingImplFromJson(Map<String, dynamic> json) =>
    _$FrameSettingImpl(
      numOfPhotos: (json['numOfPhotos'] as num?)?.toInt(),
      timePerShot: (json['timePerShot'] as num?)?.toInt(),
      additionPrice: (json['additionPrice'] as num?)?.toDouble(),
      addPhotoNumber: (json['addPhotoNumber'] as num?)?.toInt(),
      addPhotoLimit: (json['addPhotoLimit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$FrameSettingImplToJson(_$FrameSettingImpl instance) =>
    <String, dynamic>{
      'numOfPhotos': instance.numOfPhotos,
      'timePerShot': instance.timePerShot,
      'additionPrice': instance.additionPrice,
      'addPhotoNumber': instance.addPhotoNumber,
      'addPhotoLimit': instance.addPhotoLimit,
    };
