import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:project_l/common/constants/failure.dart';
import 'package:project_l/common/enums/filter_enum.dart';
import 'package:project_l/common/log/log_mixin.dart';
import 'package:project_l/common/models/effect.dart';
import 'package:project_l/common/models/matrix_param.dart';
import 'package:project_l/common/models/preset.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/background_selection/provider/background_selection_listen_state.dart';
import 'package:project_l/gen/assets.gen.dart';

@injectable
class BackgroundSelectionProvider
    extends BaseProvider<BackgroundSelectionListenState> with LogMixin {
  BackgroundSelectionProvider();

  int currentCategoryIndex = 0;

  int currentBackgroundIndex = -1;

  int currentPresetCategoryIndex = 0;

  int currentFilterIndex = -1;

  Effect effect = Effect();

  List<PresetCategory> presetCategory = [];

  void initPreset() async {
    var vscoPreset = await rootBundle.loadString(Assets.files.filter);
    final jsonData = jsonDecode(vscoPreset) as List<dynamic>;

    // Map each item in the list to a PresetCategory
    final presetCategories = jsonData
        .map((item) => PresetCategory.fromJson(item as Map<String, dynamic>))
        .toList();

    presetCategory = presetCategories;
    notifyListeners();
  }

  void changeCurrentCategoryIndex(int index) {
    currentCategoryIndex = index;
    currentBackgroundIndex = -1;
    notifyListeners();
  }

  void changeCurrentBackgroundIndex(int index) {
    currentBackgroundIndex = index;
    notifyListeners();
  }

  void changeCurrentPresetCategoryIndex(int index) {
    currentPresetCategoryIndex = index;
    currentFilterIndex = -1;
    effect = Effect();
    notifyListeners();
  }

  void changeCurrentFilterIndex(int index) {
    currentFilterIndex = index;
    effect = presetCategory[currentPresetCategoryIndex]
        .presets[currentFilterIndex]
        .value;
    notifyListeners();
  }

  void redo(bool isAdjusting) {
    if (isAdjusting) {
      effect = presetCategory[currentPresetCategoryIndex]
          .presets[currentFilterIndex]
          .value;
    } else {
      effect = Effect();
      currentFilterIndex = -1;
    }
    notifyListeners();
  }

  void changeEffect(double value, FilterEnum effectType) {
    switch (effectType) {
      case FilterEnum.brightness:
        effect = effect.copyWith(brightness: value);
        break;
      case FilterEnum.contrast:
        effect = effect.copyWith(contrast: value);
        break;
      case FilterEnum.saturation:
        effect = effect.copyWith(saturation: value);
        break;
      case FilterEnum.vibrance:
        effect = effect.copyWith(vibrance: value);
        break;
      case FilterEnum.temperature:
        effect = effect.copyWith(temperature: value);
        break;
      case FilterEnum.sepia:
        effect = effect.copyWith(sepia: value);
        break;
      case FilterEnum.grain:
        effect = effect.copyWith(grain: value);
        break;
    }
    notifyListeners();
  }

  void updateMatrix(List<double> scale, List<double> panX, List<double> panY,
      double scalePanX, double scalePanY) {
    if (scale.length != panX.length || scale.length != panY.length) {
      throw InternalError(message: "Can't update matrix");
    }
    List<MatrixParam> matrix = [];
    for (int i = 0; i < scale.length; i++) {
      matrix.add(
        MatrixParam(
          scale: scale[i],
          panX: -panX[i] * scalePanX,
          panY: -panY[i] * scalePanY,
        ),
      );
    }
    print(matrix);
    appState.updatePansAndScales(matrix);
  }
}
