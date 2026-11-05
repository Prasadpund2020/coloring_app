import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/result.dart';
import '../models/artwork.dart';

class ArtworkRepository {
  ArtworkRepository({required this.rootDirectory});

  final Directory rootDirectory;
  static const Uuid _uuid = Uuid();

  static Future<ArtworkRepository> createDefault() async {
    final Directory documents = await getApplicationDocumentsDirectory();
    final Directory artwork = Directory('${documents.path}\\artwork');
    await artwork.create(recursive: true);
    return ArtworkRepository(rootDirectory: artwork);
  }

  Future<Result<List<Artwork>>> list() async {
    try {
      if (!await rootDirectory.exists()) {
        return const Result<List<Artwork>>.success(<Artwork>[]);
      }
      final List<Artwork> artworks = <Artwork>[];
      await for (final FileSystemEntity entity in rootDirectory.list()) {
        if (entity is! Directory) {
          continue;
        }
        final File file = File('${entity.path}\\artwork.json');
        if (!await file.exists()) {
          continue;
        }
        try {
          artworks.add(
            Artwork.fromJson(
              Map<String, Object?>.from(
                jsonDecode(await file.readAsString()) as Map,
              ),
            ),
          );
        } on FormatException {
          continue;
        } on TypeError {
          continue;
        }
      }
      artworks.sort(
        (Artwork a, Artwork b) => b.updatedAt.compareTo(a.updatedAt),
      );
      return Result<List<Artwork>>.success(artworks);
    } on FileSystemException catch (error) {
      return Result<List<Artwork>>.failure('Could not read artwork: $error');
    }
  }

  Future<Result<Artwork>> load(String id) async {
    final File file = File('${rootDirectory.path}\\$id\\artwork.json');
    try {
      final Map<String, Object?> json = Map<String, Object?>.from(
        jsonDecode(await file.readAsString()) as Map,
      );
      return Result<Artwork>.success(Artwork.fromJson(json));
    } on FileSystemException catch (error) {
      return Result<Artwork>.failure('Could not open artwork: $error');
    } on FormatException catch (error) {
      return Result<Artwork>.failure('Could not open artwork: $error');
    } on TypeError catch (error) {
      return Result<Artwork>.failure('Could not open artwork: $error');
    }
  }

  Future<Result<Artwork>> save(
    Artwork artwork, {
    List<int>? thumbnail,
    List<int>? preview,
  }) async {
    final String id = artwork.id.isEmpty ? _uuid.v4() : artwork.id;
    final Artwork saved = Artwork(
      id: id,
      type: artwork.type,
      title: artwork.title,
      createdAt: artwork.createdAt,
      updatedAt: DateTime.now().toUtc(),
      payload: artwork.payload,
    );
    final Directory folder = Directory('${rootDirectory.path}\\$id');
    try {
      await folder.create(recursive: true);
      await _atomicWrite(
        File('${folder.path}\\artwork.json'),
        saved.encode().codeUnits,
      );
      if (thumbnail != null) {
        await _atomicWrite(File('${folder.path}\\thumbnail.png'), thumbnail);
      }
      if (preview != null) {
        await _atomicWrite(File('${folder.path}\\preview.png'), preview);
      }
      return Result<Artwork>.success(saved);
    } on FileSystemException catch (error) {
      return Result<Artwork>.failure('Could not save artwork: $error');
    }
  }

  Future<Result<void>> delete(String id) async {
    try {
      final Directory folder = Directory('${rootDirectory.path}\\$id');
      if (await folder.exists()) {
        await folder.delete(recursive: true);
      }
      return const Result<void>.success(null);
    } on FileSystemException catch (error) {
      return Result<void>.failure('Could not delete artwork: $error');
    }
  }

  Future<void> _atomicWrite(File file, List<int> bytes) async {
    final File temporary = File('${file.path}.tmp');
    final RandomAccessFile handle = await temporary.open(mode: FileMode.write);
    try {
      await handle.writeFrom(bytes);
      await handle.flush();
    } finally {
      await handle.close();
    }
    await temporary.rename(file.path);
  }
}
