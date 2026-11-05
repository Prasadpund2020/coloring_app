import 'package:flutter_test/flutter_test.dart';
import 'package:little_doodle/core/settings/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('settings default to enabled sound', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final AppSettingsRepository repository = AppSettingsRepository(
      await SharedPreferences.getInstance(),
    );

    expect(repository.load().soundEnabled, isTrue);
  });

  test('sound setting persists', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final AppSettingsRepository repository = AppSettingsRepository(
      await SharedPreferences.getInstance(),
    );

    await repository.setSoundEnabled(false);

    expect(repository.load().soundEnabled, isFalse);
  });
}
