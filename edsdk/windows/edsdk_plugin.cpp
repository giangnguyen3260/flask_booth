#include "edsdk_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace edsdk {
    flutter::TextureRegistrar *texture_registrar_ = NULL;
    std::unique_ptr <flutter::MethodChannel<>> callBackChannel;
    std::vector <EdsDirectoryItemRef> images;
    std::string baseImgPath;
    std::vector <string> files;
    std::vector <string> videos;

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
    callBackChannel->InvokeMethod("file_created",
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
