#ifndef RUNNER_FLUTTER_WINDOW_H_
#define RUNNER_FLUTTER_WINDOW_H_

#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <flutter/binary_messenger.h>
#include <flutter/standard_method_codec.h>
#include <flutter/method_channel.h>
#include <flutter/method_result_functions.h>
#include <flutter/encodable_value.h>
#include <winspool.h>
#include <string>
#include <vector>
#include <memory>
#include <locale>
#include <codecvt>
#include <windows.h>
#include <tchar.h>
#include <memory>

#include "win32_window.h"

using namespace std;

// A window that does nothing but host a Flutter view.
class FlutterWindow : public Win32Window {
 public:
  // Creates a new FlutterWindow hosting a Flutter view running |project|.
  explicit FlutterWindow(const flutter::DartProject& project);
  virtual ~FlutterWindow();

 protected:
  // Win32Window:
  bool OnCreate() override;
  void OnDestroy() override;
  LRESULT MessageHandler(HWND window, UINT const message, WPARAM const wparam,
                         LPARAM const lparam) noexcept override;

 private:
  // The project to run.
  flutter::DartProject project_;

  // The Flutter instance hosted by this window.
  std::unique_ptr<flutter::FlutterViewController> flutter_controller_;
};

// Define JobInfo structure
struct JobInfo {
    DWORD jobId;
    DWORD status;
    std::string document;
    std::string userName;
    std::string printer;
    DWORD pagesPrinted;
    DWORD totalPages;
};

#endif  // RUNNER_FLUTTER_WINDOW_H_
