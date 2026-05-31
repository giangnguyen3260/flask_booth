#include "flutter_window.h"

#include <optional>

#include "flutter/generated_plugin_registrant.h"

// Convert std::wstring to std::string (UTF-8)
std::string WideToUtf8(const std::wstring &wide) {
    int size_needed = WideCharToMultiByte(CP_UTF8, 0, wide.data(), static_cast<int>(wide.size()),
                                          nullptr, 0, nullptr, nullptr);
    std::string utf8(size_needed, 0);
    WideCharToMultiByte(CP_UTF8, 0, wide.data(), static_cast<int>(wide.size()), utf8.data(),
                        size_needed, nullptr, nullptr);
    return utf8;
}

std::vector <JobInfo> GetPrintJobQueue(LPCWSTR printerName) {
    HANDLE hPrinter;
    PRINTER_DEFAULTS pd = {NULL, NULL, PRINTER_ACCESS_USE};
    JOB_INFO_1 *pJobInfo = NULL;
    DWORD needed = 0;
    DWORD totalJobs = 0;
    std::vector <JobInfo> jobs;

    // Open the printer
    if (!OpenPrinter((LPWSTR) printerName, &hPrinter, &pd)) {
        DWORD error = GetLastError();
        std::wcerr << L"Failed to open printer. Error code: " << error << std::endl;
        return jobs;
    }

    // First call to EnumJobs to get the size needed for the JOB_INFO_1 array
    EnumJobs(hPrinter, 0, 0xFFFFFFFF, 1, NULL, 0, &needed, &totalJobs);
    if (needed == 0) {
        std::wcerr << L"No jobs in the queue or failed to get job information size." << std::endl;
        ClosePrinter(hPrinter);
        return jobs;
    }

    // Allocate memory for JOB_INFO_1 structures
    pJobInfo = (JOB_INFO_1 *) malloc(needed);
    if (!pJobInfo) {
        std::wcerr << L"Failed to allocate memory for JOB_INFO_1." << std::endl;
        ClosePrinter(hPrinter);
        return jobs;
    }

    // Call EnumJobs again to retrieve the job information
    if (!EnumJobs(hPrinter, 0, 0xFFFFFFFF, 1, (LPBYTE) pJobInfo, needed, &needed, &totalJobs)) {
        DWORD error = GetLastError();
        std::wcerr << L"Failed to enumerate jobs. Error code: " << error << std::endl;
        free(pJobInfo);
        ClosePrinter(hPrinter);
        return jobs;
    }

    // Loop through the jobs and display information
    for (DWORD i = 0; i < totalJobs; i++) {
        JobInfo job;
        job.jobId = pJobInfo[i].JobId;
        job.printer = pJobInfo[i].pPrinterName ? WideToUtf8(pJobInfo[i].pPrinterName) : "";;
        job.status = pJobInfo[i].Status;
        job.document = pJobInfo[i].pDocument ? WideToUtf8(pJobInfo[i].pDocument) : "";
        job.userName = pJobInfo[i].pUserName ? WideToUtf8(pJobInfo[i].pUserName) : "";
        job.pagesPrinted = pJobInfo[i].PagesPrinted;
        job.totalPages = pJobInfo[i].TotalPages;
        jobs.push_back(job);
    }

    // Clean up
    free(pJobInfo);
    ClosePrinter(hPrinter);

    return jobs;
}

bool SetPaperSize(LPCWSTR printerName, int paperSize) {
    HANDLE hPrinter;
    PRINTER_DEFAULTS pd = {NULL, NULL, PRINTER_ALL_ACCESS};
    DEVMODE *pDevMode = NULL;
    PRINTER_INFO_2 *pPrinterInfo2 = NULL;
    DWORD needed = 0;
    DWORD returned = 0;
    // Open the printer
    if (!OpenPrinter((LPWSTR) printerName, &hPrinter, &pd)) {
        DWORD error = GetLastError();
        std::wcerr << L"Failed to open printer. Error code: " << error << std::endl;
        return false;
    }

    // Get the required size for the PRINTER_INFO_2 structure
    GetPrinter(hPrinter, 2, NULL, 0, &needed);
    if (needed == 0) {
        std::wcerr << L"Failed to get printer information size." << std::endl;
        ClosePrinter(hPrinter);
        return false;
    }

    // Allocate memory for PRINTER_INFO_2
    pPrinterInfo2 = (PRINTER_INFO_2 *) malloc(needed);
    if (!pPrinterInfo2) {
        std::wcerr << L"Failed to allocate memory for PRINTER_INFO_2." << std::endl;
        ClosePrinter(hPrinter);
        return false;
    }

    // Get the printer information
    if (!GetPrinter(hPrinter, 2, (LPBYTE) pPrinterInfo2, needed, &returned)) {
        DWORD error = GetLastError();
        std::wcerr << L"Failed to get printer information. Error code: " << error << std::endl;
        free(pPrinterInfo2);
        ClosePrinter(hPrinter);
        return false;
    }

    // Get the current DEVMODE
    if (pPrinterInfo2->pDevMode) {
        pDevMode = pPrinterInfo2->pDevMode;

        // Modify the DEVMODE to set the custom paper size
        pDevMode->dmPaperSize = static_cast<SHORT>(paperSize); // Set custom paper size
        pDevMode->dmFields |= DM_PAPERSIZE;

        // Set the printer information with the updated DEVMODE
        SetPrinter(hPrinter, 2, (LPBYTE) pPrinterInfo2, 0);
    } else {
        std::wcerr << L"DEVMODE is NULL." << std::endl;
    }

    // Clean up
    free(pPrinterInfo2);
    ClosePrinter(hPrinter);

    return true;
}


