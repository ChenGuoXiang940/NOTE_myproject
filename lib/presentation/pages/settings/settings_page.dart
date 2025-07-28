import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/services/theme_service.dart';
import '../../../data/services/message_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 主題設定區域
          _buildThemeSection(context),
          const SizedBox(height: 24),
          
          // 帳號設定區域
          _buildAccountSection(context),
          const SizedBox(height: 24),
          
          // 關於程式區域
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '外觀設定',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<ThemeService>(
              builder: (context, themeService, child) {
                return Column(
                  children: [
                    // 淺色主題選項
                    RadioListTile<ThemeMode>(
                      title: const Text('淺色主題'),
                      subtitle: const Text('使用淺色背景'),
                      value: ThemeMode.light,
                      groupValue: themeService.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeService.setThemeMode(value);
                        }
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                    
                    // 深色主題選項
                    RadioListTile<ThemeMode>(
                      title: const Text('深色主題'),
                      subtitle: const Text('使用深色背景'),
                      value: ThemeMode.dark,
                      groupValue: themeService.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeService.setThemeMode(value);
                        }
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                    
                    // 系統主題選項
                    RadioListTile<ThemeMode>(
                      title: const Text('跟隨系統'),
                      subtitle: const Text('根據系統設定自動切換'),
                      value: ThemeMode.system,
                      groupValue: themeService.themeMode,
                      onChanged: (ThemeMode? value) {
                        if (value != null) {
                          themeService.setThemeMode(value);
                        }
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                    
                    const Divider(),
                    
                    // 快速切換按鈕
                    ListTile(
                      leading: Icon(
                        themeService.isDarkMode 
                            ? Icons.light_mode 
                            : Icons.dark_mode,
                        color: theme.colorScheme.primary,
                      ),
                      title: Text(
                        themeService.isDarkMode ? '切換到淺色主題' : '切換到深色主題'
                      ),
                      trailing: Switch(
                        value: themeService.isDarkMode,
                        onChanged: (bool value) {
                          themeService.toggleTheme();
                        },
                        activeColor: theme.colorScheme.primary,
                      ),
                      onTap: () {
                        themeService.toggleTheme();
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '帳號設定',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('個人資料'),
              subtitle: const Text('編輯個人資料信息'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                MessageService.showMessage(context, '個人資料功能開發中');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('密碼變更'),
              subtitle: const Text('變更您的登入密碼'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                MessageService.showMessage(context, '密碼變更功能開發中');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  '關於程式',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.app_settings_alt),
              title: const Text('版本資訊'),
              subtitle: const Text('v1.1.0'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showVersionDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('開發者'),
              subtitle: const Text('ChenGuoXiang'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showDeveloperDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('聯絡我們'),
              subtitle: const Text('s1411232069@ad1.nutc.edu.tw'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () async {
                const url = 'https://github.com/ChenGuoXiang940';
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    MessageService.showMessage(context, '無法開啟連結');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVersionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('版本資訊'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('應用程式版本: v1.1.0'),
              SizedBox(height: 8),
              Text('最後更新: 2025年7月'),
              SizedBox(height: 8),
              Text('使用 Flutter 框架開發'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }

  void _showDeveloperDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('開發者資訊'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('開發者: ChenGuoXiang'),
              SizedBox(height: 8),
              Text('電子郵件: s1411232069@ad1.nutc.edu.tw'),
              SizedBox(height: 8),
              Text('GitHub: ChenGuoXiang940'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }
}
