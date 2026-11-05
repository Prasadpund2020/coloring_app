import 'dart:io';

import 'package:xml/xml.dart';

const Set<String> forbiddenElements = <String>{
  'text',
  'image',
  'linearGradient',
  'radialGradient',
  'filter',
  'clipPath',
  'style',
  'defs',
};

void main() {
  final Directory directory = Directory('assets/coloring');
  final List<File> files = directory
      .listSync()
      .whereType<File>()
      .where((File file) => file.path.toLowerCase().endsWith('.svg'))
      .toList();
  final List<String> errors = <String>[];
  final Map<String, String> allIds = <String, String>{};

  for (final File file in files) {
    try {
      if (file.lengthSync() >= 100 * 1024) {
        errors.add('${file.path}: file must be under 100 KB');
      }
      final XmlElement root = XmlDocument.parse(file.readAsStringSync())
          .rootElement;
      final String? viewBox = root.getAttribute('viewBox');
      if (viewBox != '0 0 1000 1000') {
        errors.add('${file.path}: viewBox must be 0 0 1000 1000');
      }
      final Set<String> groups = root.childElements
          .where((XmlElement element) => element.name.local == 'g')
          .map((XmlElement element) => element.getAttribute('id'))
          .whereType<String>()
          .toSet();
      if (!groups.contains('regions') || !groups.contains('outlines')) {
        errors.add('${file.path}: regions and outlines groups are required');
      }
      for (final XmlElement element
          in root.descendants.whereType<XmlElement>()) {
        if (forbiddenElements.contains(element.name.local) ||
            element.getAttribute('transform') != null ||
            element.getAttribute('class') != null) {
          errors.add('${file.path}: forbidden element or attribute');
        }
      }
      final XmlElement? regions = root.childElements
          .where(
            (XmlElement element) => element.getAttribute('id') == 'regions',
          )
          .firstOrNull;
      for (final XmlElement path in regions?.childElements ?? <XmlElement>[]) {
        final String? id = path.getAttribute('id');
        final String? data = path.getAttribute('d');
        if (path.name.local != 'path' || id == null || id.isEmpty) {
          errors.add('${file.path}: every region must be a named path');
          continue;
        }
        if (data == null || !data.trim().toUpperCase().endsWith('Z')) {
          errors.add('${file.path}: region $id must be closed');
        }
        if (allIds.containsKey(id)) {
          errors.add(
            '${file.path}: duplicate project id $id (also in ${allIds[id]})',
          );
        } else {
          allIds[id] = file.path;
        }
      }
    } on XmlException catch (error) {
      errors.add('${file.path}: invalid XML: $error');
    } on FileSystemException catch (error) {
      errors.add('${file.path}: cannot read file: $error');
    }
  }

  if (errors.isEmpty) {
    stdout.writeln(
      'Validated ${files.length} coloring SVG assets successfully.',
    );
    return;
  }
  stderr
    ..writeln('Coloring asset validation failed:')
    ..writeAll(errors.map((String error) => '- $error\n'));
  exitCode = 1;
}
