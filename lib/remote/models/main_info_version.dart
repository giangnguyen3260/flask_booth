import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_info_version.freezed.dart';
part 'main_info_version.g.dart';

@freezed
class MainInfoVersion with _$MainInfoVersion {
  const factory MainInfoVersion({
    @JsonKey(name: 'version') int? version,
    @JsonKey(name: 'updatedAt') String? updatedAt,
  }) = _MainInfoVersion;

  factory MainInfoVersion.fromJson(Map<String, Object?> json) =>
      _$MainInfoVersionFromJson(json);
}
