import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/design_constants.dart';
import '../models/artwork.dart';
import '../services/artwork_repository.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<ArtworkRepository> _repository;
  Future<List<Artwork>>? _artworks;
  Directory? _artworkDirectory;

  @override
  void initState() {
    super.initState();
    _repository = ArtworkRepository.createDefault();
    _artworks = _load();
  }

  Future<List<Artwork>> _load() async {
    final ArtworkRepository repository = await _repository;
    _artworkDirectory = repository.rootDirectory;
    final result = await repository.list();
    return result.value ?? <Artwork>[];
  }

  Future<void> _delete(Artwork artwork) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Delete artwork?'),
        content: const Text('This picture will be removed.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final ArtworkRepository repository = await _repository;
      await repository.delete(artwork.id);
      if (mounted) {
        setState(() => _artworks = _load());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Artwork')),
      body: FutureBuilder<List<Artwork>>(
        future: _artworks,
        builder: (BuildContext context, AsyncSnapshot<List<Artwork>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<Artwork> artworks = snapshot.data!;
          if (artworks.isEmpty) {
            return const Center(child: Text('Your pictures will appear here!'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(DesignConstants.pagePadding),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisExtent: 230,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: artworks.length,
            itemBuilder: (BuildContext context, int index) {
              final Artwork artwork = artworks[index];
              return Card(
                child: InkWell(
                  onLongPress: () => _delete(artwork),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: <Widget>[
                        Expanded(child: _thumbnail(artwork)),
                        Text(artwork.title),
                        Text(DateFormat.yMMMd().format(artwork.updatedAt)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _thumbnail(Artwork artwork) {
    final Directory? directory = _artworkDirectory;
    if (directory == null) {
      return const Icon(Icons.image, size: 72);
    }
    return Image.file(
      File('${directory.path}/${artwork.id}/thumbnail.png'),
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) => const Icon(Icons.image, size: 72),
      fit: BoxFit.contain,
    );
  }
}
