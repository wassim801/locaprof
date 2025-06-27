import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> get createState => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Preferences'),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive booking updates and reminders'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              // TODO: Save notification preference
            },
          ),
          SwitchListTile(
            title: const Text('Location Services'),
            subtitle: const Text('Show nearby properties and get directions'),
            value: _locationEnabled,
            onChanged: (value) {
              setState(() => _locationEnabled = value);
              // TODO: Save location preference
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark themes'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() => _darkModeEnabled = value);
              // TODO: Implement theme switching
            },
          ),
          const Divider(),
          const _SectionHeader(title: 'Language & Region'),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showLanguageSelector,
          ),
          ListTile(
            title: const Text('Currency'),
            subtitle: Text(_selectedCurrency),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showCurrencySelector,
          ),
          const Divider(),
          const _SectionHeader(title: 'Support'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help Center'),
            onTap: () {
              // TODO: Navigate to help center
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              // TODO: Navigate to privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            onTap: () {
              // TODO: Navigate to terms of service
            },
          ),
          const Divider(),
          const _SectionHeader(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Delete Account'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: _showDeleteAccountConfirmation,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.greyColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('English'),
            trailing: _selectedLanguage == 'English'
                ? const Icon(Icons.check, color: AppTheme.primaryColor)
                : null,
            onTap: () {
              setState(() => _selectedLanguage = 'English');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Français'),
            trailing: _selectedLanguage == 'Français'
                ? const Icon(Icons.check, color: AppTheme.primaryColor)
                : null,
            onTap: () {
              setState(() => _selectedLanguage = 'Français');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Español'),
            trailing: _selectedLanguage == 'Español'
                ? const Icon(Icons.check, color: AppTheme.primaryColor)
                : null,
            onTap: () {
              setState(() => _selectedLanguage = 'Español');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showCurrencySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('USD - US Dollar'),
            trailing: _selectedCurrency == 'USD'
                ? const Icon(Icons.check, color: AppTheme.primaryColor)
                : null,
            onTap: () {
              setState(() => _selectedCurrency = 'USD');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('EUR - Euro'),
            trailing: _selectedCurrency == 'EUR'
                ? const Icon(Icons.check, color: AppTheme.primaryColor)
                : null,
            onTap: () {
              setState(() => _selectedCurrency = 'EUR');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('GBP - British Pound'),
            trailing: _selectedCurrency == 'GBP'
                ? const Icon(Icons.check, color: AppTheme.primaryColor)
                : null,
            onTap: () {
              setState(() => _selectedCurrency = 'GBP');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement account deletion
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}