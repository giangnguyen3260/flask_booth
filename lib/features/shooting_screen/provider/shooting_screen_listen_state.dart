import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_l/common/provider/base_listen_state.dart';

part 'shooting_screen_listen_state.freezed.dart';

@freezed
class ShootingScreenListenState extends BaseListenState with _$ShootingScreenListenState {
  const factory ShootingScreenListenState.success() = ShootingScreenSuccessState;
}