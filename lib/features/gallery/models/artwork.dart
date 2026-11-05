import 'dart:convert';
import 'dart:ui';

enum ArtworkType { drawing, coloring }

class Artwork {
  const Artwork({
    required this.id,
    required this.type,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.payload,
  });

  final String id;
  final ArtworkType type;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, Object?> payload;

  Map<String, Object?> toJson() => <String, Object?>{
    'schemaVersion': 1,
    'id': id,
    'type': type.name,
    'title': title,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
    'payload': payload,
  };

  static Artwork fromJson(Map<String, Object?> json) {
    final Map<String, Object?> payload = Map<String, Object?>.from(
      json['payload'] as Map? ?? <String, Object?>{},
    );
    return Artwork(
      id: json['id'] as String,
      type: ArtworkType.values.byName(json['type'] as String),
      title: json['title'] as String? ?? 'My artwork',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      payload: payload,
    );
  }

  String encode() => jsonEncode(toJson());
}

Map<String, Object?> strokeToJson({
  required List<Offset> points,
  required Color color,
  required double width,
  required String type,
}) {
  return <String, Object?>{
    'points': points
        .map((Offset point) => <double>[point.dx, point.dy])
        .toList(),
    'color': color.toARGB32(),
    'width': width,
    'type': type,
  };
}
