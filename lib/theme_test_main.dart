import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/theme_service.dart';
import 'core/themes/app_theme.dart';
import 'presentation/pages/notes/add_note_page.dart';
import 'presentation/pages/settings/new_settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ThemeTestApp());
}

class ThemeTestApp extends StatelessWidget {
  const ThemeTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: '筆記應用主題測試',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            home: const ThemeTestHomePage(),
          );
        },
      ),
    );
  }
}

class ThemeTestHomePage extends StatelessWidget {
  const ThemeTestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = Provider.of<ThemeService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('筆記應用 - 深色主題測試'),
        actions: [
          IconButton(
            icon: Icon(
              themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeService.toggleTheme();
            },
            tooltip: themeService.isDarkMode ? '切換到淺色主題' : '切換到深色主題',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 主題狀態顯示
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '目前主題模式',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      themeService.isDarkMode ? '深色主題' : '淺色主題',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '主題模式: ${_getThemeModeText(themeService.themeMode)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 主題切換按鈕
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '主題切換',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              themeService.setThemeMode(ThemeMode.light);
                            },
                            icon: const Icon(Icons.light_mode),
                            label: const Text('淺色主題'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              themeService.setThemeMode(ThemeMode.dark);
                            },
                            icon: const Icon(Icons.dark_mode),
                            label: const Text('深色主題'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          themeService.setThemeMode(ThemeMode.system);
                        },
                        icon: const Icon(Icons.auto_mode),
                        label: const Text('跟隨系統'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 測試頁面導航
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '測試頁面',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNotePage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('新增筆記頁面'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings),
                        label: const Text('設定頁面'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 顏色展示
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '主題顏色展示',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3,
                          children: [
                            _buildColorCard('主色', theme.colorScheme.primary),
                            _buildColorCard('次要色', theme.colorScheme.secondary),
                            _buildColorCard('表面色', theme.colorScheme.surface),
                            _buildColorCard('背景色', theme.colorScheme.background),
                            _buildColorCard('錯誤色', theme.colorScheme.error),
                            _buildColorCard('輪廓色', theme.colorScheme.outline),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          themeService.toggleTheme();
        },
        tooltip: '切換主題',
        child: Icon(
          themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        ),
      ),
    );
  }

  Widget _buildColorCard(String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: _getContrastColor(color),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getContrastColor(Color color) {
    // 計算對比色
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return '淺色';
      case ThemeMode.dark:
        return '深色';
      case ThemeMode.system:
        return '跟隨系統';
    }
  }
}
