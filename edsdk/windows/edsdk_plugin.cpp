#include "edsdk_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <wincodec.h>

#include <algorithm>
#include <cctype>
#include <memory>
#include <sstream>

namespace edsdk {
    flutter::TextureRegistrar *texture_registrar_ = NULL;
    std::unique_ptr <flutter::MethodChannel<>> callBackChannel;
    std::vector <EdsDirectoryItemRef> images;
    std::string baseImgPath;
    std::vector <string> files;
    std::vector <string> videos;

    void ReleaseIfNotNull(IUnknown *value) {
        if (value != nullptr) {
            value->Release();
        }
    }

    bool DecodeJpegToRgba(const std::vector<uint8_t> &jpeg,
                          std::vector<uint8_t> &pixels,
                          UINT &width,
                          UINT &height) {
        if (jpeg.empty()) {
            return false;
        }

        HRESULT coInit = CoInitializeEx(nullptr, COINIT_MULTITHREADED);
        const bool didInitCom = SUCCEEDED(coInit);
        if (FAILED(coInit) && coInit != RPC_E_CHANGED_MODE) {
            return false;
        }

        IWICImagingFactory *factory = nullptr;
        IWICStream *stream = nullptr;
        IWICBitmapDecoder *decoder = nullptr;
        IWICBitmapFrameDecode *frame = nullptr;
        IWICFormatConverter *converter = nullptr;

        HRESULT hr = CoCreateInstance(
                CLSID_WICImagingFactory,
                nullptr,
                CLSCTX_INPROC_SERVER,
                IID_PPV_ARGS(&factory));
        if (SUCCEEDED(hr)) {
            hr = factory->CreateStream(&stream);
        }
        if (SUCCEEDED(hr)) {
            hr = stream->InitializeFromMemory(
                    const_cast<BYTE *>(reinterpret_cast<const BYTE *>(jpeg.data())),
                    static_cast<DWORD>(jpeg.size()));
        }
        if (SUCCEEDED(hr)) {
            hr = factory->CreateDecoderFromStream(
                    stream,
                    nullptr,
                    WICDecodeMetadataCacheOnDemand,
                    &decoder);
        }
        if (SUCCEEDED(hr)) {
            hr = decoder->GetFrame(0, &frame);
        }
        if (SUCCEEDED(hr)) {
            hr = frame->GetSize(&width, &height);
        }
        if (SUCCEEDED(hr)) {
            hr = factory->CreateFormatConverter(&converter);
        }
        if (SUCCEEDED(hr)) {
            hr = converter->Initialize(
                    frame,
                    GUID_WICPixelFormat32bppRGBA,
                    WICBitmapDitherTypeNone,
                    nullptr,
                    0.0,
                    WICBitmapPaletteTypeMedianCut);
        }
        if (SUCCEEDED(hr)) {
            const UINT stride = width * 4;
            const UINT bufferSize = stride * height;
            pixels.resize(bufferSize);
            hr = converter->CopyPixels(
                    nullptr,
                    stride,
                    bufferSize,
                    pixels.data());
        }

        ReleaseIfNotNull(converter);
        ReleaseIfNotNull(frame);
        ReleaseIfNotNull(decoder);
        ReleaseIfNotNull(stream);
        ReleaseIfNotNull(factory);
        if (didInitCom) {
            CoUninitialize();
        }

        return SUCCEEDED(hr) && width > 0 && height > 0 && !pixels.empty();
    }

