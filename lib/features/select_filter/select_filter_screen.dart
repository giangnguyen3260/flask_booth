import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_l/common/navigator/app_router.gr.dart';
import 'package:project_l/common/provider/base_page_state.dart';
import 'package:project_l/common/util/key_map.dart';
import 'package:project_l/common/util/keyboard_windows.dart';
import 'package:project_l/features/select_filter/provider/select_filter_listen_state.dart';
import 'package:project_l/features/select_filter/provider/select_filter_provider.dart';
import 'package:project_l/remote/models/len_info.dart';
import 'package:project_l/resources/app_text_style.dart';
import 'package:project_l/resources/flashy_booth_theme.dart';

@RoutePage()
class SelectFilterScreen extends StatefulWidget {
  const SelectFilterScreen({super.key});

  @override
  State<SelectFilterScreen> createState() => _SelectFilterScreenState();
}

class _SelectFilterScreenState extends BasePageState<SelectFilterListenState,
    SelectFilterProvider, SelectFilterScreen> {
  CameraController? controller;
  String id = "";
  bool isLoading = false;

  @override
  void onNext(SelectFilterProvider provider) {
    super.onNext(provider);
    navigator.replaceAll([ShootingGuideRouteRoute()]);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  bool isShowNext(SelectFilterProvider provider) {
    return true;
  }

  @override
  void afterFirstBuild() {
    appState.cameraPowerUtil.turnOnCamera();
    provider.init();
    CameraPlatform.instance.availableCameras().then((value) {
      controller = CameraController(value[0], ResolutionPreset.medium,
          enableAudio: false);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
    });
  }

  @override
  bool isShowCountDown() {
    return false;
  }

  void simulateKeyCombination(String input, String id) {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      final keys = input.split('+').map((k) => k.trim()).toList();

      for (var key in keys) {
        final keyCode = keyCodeMap[key];
        if (keyCode != null) {
          keyDown(keyCode);
        } else {
          logU('⚠️ Không tìm thấy phím "$key"');
        }
      }
      Future.delayed(Duration(milliseconds: 200)).then((_) {
        for (var key in keys) {
          final keyCode = keyCodeMap[key];
          if (keyCode != null) {
            keyUp(keyCode);
          } else {
            logU('⚠️ Không tìm thấy phím "$key"');
          }
        }
        setState(() {
          isLoading = false;
          if (this.id != id) {
            this.id = id;
          } else {
            this.id = "";
          }
        });
      });
    }
  }

  @override
  Widget buildPage(BuildContext context, double maxWidth, double maxHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 1300;
        final previewHeight = isCompact ? 340.h : maxHeight * 0.72;
        final gridHeight = isCompact ? 280.h : 300.h;
        final contentPadding = EdgeInsets.symmetric(
          horizontal: isCompact ? 20.w : 60.w,
          vertical: isCompact ? 20.h : 0,
        );

        Widget preview = controller != null
            ? Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
                child: Transform.flip(
                  flipY: true,
                  flipX: false,
                  child: CameraPreview(controller!),
                ),
              )
            : const SizedBox();

        Widget panel = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              flashyBoothText(
                context,
                vi: "Hãy chọn hiệu ứng yêu thích",
                en: "Choose your favorite effect",
              ),
              style: style32500,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            Text(
              flashyBoothText(
                context,
                vi: "Chọn lại một lần nữa hoặc nhấn nút Mặc định để hủy",
                en: "Select again or tap Default to clear",
              ),
              style: style24400,
              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            SizedBox(
              height: gridHeight,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.lens.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.r,
                    crossAxisSpacing: 10.r,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (ctx, index) {
                    return _renderLensOption(provider.lens[index]);
                  }),
            ),
            Spacer(),
          ],
        );

        if (isCompact) {
          return Stack(
            children: [
              Padding(
                padding: contentPadding,
                child: Column(
                  children: [
                    SizedBox(height: previewHeight, child: preview),
                    24.verticalSpace,
                    Expanded(child: panel),
                  ],
                ),
              ),
              Positioned(
                top: 30.h,
                right: 112.w,
                child: const FlashyBoothLanguagePill(),
              ),
            ],
          );
        }

        return Stack(
          children: [
            Padding(
              padding: contentPadding,
              child: Row(
                children: [
                  Expanded(child: preview),
                  60.horizontalSpace,
                  Expanded(child: panel),
                ],
              ),
            ),
            Positioned(
              top: 30.h,
              right: 112.w,
              child: const FlashyBoothLanguagePill(),
            ),
          ],
        );
      },
    );
  }

  GestureDetector _renderLensOption(LenInfo e) {
    return GestureDetector(
      onTap: () {
        simulateKeyCombination(e.shotCut ?? "", e.unlockableId ?? "");
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.grey[200],
          border: id == e.unlockableId
              ? Border.all(color: Colors.green, width: 4.w)
              : null,
        ),
        padding: EdgeInsets.all(12.r),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                e.iconUrl ?? "",
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    flashyBoothText(
                      context,
                      vi: 'Không thể tải ảnh',
                      en: 'Could not load image',
                    ),
                  );
                },
              ),
            ),
            20.verticalSpace,
            Text(
              e.lensName ?? "",
              style: style20400,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget renderFooter(SelectFilterProvider provider) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () {
              if (id != "") {
                simulateKeyCombination("Ctrl+Alt+Shift+Q", "");
              }
            },
            child: Row(
              children: [
                Text(
                  flashyBoothText(context, vi: "Mặc định", en: "Default"),
                  style: style32400,
                ),
                12.horizontalSpace,
                Icon(
                  Icons.loop,
                  size: 32.sp,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
