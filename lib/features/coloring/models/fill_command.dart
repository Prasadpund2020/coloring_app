import 'dart:ui';

class FillCommand {
  const FillCommand({
    required this.regionId,
    required this.oldColor,
    required this.newColor,
  });

  final String regionId;
  final Color? oldColor;
  final Color? newColor;
}