void methodHandlers(const flutter::MethodCall<> &call,
                    std::unique_ptr <flutter::MethodResult<>> *result) {
    if (call.method_name().compare("change_size") == 0) {
        const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(
                call.arguments());
        auto sizeValue = (argsList->find(flutter::EncodableValue("size")))->second;
        auto printerNameValue = (argsList->find(flutter::EncodableValue("printer_name")))->second;
        std::string printerNameUtf8 = std::get<std::string>(printerNameValue);
        int size = std::get<int>(sizeValue);
        std::wstring printerName(printerNameUtf8.begin(), printerNameUtf8.end());

        bool rs = SetPaperSize(printerName.c_str(), size);
        (*result)->Success(rs);
    } else if (call.method_name().compare("get_job_queue") == 0) {
        const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(
                call.arguments());
        auto printerNameValue = (argsList->find(flutter::EncodableValue("printer_name")))->second;
        std::string printerNameUtf8 = std::get<std::string>(printerNameValue);
        std::wstring printerName(printerNameUtf8.begin(), printerNameUtf8.end());
        std::vector <JobInfo> jobQueue = GetPrintJobQueue(printerName.c_str());

        flutter::EncodableList jobs; // Change from vector to EncodableList
        for (const auto &job: jobQueue) {
            flutter::EncodableMap jobMap;
            jobMap[flutter::EncodableValue("JobId")] = flutter::EncodableValue(
                    static_cast<int>(job.jobId));
            jobMap[flutter::EncodableValue("Status")] = flutter::EncodableValue(
                    static_cast<int>(job.status));
            jobMap[flutter::EncodableValue("Document")] = flutter::EncodableValue(job.document);
            jobMap[flutter::EncodableValue("User")] = flutter::EncodableValue(job.userName);
            jobMap[flutter::EncodableValue("PagesPrinted")] = flutter::EncodableValue(
                    static_cast<int>(job.pagesPrinted));
            jobMap[flutter::EncodableValue("TotalPages")] = flutter::EncodableValue(
                    static_cast<int>(job.totalPages));
            jobMap[flutter::EncodableValue("Printer")] = flutter::EncodableValue(job.printer);

            jobs.push_back(jobMap); // Add jobMap to EncodableList
        }

        // Send the jobs back to Flutter
        (*result)->Success(flutter::EncodableValue(jobs));
    } else if (call.method_name().compare("job_operation") == 0) {
        const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(
                call.arguments());
        auto printerNameValue = (argsList->find(flutter::EncodableValue("printer_name")))->second;
        auto operationValue = (argsList->find(flutter::EncodableValue("operation")))->second;
        auto jobIdValue = (argsList->find(flutter::EncodableValue("job_id")))->second;
        int operation = std::get<int>(operationValue);
        int jobId = std::get<int>(jobIdValue);
        std::string printerNameUtf8 = std::get<std::string>(printerNameValue);
        std::wstring printerName(printerNameUtf8.begin(), printerNameUtf8.end());
        HANDLE hPrinter = NULL;
        if (!OpenPrinter(const_cast<LPWSTR>(printerName.c_str()), &hPrinter, NULL)) {
            (*result)->Success(false);
            return;  // Failed to open printer
        }
        bool rs = SetJob(hPrinter, jobId, 0, NULL, operation);
        ClosePrinter(hPrinter);
        (*result)->Success(rs);


    } else if(call.method_name().compare("change_mode") == 0) {
        const TCHAR* command = _T("rundll32.exe");
        const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(
                call.arguments());
        auto commandValue = (argsList->find(flutter::EncodableValue("command")))->second;
        std::string commandUtf8 = std::get<std::string>(commandValue);
        std::wstring commandW(commandUtf8.begin(), commandUtf8.end());
        const TCHAR* parameters = commandW.c_str();
        // Execute the command as an administrator
        SHELLEXECUTEINFO sei = { sizeof(SHELLEXECUTEINFO) };
        sei.lpVerb = _T("runas");               // Run as administrator
        sei.lpFile = command;                   // The program to execute
        sei.lpParameters = parameters;          // The parameters for the program
        sei.nShow = SW_SHOWNORMAL;              // Show the window

        std::cout << commandUtf8 << std::endl;
        if (ShellExecuteEx(&sei)) {
            (*result)->Success(true);
        } else {
            (*result)->Success(false);
        }

    }else {
        (*result)->NotImplemented();
    }
}


FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());
    const static std::string channel_name("printer_utils");
    flutter::BinaryMessenger *messenger = flutter_controller_->engine()->messenger();
    const flutter::StandardMethodCodec *codec = &flutter::StandardMethodCodec::GetInstance();
    auto channel = std::make_unique<flutter::MethodChannel<>>(messenger, channel_name, codec);

    channel->SetMethodCallHandler(
            [&](const flutter::MethodCall<> &call,
                std::unique_ptr <flutter::MethodResult<>> result) {
                methodHandlers(call, &result);
            }
    );
  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
