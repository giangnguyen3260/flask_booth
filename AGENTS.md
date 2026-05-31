# Repository Guidelines

## Tổng Quan Chức Năng

Đây là app Flutter photo booth/kiosk, ưu tiên desktop Windows/macOS. Luồng chính: chờ (`stand_by`), coupon, chọn filter/frame/số lượng in, thanh toán bằng bill acceptor, hướng dẫn chụp, chụp ảnh/quay video bằng camera, chọn ảnh, chọn background/chỉnh hiệu ứng, ghép ảnh/video, in ảnh, upload kết quả và hiển thị QR. Stack chính: `Provider`, `get_it`/`injectable`, `auto_route`, `retrofit`/`dio`, `freezed`, `json_serializable`, `ffmpeg_helper`, Canon EDSDK và MethodChannel cho thiết bị.

## Cấu Trúc Thư Mục

- `lib/main.dart`: khởi tạo DI, logging, fullscreen window, locale, router, `AppState`.
- `lib/features/`: màn hình nghiệp vụ; mỗi feature thường có `provider/` và `*_listen_state.dart`.
- `lib/common/`: constants, enums, models, navigation, base provider/page state, log, network, utilities.
- `lib/remote/`: API models và `RestClient` cho init data, coupon, submit ảnh/video.
- `lib/resources/`: component UI, text style, ARB localization, generated localization.
- `assets/`: icons, frame, dummy data, lottie, font Lexend, file runtime/printer/FFmpeg helper.
- `ffmpeg_helper/`, `edsdk/`: package local; `edsdk` phục vụ tích hợp camera Canon.
- `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/`: platform projects.
- `test/`: test Flutter; hiện `widget_test.dart` mới là placeholder.

## Lệnh Phát Triển

- `flutter pub get`: cài dependency cho app và package local.
- `flutter run -d windows` hoặc `flutter run -d macos`: chạy app desktop.
- `flutter analyze`: kiểm tra analyzer/lint.
- `flutter test`: chạy unit/widget tests.
- `dart run build_runner build --delete-conflicting-outputs`: regenerate `*.g.dart`, `*.freezed.dart`, `*.gr.dart`, Injectable config, FlutterGen.
- `cd ffmpeg_helper && flutter test`: test package FFmpeg helper khi chỉnh package này.

## Coding Style & Format

Dùng `package:flutter_lints/flutter.yaml` và chạy `dart format .`. Quy ước: indent 2 spaces, file `snake_case.dart`, class/widget/model `UpperCamelCase`, biến và hàm `lowerCamelCase`. Provider đặt trong `lib/features/<feature>/provider/`; UI dùng chung trong `lib/resources/components/`; logic dùng chung trong `lib/common/util/` hoặc `lib/common/provider/`. Không sửa tay file generated như `*.g.dart`, `*.freezed.dart`, `app_router.gr.dart`, `injetable_config.config.dart`, `assets.gen.dart`.

## Kiến Trúc State & Data

`AppState` là singleton lưu session, frame/background/filter/effect, ảnh, video, số lượng in và coupon. Các màn hình dùng `BaseProvider` để truy cập `appState`, `navigator`, `RestClient`. API chính: `/pub/main-info`, `/coupons/validate/{id}`, `/pub/submit`.

## Testing Guidelines

Viết test bằng `flutter_test`, đặt tên `*_test.dart`, ví dụ `test/features/payment_screen/payment_screen_test.dart`. Ưu tiên provider/business logic: coupon, chọn frame/số lượng, chọn ảnh, in/upload. UI thay đổi lớn cần widget test hoặc test thủ công trên desktop.

## Commit & Pull Request

Git history chỉ có `Initial commit`, chưa có convention bắt buộc. Dùng message ngắn dạng imperative: `Add coupon validation`, `Fix printer cut mode`. PR cần mô tả thay đổi, luồng bị ảnh hưởng, lệnh đã chạy, issue liên quan và screenshot/recording nếu đổi UI.

## Lưu Ý Cấu Hình & Phần Cứng

Không commit secret, config máy local, đường dẫn production hoặc dữ liệu nhạy cảm. App đọc config Windows từ `Local\\Project_L\\app_config.json` cho camera và bill acceptor. Phần camera, bill acceptor, printer, MethodChannel hoặc `assets/files/` cần test trên máy có đúng thiết bị.
