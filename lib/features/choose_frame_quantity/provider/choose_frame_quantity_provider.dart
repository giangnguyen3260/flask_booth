import 'package:injectable/injectable.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/choose_frame_quantity/provider/choose_frame_quantity_listen_state.dart';

@injectable
class ChooseFrameQuantityProvider
    extends BaseProvider<ChooseFrameQuantityListenState> {
  ChooseFrameQuantityProvider();

  static const int _defaultPrintQuantity = 1;

  late int printQuantity = _positiveIntOrDefault(
    int.tryParse(appState.imageParam.selectedFrame.printQuantity ?? ""),
    _defaultPrintQuantity,
  );

  late int frameQty = printQuantity;
  late double price = appState.imageParam.selectedFrame.price ?? 0;
  late double additionPrice = _positiveDoubleOrZero(
      appState.imageParam.selectedFrame.frameSetting?.additionPrice);
  late int addPhotoNumber = _positiveIntOrZero(
      appState.imageParam.selectedFrame.frameSetting?.addPhotoNumber);
  late int addPhotoLimit = _resolveAddPhotoLimit();

  late double totalPrice = appState.imageParam.selectedFrame.price ?? 0;
  int _extraPrintSteps = 0;

  void increaseFrame() {
    if (_extraPrintEnabled && frameQty + addPhotoNumber <= addPhotoLimit) {
      _extraPrintSteps += 1;
      _syncPrintTotals();
      notifyListeners();
    }
  }

  void reduceFrame() {
    if (_extraPrintSteps > 0) {
      _extraPrintSteps -= 1;
      _syncPrintTotals();
      notifyListeners();
    }
  }

  int _resolveAddPhotoLimit() {
    final configuredLimit =
        appState.imageParam.selectedFrame.frameSetting?.addPhotoLimit;
    final normalizedLimit = _positiveIntOrZero(configuredLimit);
    return normalizedLimit > printQuantity ? normalizedLimit : printQuantity;
  }

  int _positiveIntOrDefault(int? value, int fallback) {
    if (value == null || value <= 0) {
      return fallback;
    }
    return value;
  }

  int _positiveIntOrZero(int? value) {
    if (value == null || value <= 0) {
      return 0;
    }
    return value;
  }

  double _positiveDoubleOrZero(double? value) {
    if (value == null || value <= 0) {
      return 0;
    }
    return value;
  }

  bool get _extraPrintEnabled => addPhotoNumber > 0 && additionPrice > 0;

  void _syncPrintTotals() {
    frameQty = printQuantity + (_extraPrintSteps * addPhotoNumber);
    totalPrice = price + (_extraPrintSteps * additionPrice);
  }
}
