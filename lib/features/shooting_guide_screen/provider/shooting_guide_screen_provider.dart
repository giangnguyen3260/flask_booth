import 'package:injectable/injectable.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/shooting_guide_screen/provider/shooting_guide_screen_listen_state.dart';

@injectable
class ShootingGuideScreenProvider
    extends BaseProvider<
        ShootingGuideScreenListenState> {
  ShootingGuideScreenProvider();
}
