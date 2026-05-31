#ifndef FLUTTER_PLUGIN_EDSDK_PLUGIN_H_
#define FLUTTER_PLUGIN_EDSDK_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include "edsdk_outlet.h"
#include "flutter_edsdk.h"
#include <shlobj.h>  // For SHGetFolderPath
#include <memory>
#include "utils/object_utils.cpp"
#include "models/xfile.cpp"

namespace edsdk {

    class EdsdkPlugin : public flutter::Plugin {
    public:
        static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

        EdsdkPlugin();

        virtual ~EdsdkPlugin();

        // Disallow copy and assign.
        EdsdkPlugin(const EdsdkPlugin &) = delete;

        EdsdkPlugin &operator=(const EdsdkPlugin &) = delete;

        // Called when a method is called on this plugin's channel from Dart.
        void HandleMethodCall(
                const flutter::MethodCall <flutter::EncodableValue> &method_call,
                std::unique_ptr <flutter::MethodResult<flutter::EncodableValue>> result);

    private:
        bool isStreaming = false;
        std::unique_ptr <EDSDKOutlet> edsdkOutlet;
        std::unique_ptr <FlutterEdsdk> flutterEdsdk;
        std::string baseVidPath;
    };

}  // namespace edsdk

#endif  // FLUTTER_PLUGIN_EDSDK_PLUGIN_H_
