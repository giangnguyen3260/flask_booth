import 'package:injectable/injectable.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/choose_frame/provider/choose_frame_listen_state.dart';

@Injectable()
class ChooseFrameProvider extends BaseProvider< ChooseFrameListenState> {
  ChooseFrameProvider() ;

  int selectedFrame = 0;

  void selectFrame(int index){
    selectedFrame = index;
    notifyListeners();
  }

}
