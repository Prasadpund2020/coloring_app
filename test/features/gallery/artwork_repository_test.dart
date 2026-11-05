import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:little_doodle/features/gallery/models/artwork.dart';
import 'package:little_doodle/features/gallery/services/artwork_repository.dart';

void main() {
  late Directory directory;
  late ArtworkRepository repository;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('little_doodle_artwork_');
    repository = ArtworkRepository(rootDirectory: directory);
  });

  tearDown(() {
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  });

  Artwork artwork(String id) {
    final DateTime date = DateTime.utc(2026, 1, 1);
    return Artwork(
      id: id,
      type: ArtworkType.drawing,
      title: 'Test',
      createdAt: date,
      updatedAt: date,
      payload: const <String, Object?>{'strokes': <Object?>[]},
    );
  }

  test('saves, lists, loads and deletes artwork files', () async {
    final result = await repository.save(
      artwork('one'),
      thumbnail: <int>[1, 2],
      preview: <int>[3, 4],
    );
    expect(result.isSuccess, isTrue);
    expect(
      await repository.list().then((result) => result.value),
      hasLength(1),
    );
    expect((await repository.load('one')).isSuccess, isTrue);
    expect(
      await repository.delete('one').then((result) => result.isSuccess),
      isTrue,
    );
    expect(await repository.list().then((result) => result.value), isEmpty);
  });

  test('skips corrupt JSON and reports missing loads', () async {
    final folder = Directory('${directory.path}\\bad')..createSync();
    File('${folder.path}\\artwork.json').writeAsStringSync('{broken');
    expect(await repository.list().then((result) => result.value), isEmpty);
    expect((await repository.load('missing')).isSuccess, isFalse);
  });

  test('unknown optional fields are ignored', () async {
    final folder = Directory('${directory.path}\\one')..createSync();
    File('${folder.path}\\artwork.json').writeAsStringSync(
      '${artwork('one').encode().substring(0, artwork('one').encode().length - 1)},'
      '"unknown": true}',
    );
    expect((await repository.load('one')).isSuccess, isTrue);
  });
}
