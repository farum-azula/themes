import 'dart:io';

import 'package:spring_boot_starter_flutter/spring_boot_starter_flutter.dart';
import 'package:yaml/yaml.dart';

/// The theme file `themes/<name>.yml` of this repository as the starter
/// reads it: its `spring.flutter.theme` keys, flat.
SpringThemes themeFile(String name) {
  final yaml = loadYaml(File('../themes/$name.yml').readAsStringSync());
  final theme = (yaml as Map)['spring']['flutter']['theme'];
  final flat = <String, String>{};
  void walk(Object? node, String path) {
    switch (node) {
      case Map():
        for (final MapEntry(:key, :value) in node.entries) {
          walk(value, path.isEmpty ? '$key' : '$path.$key');
        }
      case List():
        for (final (i, value) in node.indexed) {
          walk(value, '$path.$i');
        }
      default:
        flat[path] = '$node';
    }
  }

  walk(theme, '');
  return SpringThemes(flat);
}
