import 'dart:math';

import 'package:injectable/injectable.dart';
import 'package:project_l/common/provider/base_provider.dart';
import 'package:project_l/features/photo_selection/provider/photo_selection_screen_listen_state.dart'
    show PhotoSelectionListenState;

@injectable
class PhotoSelectionProvider extends BaseProvider<PhotoSelectionListenState> {
  PhotoSelectionProvider();

  List<String> tempData = [];

  bool isFlip = false;
  int? selectedSlotIndex;

  void init({required int numPictures}) {
    tempData = List.generate(numPictures, (_) => "");
    selectedSlotIndex = null;
    logD('PhotoSelection init: numPictures=$numPictures');
    notifyListeners();
  }

  void selectSlot({required int index}) {
    if (index < 0 || index >= tempData.length) {
      return;
    }
    selectedSlotIndex = index;
    logD('PhotoSelection selectSlot: index=$index');
    notifyListeners();
  }

  void selectImage({
    required String imagePath,
  }) {
    if (selectedSlotIndex != null &&
        selectedSlotIndex! >= 0 &&
        selectedSlotIndex! < tempData.length) {
      tempData[selectedSlotIndex!] = imagePath;
      logD(
        'PhotoSelection selectImage: targetSlot=$selectedSlotIndex path=$imagePath',
      );
      selectedSlotIndex = tempData.indexWhere((e) => e.isEmpty);
      if (selectedSlotIndex == -1) {
        selectedSlotIndex = null;
      }
      notifyListeners();
      return;
    }

    for (int i = 0; i < tempData.length; i++) {
      if (tempData[i].isEmpty) {
        tempData[i] = imagePath;
        logD('PhotoSelection selectImage: firstEmptySlot=$i path=$imagePath');
        break;
      }
    }
    selectedSlotIndex = tempData.indexWhere((e) => e.isEmpty);
    if (selectedSlotIndex == -1) {
      selectedSlotIndex = null;
    }
    notifyListeners();
  }

  void removeImageAt({required int index}) {
    if (index < 0 || index >= tempData.length) {
      return;
    }
    final imagePath = tempData[index];
    if (imagePath.isEmpty) {
      selectedSlotIndex = index;
      notifyListeners();
      return;
    }
    tempData[index] = '';
    selectedSlotIndex = index;
    logD('PhotoSelection removeImageAt: index=$index path=$imagePath');
    notifyListeners();
  }

  void toggleImageSelection({
    required String imagePath,
  }) {
    if (tempData.contains(imagePath)) {
      removeImage(imagePath: imagePath);
      return;
    }
    selectImage(imagePath: imagePath);
  }

  void removeImage({
    required String imagePath,
  }) {
    var index = tempData.indexOf(imagePath);
    if (index == -1) return;
    tempData[index] = '';
    selectedSlotIndex = index;
    logD('PhotoSelection removeImage: index=$index path=$imagePath');
    notifyListeners();
  }

  void flipImage() {
    isFlip = !isFlip;
    notifyListeners();
  }

  // Hàm điền ngẫu nhiên các hình chưa được chọn
  void fillRandomImages({required Map<String, String> originalData}) {
    List<String> availableImages = originalData.keys
        .where((imagePath) => !tempData.contains(imagePath))
        .toList();

    if (availableImages.isEmpty) {
      logD('PhotoSelection fillRandomImages: no available images');
      return;
    }

    int emptyCount = tempData.where((path) => path.isEmpty).length;
    int imagesToSelect = min(emptyCount, availableImages.length);

    availableImages.shuffle(Random());

    int selectedCount = 0;
    for (int i = 0;
        i < tempData.length && selectedCount < imagesToSelect;
        i++) {
      if (tempData[i].isEmpty) {
        tempData[i] = availableImages[selectedCount];
        selectedCount++;
      }
    }

    notifyListeners();
  }

  bool onEnd({required Map<String, String> originalData}) {
    // Bổ sung hình chưa chọn nếu cần
    List<String> availableKeys = originalData.keys.toList();

    // Thêm hình ngẫu nhiên vào các vị trí trống
    for (int i = 0; i < tempData.length; i++) {
      if (tempData[i].isEmpty) {
        // Lọc ra các key chưa được chọn
        List<String> unchosen =
            availableKeys.where((key) => !tempData.contains(key)).toList();
        if (unchosen.isNotEmpty) {
          String randomChoice = unchosen[Random().nextInt(unchosen.length)];
          tempData[i] = randomChoice;
        } else {
          // Nếu không còn key nào chưa chọn thì gán tạm rỗng
          tempData[i] = '';
        }
      }
    }

    // Nếu vẫn còn dữ liệu trống (trường hợp không đủ hình), báo lỗi
    if (tempData.any((element) => element.isEmpty)) return false;

    // Tạo danh sách video tương ứng với tempData
    List<String> videos =
        tempData.map((key) => originalData[key] ?? '').toList();

    appState.updateFlip(isFlip);
    appState.updateImages(tempData);
    appState.updateVideos(videos);
    logD('PhotoSelection onEnd: images=${tempData.length}');
    return true;
  }

  bool onNext({required Map<String, String> originalData}) {
    final stopwatch = Stopwatch()..start();
    logD(
      'PERF PhotoSelectionProvider.onNext start temp=${tempData.length} original=${originalData.length}',
    );
    for (int i = 0; i < tempData.length; i++) {
      if (tempData[i].isEmpty) {
        logD(
          'PERF PhotoSelectionProvider.onNext empty index=$i elapsed=${stopwatch.elapsedMilliseconds}ms',
        );
        return false;
      }
    }

    List<String> videos = [];
    for (int i = 0; i < tempData.length; i++) {
      videos.add(originalData[tempData[i]] ?? '');
    }
    appState.updateFlip(isFlip);
    appState.updateImages(tempData);
    appState.updateVideos(videos);
    logD(
      'PERF PhotoSelectionProvider.onNext end images=${tempData.length} videos=${videos.length} elapsed=${stopwatch.elapsedMilliseconds}ms',
    );
    return true;
  }
}
