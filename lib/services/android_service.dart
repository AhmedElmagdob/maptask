import 'dart:io';

class AndroidService {
  static Future<void> configureGoogleMaps(String filePath) async {
    final manifest = File('$filePath/android/app/src/main/AndroidManifest.xml');
    final content = await manifest.readAsString();

    if (!content.contains('com.google.android.geo.API_KEY')) {
      final updatedContent = content.replaceFirst(
        '<application',
        '''<application
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_ANDROID_API_KEY"/>
        <application''',
      );
      await manifest.writeAsString(updatedContent);
    }
  }

  static Future<void> updateMinSdkVersion(String filePath,int version) async {
    final buildGradle = File('$filePath/android/app/build.gradle');
    final content = await buildGradle.readAsString();
    final updatedContent = content.replaceFirst(
      'minSdkVersion flutter.minSdkVersion',
      'minSdkVersion $version',
    );
    await buildGradle.writeAsString(updatedContent);
  }
  static Future<void> updateApiKey(String projectPath, String key) async {
    final manifest = File('$projectPath/android/app/src/main/AndroidManifest.xml');
    final content = await manifest.readAsString();

    final updated = content.replaceAll(
      'android:value="YOUR_ANDROID_API_KEY"',
      'android:value="Ahmed Ahgmed"',
    );

    await manifest.writeAsString(updated);
    print( "doneupdateApiKey");
  }

}
