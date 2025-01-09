//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <flutter_localization/flutter_localization_plugin_c_api.h>
#include <screen_retriever_windows/screen_retriever_windows_plugin_c_api.h>
#include <system_tray/system_tray_plugin.h>
#include <window_manager/window_manager_plugin.h>
#include <windows_notification/windows_notification_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  FlutterLocalizationPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterLocalizationPluginCApi"));
  ScreenRetrieverWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverWindowsPluginCApi"));
  SystemTrayPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemTrayPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
  WindowsNotificationPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowsNotificationPluginCApi"));
}
