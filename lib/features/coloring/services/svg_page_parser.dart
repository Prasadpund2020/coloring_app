import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

import '../../../core/utils/result.dart';
import '../models/coloring_page.dart';

class SvgPageParser {
  Result<ColoringPage> parse(
    String svg, {
    required String pageId,
    required String category,
  }) {
    if (svg.trim().isEmpty) {
      return const Result<ColoringPage>.failure('Page is empty');
    }
    try {
      final XmlElement root = XmlDocument.parse(svg).rootElement;
      if (root.name.local != 'svg') {
        return const Result<ColoringPage>.failure('Root element must be svg');
      }
      final String? viewBoxText = root.getAttribute('viewBox');
      final List<double>? viewBox = _parseViewBox(viewBoxText);
      if (viewBox == null ||
          viewBox[0] != 0 ||
          viewBox[1] != 0 ||
          viewBox[2] != 1000 ||
          viewBox[3] != 1000) {
        return const Result<ColoringPage>.failure(
          'A positive viewBox with four numbers is required',
        );
      }
      _rejectForbidden(root);
      final XmlElement? regionsGroup = _findGroup(root, 'regions');
      final XmlElement? outlinesGroup = _findGroup(root, 'outlines');
      if (regionsGroup == null || outlinesGroup == null) {
        return const Result<ColoringPage>.failure(
          'Both regions and outlines groups are required',
        );
      }
      final Set<String> ids = <String>{};
      final List<ColoringRegion> regions = <ColoringRegion>[];
      for (final XmlElement element in regionsGroup.childElements) {
        if (element.name.local != 'path') {
          return const Result<ColoringPage>.failure(
            'Only path elements are allowed in regions',
          );
        }
        final String? id = element.getAttribute('id');
        final String? data = element.getAttribute('d');
        if (id == null || id.isEmpty) {
          return const Result<ColoringPage>.failure(
            'Every region path needs an id',
          );
        }
        if (!ids.add(id)) {
          return Result<ColoringPage>.failure('Duplicate region id: $id');
        }
        if (data == null ||
            !data.trim().endsWith('Z') ||
            RegExp(r'[a-df-qs-uw-z]').hasMatch(data)) {
          return Result<ColoringPage>.failure(
            'Region $id must be a closed path',
          );
        }
        regions.add(ColoringRegion(id: id, path: parseSvgPathData(data)));
      }
      if (regions.isEmpty || regions.length > 25) {
        return const Result<ColoringPage>.failure(
          'A page must contain 1 to 25 regions',
        );
      }
      final List<Path> outlines = <Path>[];
      for (final XmlElement element in outlinesGroup.childElements) {
        if (element.name.local != 'path') {
          return const Result<ColoringPage>.failure(
            'Only path elements are allowed in outlines',
          );
        }
        final String? data = element.getAttribute('d');
        if (data == null || data.trim().isEmpty) {
          return const Result<ColoringPage>.failure(
            'Every outline needs path data',
          );
        }
        outlines.add(parseSvgPathData(data));
      }
      if (outlines.isEmpty) {
        return const Result<ColoringPage>.failure(
          'At least one outline is required',
        );
      }
      return Result<ColoringPage>.success(
        ColoringPage(
          id: pageId,
          category: category,
          viewBox: Size(viewBox[2], viewBox[3]),
          regions: List<ColoringRegion>.unmodifiable(regions),
          outlines: List<Path>.unmodifiable(outlines),
        ),
      );
    } on XmlException catch (error) {
      return Result<ColoringPage>.failure('Invalid XML: $error');
    } on FormatException catch (error) {
      return Result<ColoringPage>.failure('Invalid path data: $error');
    }
  }

  static List<double>? _parseViewBox(String? value) {
    if (value == null) {
      return null;
    }
    final List<double> values = value
        .trim()
        .split(RegExp(r'[\s,]+'))
        .map(double.tryParse)
        .whereType<double>()
        .toList();
    return values.length == 4 ? values : null;
  }

  static XmlElement? _findGroup(XmlElement root, String id) {
    return root.descendants
        .whereType<XmlElement>()
        .where(
          (XmlElement element) =>
              element.name.local == 'g' && element.getAttribute('id') == id,
        )
        .firstOrNull;
  }

  static void _rejectForbidden(XmlElement root) {
    const Set<String> forbidden = <String>{
      'text',
      'image',
      'linearGradient',
      'radialGradient',
      'filter',
      'clipPath',
      'style',
      'defs',
    };
    for (final XmlElement element in root.descendants.whereType<XmlElement>()) {
      if (forbidden.contains(element.name.local) ||
          element.getAttribute('transform') != null ||
          element.getAttribute('class') != null) {
        throw const FormatException('Forbidden SVG element or attribute');
      }
    }
  }
}
