import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class PubSpecService {
  static Future<void> addPackage(String packageName,String filePath) async {
    final pubspecFile = File('$filePath/pubspec.yaml');
    final content = await pubspecFile.readAsString();
    final yamlEditor = YamlEditor(content);

    yamlEditor.update(['dependencies', packageName], '^latest');
    await pubspecFile.writeAsString(yamlEditor.toString());
  }
}