    EdsError EDSCALLBACK
    handleObjectEvent(EdsObjectEvent
    event,
    EdsBaseRef object, EdsVoid
    *context) {
    EdsError err = EDS_ERR_OK;
    if( event == kEdsObjectEvent_DirItemRequestTransfer || event == kEdsObjectEvent_DirItemCancelTransferDT) {
        cout << "PRINT" << endl;
    EdsDirectoryItemRef dirItem = (EdsDirectoryItemRef) object;
    EdsDirectoryItemInfo dirItemInfo;
    err = EdsGetDirectoryItemInfo(dirItem, &dirItemInfo);
    if (err == EDS_ERR_OK) {
    EdsStreamRef stream;
    std::string path =
            baseImgPath + std::string("\\") + std::string(dirItemInfo.szFileName);
    err = EdsCreateFileStream(path.c_str(), kEdsFileCreateDisposition_CreateAlways,
                              kEdsAccess_ReadWrite, &stream);
    if (err == EDS_ERR_OK) {
    // Download the video to the file
    err = EdsDownload(dirItem, dirItemInfo.size, stream);
    if (err == EDS_ERR_OK) {
    err = EdsDownloadComplete(dirItem);
    std::string fileName = std::string(dirItemInfo.szFileName);
    std::string lowerFileName = fileName;
    std::transform(lowerFileName.begin(), lowerFileName.end(), lowerFileName.begin(),
                   [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
    const bool isVideo =
            lowerFileName.rfind(".mp4") != std::string::npos ||
            lowerFileName.rfind(".mov") != std::string::npos;
    callBackChannel->InvokeMethod(isVideo ? "video_created" : "file_created",
    std::make_unique<flutter::EncodableValue>(path)
    );
}
EdsRelease(stream);
}
}
EdsRelease(dirItem);
}
return
err;
}

// static
void EdsdkPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarWindows *registrar) {
    auto channel =
            std::make_unique < flutter::MethodChannel < flutter::EncodableValue >> (
                    registrar->messenger(), "edsdk",
                            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<EdsdkPlugin>();

    channel->SetMethodCallHandler(
            [plugin_pointer = plugin.get()](const auto &call, auto result) {
                plugin_pointer->HandleMethodCall(call, std::move(result));
            });

    callBackChannel = std::make_unique < flutter::MethodChannel < flutter::EncodableValue >> (
            registrar->messenger(), "callback",
                    &flutter::StandardMethodCodec::GetInstance());
    texture_registrar_ = registrar->texture_registrar();
    registrar->AddPlugin(std::move(plugin));
    char path[MAX_PATH];

    // Get the path to the Pictures folder
    if (SHGetFolderPathA(NULL, CSIDL_MYPICTURES, NULL, 0, path) == S_OK) {
        std::cout << "Pictures folder path: " << path << std::endl;
        baseImgPath = std::string(path);
    }
}

EdsdkPlugin::EdsdkPlugin() {
    flutterEdsdk = std::make_unique<FlutterEdsdk>();

    // Buffer to receive the path
    char path[MAX_PATH];
    // Get the path to the Pictures folder
    if (SHGetFolderPathA(NULL, CSIDL_MYVIDEO, NULL, 0, path) == S_OK) {
        std::cout << "Videos folder path: " << path << std::endl;
        baseVidPath = std::string(path);
    }
}

EdsdkPlugin::~EdsdkPlugin() {}

void EdsdkPlugin::HandleMethodCall(
        const flutter::MethodCall <flutter::EncodableValue> &method_call,
        std::unique_ptr <flutter::MethodResult<flutter::EncodableValue>> result) {
    if (method_call.method_name().compare("init_sdk") == 0) {
        edsdkOutlet = std::make_unique<EDSDKOutlet>(texture_registrar_);
        result->Success(flutterEdsdk->initializeEdsdk());
    } else if (method_call.method_name().compare("terminate_sdk") == 0) {
        result->Success(flutterEdsdk->terminateEdsdk());
    } else if (method_call.method_name().compare("list_camera") == 0) {
        std::vector <CameraModel> models = flutterEdsdk->getCameraList();
        result->Success(flutter::EncodableValue(ListToJson(models)));
    } else if (method_call.method_name().compare("init_camera") == 0) {
        const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(
                method_call.arguments());
        auto indexValue = (argsList->find(flutter::EncodableValue("index")))->second;
        int32_t index = std::get<int32_t>(indexValue);

        auto err = flutterEdsdk->getChildAtIndex(index);

        if (!err) {
            result->Error("", "Can't get child at index");
            return;
        }

        err = flutterEdsdk->addEvent(handleObjectEvent);

        if (!err) {
            result->Error("", "Can't add event to camera");
            return;
        }

        err = flutterEdsdk->enableAspectRatio();

        if (!err) {
            result->Error("", "Can't enable custom aspect ratio");
            return;
        }

        edsdkOutlet = std::make_unique<EDSDKOutlet>(texture_registrar_);

        result->Success(flutter::EncodableValue(edsdkOutlet->texture_id()));
    } else if (method_call.method_name().compare("set_aspect_ratio") == 0) {
        const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(
                method_call.arguments());
        auto aspectRatioValue = (argsList->find(flutter::EncodableValue("aspect_ratio")))->second;
        int32_t aspectRatio = std::get<int32_t>(aspectRatioValue);
        auto err = flutterEdsdk->setAspectRatio(aspectRatio);
        if (!err) {
            cout << "Can't set aspect ratio" << endl;
        }
        result->Success();

    } else if (method_call.method_name().compare("open_session") == 0) {
        bool err = flutterEdsdk->openSession();
        if (!err) {
            result->Error("", "Can't open session camera");
            return;
        }
        result->Success(flutter::EncodableValue(err));
    } else if (method_call.method_name().compare("close_session") == 0) {
        result->Success(flutterEdsdk->closeSession());
    } else if (method_call.method_name().compare("start_preview") == 0) {
        result->Success(flutter::EncodableValue(flutterEdsdk->startLivePreview()));
    } else if (method_call.method_name().compare("stop_preview") == 0) {
        result->Success(flutter::EncodableValue(flutterEdsdk->stopLivePreview()));
    } else if (method_call.method_name().compare("download_evf") == 0) {
        char tempPath[MAX_PATH];
        if (GetTempPathA(MAX_PATH, tempPath) == 0) {
            result->Success(flutter::EncodableValue(""));
            return;
        }
        std::string fileName = "project_l_canon_evf.jpg";
        const flutter::EncodableMap *argsList = std::get_if<flutter::EncodableMap>(
                method_call.arguments());
        if (argsList != nullptr) {
            auto fileNameValue = argsList->find(flutter::EncodableValue("file_name"));
            if (fileNameValue != argsList->end() &&
                !fileNameValue->second.IsNull() &&
                std::holds_alternative<std::string>(fileNameValue->second)) {
                fileName = std::get<std::string>(fileNameValue->second);
            }
        }
        std::string outputPath = std::string(tempPath) + fileName;
        result->Success(flutter::EncodableValue(flutterEdsdk->downloadEvfImage(outputPath)));
    } else if (method_call.method_name().compare("download_evf_bytes") == 0) {
        result->Success(flutter::EncodableValue(flutterEdsdk->downloadEvfBytes()));
    } else if (method_call.method_name().compare("download_evf_texture") == 0) {
        if (!edsdkOutlet) {
            result->Success(flutter::EncodableValue(false));
            return;
        }
        const auto jpeg = flutterEdsdk->downloadEvfBytes();
        UINT width = 0;
        UINT height = 0;
        std::vector<uint8_t> decodedPixels;
        if (!DecodeJpegToRgba(jpeg, decodedPixels, width, height)) {
            result->Success(flutter::EncodableValue(false));
            return;
        }
        previewBuffer = std::move(decodedPixels);
        edsdkOutlet->MarkEDSDKFrameAvailable(
                previewBuffer.data(),
                static_cast<int32_t>(width),
                static_cast<int32_t>(height));
        result->Success(flutter::EncodableValue(true));
    } else if (method_call.method_name().compare("start_record") == 0) {
        result->Success(flutter::EncodableValue(flutterEdsdk->startRecord()));
    } else if (method_call.method_name().compare("stop_record") == 0) {
        result->Success(flutter::EncodableValue(flutterEdsdk->stopRecord()));
    } else if (method_call.method_name().compare("shoot") == 0) {
        bool rs  = flutterEdsdk->shoot();
        result->Success(flutter::EncodableValue(rs));
    } else if (method_call.method_name().compare("clear_mem") == 0) {
        result->Success(flutter::EncodableValue(flutterEdsdk->clearMem()));
    } else if (method_call.method_name().compare("save_to_host") == 0) {
        bool err = flutterEdsdk->saveToHost();
        if (!err) {
            result->Error("", "Can't save to host");
            return;
        }
        result->Success();
    } else {
        result->NotImplemented();
    }
}


}  // namespace edsdk
