#include "flutter_window.h"

#include <cstddef>
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

std::wstring Utf8ToWide(const std::string &utf8) {
    if (utf8.empty()) {
        return L"";
    }
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, utf8.data(),
                                          static_cast<int>(utf8.size()),
                                          nullptr, 0);
    if (size_needed <= 0) {
        return std::wstring(utf8.begin(), utf8.end());
    }
    std::wstring wide(size_needed, 0);
    MultiByteToWideChar(CP_UTF8, 0, utf8.data(), static_cast<int>(utf8.size()),
                        wide.data(), size_needed);
    return wide;
}

bool RunPrintUiCommand(const std::string &commandUtf8) {
    const std::wstring parameters = Utf8ToWide(commandUtf8);
    SHELLEXECUTEINFOW sei = { sizeof(SHELLEXECUTEINFOW) };
    sei.fMask = SEE_MASK_NOCLOSEPROCESS;
    sei.lpFile = L"rundll32.exe";
    sei.lpParameters = parameters.c_str();
    sei.nShow = SW_HIDE;

    std::cout << commandUtf8 << std::endl;
    if (!ShellExecuteExW(&sei)) {
        DWORD error = GetLastError();
        std::wcerr << L"PrintUI command failed to launch. Error code: " << error << std::endl;
        return false;
    }
    if (sei.hProcess == NULL) {
        std::wcerr << L"PrintUI command did not return a process handle." << std::endl;
        return false;
    }

    DWORD waitResult = WaitForSingleObject(sei.hProcess, 25000);
    if (waitResult != WAIT_OBJECT_0) {
        std::wcerr << L"PrintUI command did not finish. Wait result: " << waitResult << std::endl;
        TerminateProcess(sei.hProcess, 1);
        CloseHandle(sei.hProcess);
        return false;
    }

    DWORD exitCode = 1;
    if (!GetExitCodeProcess(sei.hProcess, &exitCode)) {
        DWORD error = GetLastError();
        std::wcerr << L"Could not read PrintUI exit code. Error code: " << error << std::endl;
        CloseHandle(sei.hProcess);
        return false;
    }
    CloseHandle(sei.hProcess);
    if (exitCode != 0) {
        std::wcerr << L"PrintUI command exited with code: " << exitCode << std::endl;
        return false;
    }
    return true;
}

std::wstring DevModeDeviceName(const DEVMODEW *devMode) {
    size_t length = 0;
    while (length < CCHDEVICENAME && devMode->dmDeviceName[length] != L'\0') {
        length++;
    }
    return std::wstring(devMode->dmDeviceName, length);
}

