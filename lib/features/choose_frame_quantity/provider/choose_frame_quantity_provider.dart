import 'package:injectable/injectable.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/choose_frame_quantity/provider/choose_frame_quantity_listen_state.dart';

@injectable
class ChooseFrameQuantityProvider
    extends BaseProvider<ChooseFrameQuantityListenState> {
  ChooseFrameQuantityProvider();

  static const int _defaultPrintQuantity = 1;
  static const int _defaultAddPhotoNumber = 1;
  static const int _defaultAddPhotoLimit = 99;
  static const double _defaultAdditionPrice = 30000;

  late int printQuantity = _positiveIntOrDefault(
    int.tryParse(appState.imageParam.selectedFrame.printQuantity ?? ""),
    _defaultPrintQuantity,
  );

  late int frameQty = printQuantity;
  late double price = appState.imageParam.selectedFrame.price ?? 0;
  late double additionPrice = _positiveDoubleOrDefault(
    appState.imageParam.selectedFrame.frameSetting?.additionPrice,
    _defaultAdditionPrice,
  );
  late int addPhotoNumber = _positiveIntOrDefault(
    appState.imageParam.selectedFrame.frameSetting?.addPhotoNumber,
    _defaultAddPhotoNumber,
  );
  late int addPhotoLimit = _resolveAddPhotoLimit();

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

  int _resolveAddPhotoLimit() {
    final configuredLimit =
        appState.imageParam.selectedFrame.frameSetting?.addPhotoLimit;
    final fallbackLimit = printQuantity > _defaultAddPhotoLimit
        ? printQuantity
        : _defaultAddPhotoLimit;
    return _positiveIntOrDefault(configuredLimit, fallbackLimit);
  }

  int _positiveIntOrDefault(int? value, int fallback) {
    if (value == null || value <= 0) {
      return fallback;
    }
    return value;
  }

  double _positiveDoubleOrDefault(double? value, double fallback) {
    if (value == null || value <= 0) {
      return fallback;
    }
    return value;
  }
}
