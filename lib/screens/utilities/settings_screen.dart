import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../core/translations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'ar';
  String _selectedTheme = 'system'; // 'light', 'dark', 'system'
  bool _notifications = true;
  bool _locationServices = false;
  String _gridLayout = 'list'; // 'list' or 'grid'

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: theme.bg,
        foregroundColor: theme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display Settings
            _sectionTitle('Display', theme),
            const SizedBox(height: 16),

            // Theme Selector
            _settingCard(
              title: 'Theme',
              subtitle: _getThemeLabel(),
              icon: Icons.palette,
              trailing: DropdownButton<String>(
                value: _selectedTheme,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: 'light',
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(
                    value: 'dark',
                    child: Text('Dark'),
                  ),
                  DropdownMenuItem(
                    value: 'system',
                    child: Text('System'),
                  ),
                ]
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item.value,
                        child: Text(item.child.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedTheme = value!);
                  // Trigger theme change
                },
              ),
            ),
            const SizedBox(height: 12),

            // Layout Preference
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.view_list, color: theme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Layout',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _gridLayout == 'list'
                              ? 'Vertical List View'
                              : 'Grid View',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() =>
                          _gridLayout = _gridLayout == 'list' ? 'grid' : 'list');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          color: theme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Language Settings
            _sectionTitle('Language & Region', theme),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: const SizedBox(),
                value: _selectedLanguage,
                items: [
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('العربية (Arabic)'),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'ku',
                    child: Text('کوردی (Kurdish)'),
                  ),
                ]
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item.value,
                        child: item.child,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedLanguage = value!);
                  // Change app language
                },
              ),
            ),
            const SizedBox(height: 32),

            // Preferences
            _sectionTitle('Preferences', theme),
            const SizedBox(height: 16),

            _toggleSetting(
              title: 'Push Notifications',
              value: _notifications,
              onChanged: (value) => setState(() => _notifications = value),
              icon: Icons.notifications,
            ),
            const SizedBox(height: 12),

            _toggleSetting(
              title: 'Location Services',
              value: _locationServices,
              onChanged: (value) => setState(() => _locationServices = value),
              icon: Icons.location_on,
            ),
            const SizedBox(height: 32),

            // About
            _sectionTitle('About', theme),
            const SizedBox(height: 16),

            _infoCard(
              title: 'App Version',
              value: '1.0.0',
              icon: Icons.info,
            ),
            const SizedBox(height: 12),

            _infoCard(
              title: 'Build Number',
              value: '2024.03.01',
              icon: Icons.build,
            ),
            const SizedBox(height: 32),

            // Danger Zone
            _sectionTitle('Account', theme),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout?'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Logout logic
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red.shade600),
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Account?'),
                    content: const Text(
                      'This action cannot be undone. All your data will be permanently deleted.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Delete account logic
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red.shade600),
                    const SizedBox(width: 12),
                    Text(
                      'Delete Account',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, AppTheme theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: theme.primary,
      ),
    );
  }

  Widget _settingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    final theme = ThemeManager.active;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _toggleSetting({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    final theme = ThemeManager.active;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.primary,
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    final theme = ThemeManager.active;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  String _getThemeLabel() {
    switch (_selectedTheme) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System Default';
    }
  }
}
