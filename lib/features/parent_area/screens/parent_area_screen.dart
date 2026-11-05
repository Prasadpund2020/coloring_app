import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/design_constants.dart';
import '../../../core/settings/app_settings.dart';

class ParentAreaScreen extends StatefulWidget {
  const ParentAreaScreen({super.key});

  @override
  State<ParentAreaScreen> createState() => _ParentAreaScreenState();
}

class _ParentAreaScreenState extends State<ParentAreaScreen> {
  late final Future<AppSettingsRepository> _settingsRepository;
  bool? _soundEnabled;

  @override
  void initState() {
    super.initState();
    _settingsRepository = SharedPreferences.getInstance().then(
      AppSettingsRepository.new,
    );
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final AppSettingsRepository repository = await _settingsRepository;
    if (mounted) {
      setState(() {
        _soundEnabled = repository.load().soundEnabled;
      });
    }
  }

  Future<void> _setSoundEnabled(bool enabled) async {
    final AppSettingsRepository repository = await _settingsRepository;
    await repository.setSoundEnabled(enabled);
    if (mounted) {
      setState(() {
        _soundEnabled = enabled;
      });
    }
  }

  Future<void> _openPrivacyPolicy() async {
    final Uri uri = Uri.parse('https://example.com/little-doodle-privacy');
    final bool opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the privacy policy.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Area')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignConstants.pagePadding),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.settings, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Grown-up settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sound effects'),
                    value: _soundEnabled ?? true,
                    onChanged: _soundEnabled == null ? null : _setSoundEnabled,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _openPrivacyPolicy,
                    icon: const Icon(Icons.policy),
                    label: const Text('Privacy policy'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
