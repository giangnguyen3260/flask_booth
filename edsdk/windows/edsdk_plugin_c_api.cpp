#include "include/edsdk/edsdk_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "edsdk_plugin.h"

void EdsdkPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  edsdk::EdsdkPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