std::vector<BYTE> ReadBinaryFile(const std::wstring &filePath) {
    HANDLE file = CreateFileW(filePath.c_str(), GENERIC_READ, FILE_SHARE_READ, NULL,
                              OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (file == INVALID_HANDLE_VALUE) {
        std::wcerr << L"Could not open preset file. Error code: " << GetLastError() << std::endl;
        return {};
    }

    LARGE_INTEGER fileSize;
    if (!GetFileSizeEx(file, &fileSize) || fileSize.QuadPart <= 0 ||
        fileSize.QuadPart > 1024 * 1024) {
        std::wcerr << L"Invalid preset file size." << std::endl;
        CloseHandle(file);
        return {};
    }

    std::vector<BYTE> bytes(static_cast<size_t>(fileSize.QuadPart));
    DWORD bytesRead = 0;
    const BOOL readOk = ReadFile(file, bytes.data(), static_cast<DWORD>(bytes.size()),
                                 &bytesRead, NULL);
    CloseHandle(file);
    if (!readOk || bytesRead != bytes.size()) {
        std::wcerr << L"Could not read preset file. Error code: " << GetLastError() << std::endl;
        return {};
    }
    return bytes;
}

DEVMODEW *FindDevModeInPreset(std::vector<BYTE> &presetBytes,
                              const std::wstring &printerName) {
    for (size_t offset = 0; offset + sizeof(DEVMODEW) <= presetBytes.size(); offset += 2) {
        auto *devMode = reinterpret_cast<DEVMODEW *>(presetBytes.data() + offset);
        const DWORD devModeSize = devMode->dmSize;
        const DWORD totalSize = devModeSize + devMode->dmDriverExtra;
        if (devModeSize < offsetof(DEVMODEW, dmFields) + sizeof(devMode->dmFields) ||
            totalSize < devModeSize ||
            offset + totalSize > presetBytes.size()) {
            continue;
        }
        if (DevModeDeviceName(devMode) != printerName) {
            continue;
        }
        return devMode;
    }
    return nullptr;
}

bool SetPrinterDevModeLevel9(HANDLE hPrinter, DEVMODEW *devMode) {
    PRINTER_INFO_9W info = {0};
    info.pDevMode = devMode;
    if (SetPrinterW(hPrinter, 9, reinterpret_cast<LPBYTE>(&info), 0)) {
        return true;
    }
    std::wcerr << L"SetPrinter level 9 failed. Error code: " << GetLastError() << std::endl;
    return false;
}

bool SetPrinterDevModeLevel2(HANDLE hPrinter, DEVMODEW *devMode) {
    DWORD needed = 0;
    GetPrinterW(hPrinter, 2, NULL, 0, &needed);
    if (needed == 0) {
        std::wcerr << L"Failed to get printer information size. Error code: " << GetLastError()
                   << std::endl;
        return false;
    }

    std::vector<BYTE> printerInfoBytes(needed);
    DWORD returned = 0;
    auto *printerInfo = reinterpret_cast<PRINTER_INFO_2W *>(printerInfoBytes.data());
    if (!GetPrinterW(hPrinter, 2, printerInfoBytes.data(), needed, &returned)) {
        std::wcerr << L"Failed to get printer information. Error code: " << GetLastError()
                   << std::endl;
        return false;
    }

    printerInfo->pDevMode = devMode;
    if (SetPrinterW(hPrinter, 2, printerInfoBytes.data(), 0)) {
        return true;
    }
    std::wcerr << L"SetPrinter level 2 failed. Error code: " << GetLastError() << std::endl;
    return false;
}

bool ApplyPrinterDevModeFromPreset(const std::string &printerNameUtf8,
                                   const std::string &presetPathUtf8) {
    const std::wstring printerName = Utf8ToWide(printerNameUtf8);
    const std::wstring presetPath = Utf8ToWide(presetPathUtf8);
    std::vector<BYTE> presetBytes = ReadBinaryFile(presetPath);
    if (presetBytes.empty()) {
        return false;
    }

    DEVMODEW *devMode = FindDevModeInPreset(presetBytes, printerName);
    if (devMode == nullptr) {
        std::wcerr << L"Could not find DEVMODE for printer in preset." << std::endl;
        return false;
    }

    HANDLE hPrinter = NULL;
    PRINTER_DEFAULTS useDefaults = {NULL, devMode, PRINTER_ACCESS_USE};
    if (!OpenPrinterW(const_cast<LPWSTR>(printerName.c_str()), &hPrinter, &useDefaults)) {
        std::wcerr << L"Failed to open printer for user DEVMODE. Error code: " << GetLastError()
                   << std::endl;
        return false;
    }

    const LONG documentPropertiesResult = DocumentPropertiesW(
            NULL, hPrinter, const_cast<LPWSTR>(printerName.c_str()), devMode, devMode,
            DM_IN_BUFFER | DM_OUT_BUFFER);
    if (documentPropertiesResult < 0) {
        std::wcerr << L"DocumentProperties failed while validating preset DEVMODE." << std::endl;
    }

    const bool userModeChanged = SetPrinterDevModeLevel9(hPrinter, devMode);
    ClosePrinter(hPrinter);

    PRINTER_DEFAULTS adminDefaults = {NULL, devMode, PRINTER_ALL_ACCESS};
    if (!OpenPrinterW(const_cast<LPWSTR>(printerName.c_str()), &hPrinter, &adminDefaults)) {
        std::wcerr << L"Failed to open printer for global DEVMODE. Error code: " << GetLastError()
                   << std::endl;
        return userModeChanged;
    }
    const bool globalModeChanged = SetPrinterDevModeLevel2(hPrinter, devMode);
    ClosePrinter(hPrinter);
    return userModeChanged || globalModeChanged;
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

PrinterStatusInfo GetPrinterDeviceStatus(LPCWSTR printerName) {
    PrinterStatusInfo info = {0, 100, 100}; // default: assume OK
    HANDLE hPrinter;
    PRINTER_DEFAULTS pd = {NULL, NULL, PRINTER_ACCESS_USE};
    if (!OpenPrinter((LPWSTR) printerName, &hPrinter, &pd)) {
        info.paperPercent = -1;
        info.inkPercent = -1;
        return info;
    }
    DWORD needed = 0;
    GetPrinter(hPrinter, 2, NULL, 0, &needed);
    if (needed == 0) {
        ClosePrinter(hPrinter);
        info.paperPercent = -1;
        info.inkPercent = -1;
        return info;
    }
    PRINTER_INFO_2 *pInfo = (PRINTER_INFO_2 *) malloc(needed);
    if (!pInfo) {
        ClosePrinter(hPrinter);
        info.paperPercent = -1;
        info.inkPercent = -1;
        return info;
    }
    DWORD returned = 0;
    if (GetPrinter(hPrinter, 2, (LPBYTE) pInfo, needed, &returned)) {
        info.status = pInfo->Status;
        // Paper: DS-RX1 driver maps paper-out to these flags
        if ((pInfo->Status & PRINTER_STATUS_PAPER_OUT) ||
            (pInfo->Status & PRINTER_STATUS_PAPER_PROBLEM) ||
            (pInfo->Status & PRINTER_STATUS_PAPER_JAM)) {
            info.paperPercent = 0;
        }
        // Ink/ribbon: DS-RX1 driver maps ribbon status to toner flags
        if (pInfo->Status & PRINTER_STATUS_NO_TONER) {
            info.inkPercent = 0;
        } else if (pInfo->Status & PRINTER_STATUS_TONER_LOW) {
            info.inkPercent = 10;
        }
    } else {
        info.paperPercent = -1;
        info.inkPercent = -1;
    }
    free(pInfo);
    ClosePrinter(hPrinter);
    return info;
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
        const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(
                call.arguments());
        auto commandValue = (argsList->find(flutter::EncodableValue("command")))->second;
        std::string commandUtf8 = std::get<std::string>(commandValue);
        auto printerNameIt = argsList->find(flutter::EncodableValue("printer_name"));
        auto presetPathIt = argsList->find(flutter::EncodableValue("preset_path"));
        if (printerNameIt != argsList->end() && presetPathIt != argsList->end()) {
            std::string printerNameUtf8 = std::get<std::string>(printerNameIt->second);
            std::string presetPathUtf8 = std::get<std::string>(presetPathIt->second);
            if (ApplyPrinterDevModeFromPreset(printerNameUtf8, presetPathUtf8)) {
                (*result)->Success(true);
                return;
            }
        }
        (*result)->Success(RunPrintUiCommand(commandUtf8));

    } else if (call.method_name().compare("get_printer_status") == 0) {
        const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(
                call.arguments());
        auto printerNameValue = (argsList->find(flutter::EncodableValue("printer_name")))->second;
        std::string printerNameUtf8 = std::get<std::string>(printerNameValue);
        std::wstring printerName(printerNameUtf8.begin(), printerNameUtf8.end());
        PrinterStatusInfo statusInfo = GetPrinterDeviceStatus(printerName.c_str());
        flutter::EncodableMap statusMap;
        statusMap[flutter::EncodableValue("status")] = flutter::EncodableValue(
                static_cast<int>(statusInfo.status));
        statusMap[flutter::EncodableValue("paperPercent")] = flutter::EncodableValue(
                statusInfo.paperPercent);
        statusMap[flutter::EncodableValue("inkPercent")] = flutter::EncodableValue(
                statusInfo.inkPercent);
        (*result)->Success(flutter::EncodableValue(statusMap));
    } else {
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
