import 'package:injectable/injectable.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/choose_frame_quantity/provider/choose_frame_quantity_listen_state.dart';

@injectable
class ChooseFrameQuantityProvider
    extends BaseProvider<ChooseFrameQuantityListenState> {
  ChooseFrameQuantityProvider();

  late int printQuantity =
      int.tryParse(appState.imageParam.selectedFrame.printQuantity ?? "") ?? 0;

  late int frameQty =
      int.tryParse(appState.imageParam.selectedFrame.printQuantity ?? "") ?? 0;
  late double price = appState.imageParam.selectedFrame.price ?? 0;
  late double additionPrice =
      appState.imageParam.selectedFrame.frameSetting?.additionPrice ?? 0;
  late int addPhotoNumber =
      appState.imageParam.selectedFrame.frameSetting?.addPhotoNumber ?? 0;
  late int addPhotoLimit =
      appState.imageParam.selectedFrame.frameSetting?.addPhotoLimit ?? 0;

  late double totalPrice = appState.imageParam.selectedFrame.price ?? 0;

  void increaseFrame() {
    if (frameQty < addPhotoLimit && frameQty >= printQuantity) {
      frameQty += addPhotoNumber;
      totalPrice += additionPrice;
      notifyListeners();
    }
  }

  void reduceFrame() {
    if (frameQty > printQuantity) {
      frameQty -= addPhotoNumber;
      totalPrice -= additionPrice;
      notifyListeners();
    }
  }
}
