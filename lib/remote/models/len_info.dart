import 'package:freezed_annotation/freezed_annotation.dart';

part 'len_info.freezed.dart';
part 'len_info.g.dart';

@freezed
class LenInfo with _$LenInfo {
  const factory LenInfo({
    @JsonKey(name: 'unlockable_id') String? unlockableId,
    @JsonKey(name: 'uuid') String? uuid,
    @JsonKey(name: 'snapcode_url') String? snapcodeUrl,
    @JsonKey(name: 'user_display_name') String? userDisplayName,
    @JsonKey(name: 'lens_name') String? lensName,
    @JsonKey(name: 'lens_status') String? lensStatus,
    @JsonKey(name: 'deeplink') String? deeplink,
    @JsonKey(name: 'icon_url') String? iconUrl,
    @JsonKey(name: 'thumbnail_media_url') String? thumbnailMediaUrl,
    @JsonKey(name: 'standard_media_url') String? standardMediaUrl,
    @JsonKey(name: 'obfuscated_user_slug') String? obfuscatedUserSlug,
    @JsonKey(name: 'thumbnail_media_poster_url') String? thumbnailMediaPosterUrl,
    @JsonKey(name: 'standard_media_poster_url') String? standardMediaPosterUrl,
    String? shotCut,
  }) = _LenInfo;

  factory LenInfo.fromJson(Map<String, Object?> json) => _$LenInfoFromJson(json);
}
