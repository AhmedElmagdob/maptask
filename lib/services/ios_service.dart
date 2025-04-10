import 'dart:io';

class IOSService {
  static Future<void> addAPIKeyToAppDelegate(String filePath) async {
    final file = File('$filePath/ios/Runner/AppDelegate.swift');
    final content = await file.readAsString();

    if (!content.contains('GMSServices.provideAPIKey')) {
      final updatedContent = content.replaceFirst(
        'GeneratedPluginRegistrant.register(with: self)',
        '''GeneratedPluginRegistrant.register(with: self)
        GMSServices.provideAPIKey("YOUR_IOS_API_KEY")''',
      );
      await file.writeAsString(updatedContent);
    }
  }

  static Future<void> addLocationPermissionToInfoPlist(String filePath) async {
    final file = File('$filePath/ios/Runner/Info.plist');
    final content = await file.readAsString();

    if (!content.contains('NSLocationWhenInUseUsageDescription')) {
      final updatedContent = content.replaceFirst(
        '</dict>',
        '''<key>NSLocationWhenInUseUsageDescription</key>
        <string>This app needs location access for Google Maps</string>
        </dict>''',
      );
      await file.writeAsString(updatedContent);
    }
  }
  static Future<void> updateApiKey(String projectPath, String key) async {
    final file = File('$projectPath/ios/Runner/Info.plist');
    final content = await file.readAsString();

    final updated = content.replaceAll(
      'GMSServices.provideAPIKey("YOUR_IOS_API_KEY")',
      'GMSServices.provideAPIKey("$key")',
    );

    await file.writeAsString(updated);
  }
}