import 'dart:ui';

class Sticker {
  const Sticker({
    required this.id,
    required this.assetId,
    required this.center,
    required this.scale,
  });

  final String id;
  final String assetId;
  final Offset center;
  final double scale;

  Sticker copyWith({Offset? center, double? scale}) {
    return Sticker(
      id: id,
      assetId: assetId,
      center: center ?? this.center,
      scale: scale ?? this.scale,
    );
  }
}
