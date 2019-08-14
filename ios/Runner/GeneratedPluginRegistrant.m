//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <downloads_path_provider/DownloadsPathProviderPlugin.h>
#import <file_picker/FilePickerPlugin.h>
#import <fluttertoast/FluttertoastPlugin.h>
#import <image_picker/ImagePickerPlugin.h>
#import <path_provider/PathProviderPlugin.h>
#import <permission_handler/PermissionHandlerPlugin.h>
#import <url_launcher/UrlLauncherPlugin.h>
#import <wc_flutter_share/WcFlutterSharePlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [DownloadsPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"DownloadsPathProviderPlugin"]];
  [FilePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FilePickerPlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
  [WcFlutterSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"WcFlutterSharePlugin"]];
}

@end
