import 'package:flutter/services.dart';

import '../settings/app_settings.dart';

class ChildFeedback {
  const ChildFeedback(this._settings);

  final AppSettingsRepository _settings;

  Future<void> playSuccess() async {
    if (_settings.load().soundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }
}
