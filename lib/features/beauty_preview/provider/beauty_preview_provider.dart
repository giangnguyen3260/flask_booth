import 'package:injectable/injectable.dart';
import 'package:project_l/common/constants/beauty_effect.dart';
import 'package:project_l/common/models/effect.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/beauty_preview/provider/beauty_preview_listen_state.dart';

@injectable
class BeautyPreviewProvider extends BaseProvider<BeautyPreviewListenState> {
  BeautyPreviewProvider();

  bool beautyEnabled = false;

  Effect get previewEffect =>
      beautyEnabled ? BeautyEffect.smoothRose : Effect();

  void init() {
    beautyEnabled = BeautyEffect.isEnabled(appState.imageParam.effect);
    notifyListeners();
  }

  void setBeautyEnabled(bool enabled) {
    beautyEnabled = enabled;
    notifyListeners();
  }

  void saveSelection() {
    appState.updateEffect(previewEffect);
  }
}
