import 'package:flutter_test/flutter_test.dart';
import 'package:little_doodle/features/coloring/services/svg_page_parser.dart';

const String validSvg = '''
<svg viewBox="0 0 1000 1000">
<g id="regions"><path id="one" d="M0 0 L500 0 L500 500 Z"/></g>
<g id="outlines"><path d="M0 0 L500 0 L500 500 Z"/></g>
</svg>
''';

void main() {
  final SvgPageParser parser = SvgPageParser();

  test('parses a valid page', () {
    final result = parser.parse(validSvg, pageId: 'test', category: 'Shapes');
    expect(result.isSuccess, isTrue);
    expect(result.value?.regions.single.id, 'one');
  });

  test(
    'rejects empty, missing ids, duplicates, open paths and forbidden elements',
    () {
      expect(parser.parse('', pageId: 'x', category: 'x').isSuccess, isFalse);
      expect(
        parser
            .parse(
              validSvg.replaceFirst('id="one"', ''),
              pageId: 'x',
              category: 'x',
            )
            .isSuccess,
        isFalse,
      );
      expect(
        parser
            .parse(
              validSvg.replaceFirst(
                '</g>',
                '<path id="one" d="M0 0 L1 0 L1 1 Z"/></g>',
              ),
              pageId: 'x',
              category: 'x',
            )
            .isSuccess,
        isFalse,
      );
      expect(
        parser
            .parse(validSvg.replaceFirst(' Z', ''), pageId: 'x', category: 'x')
            .isSuccess,
        isFalse,
      );
      expect(
        parser
            .parse(
              validSvg.replaceFirst(
                '<g id="regions">',
                '<defs><g id="regions">',
              ),
              pageId: 'x',
              category: 'x',
            )
            .isSuccess,
        isFalse,
      );
    },
  );
}
