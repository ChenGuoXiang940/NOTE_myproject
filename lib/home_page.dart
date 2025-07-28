import 'package:flutter/material.dart';
import 'drawer.dart';
import 'setting_page.dart';
import 'notes_page.dart';
import 'addnote_service.dart';
import 'search_page.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const Catalog(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6366F1),
              Color(0xFFF8FAFC),
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 歡迎區域
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.note_alt_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '歡迎使用筆記應用程式！',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '開始記錄您的想法和靈感',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // 功能卡片區域
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1F2937),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '快速操作',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // 根據螢幕寬度決定列數
                            int crossAxisCount = 2;
                            if (constraints.maxWidth > 800) {
                              crossAxisCount = 4; // 電腦螢幕使用4列
                            } else if (constraints.maxWidth > 600) {
                              crossAxisCount = 3; // 平板螢幕使用3列
                            }
                            
                            return GridView.count(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.0,
                              children: [
                            // 新增筆記卡片
                            _buildFeatureCard(
                              context,
                              icon: Icons.add_circle_outline,
                              title: '新增筆記',
                              subtitle: '建立新的筆記',
                              color: const Color(0xFF10B981),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddNotePage()),
                                );
                              },
                            ),
                            
                            // 我的筆記卡片
                            _buildFeatureCard(
                              context,
                              icon: Icons.folder_outlined,
                              title: '我的筆記',
                              subtitle: '瀏覽所有筆記',
                              color: const Color(0xFF3B82F6),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NotesPage()),
                                );
                              },
                            ),
                            
                            // 搜尋卡片
                            _buildFeatureCard(
                              context,
                              icon: Icons.search_outlined,
                              title: '搜尋',
                              subtitle: '尋找特定筆記',
                              color: const Color(0xFFF59E0B),
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SearchPage()),
                                );
                                
                                // 如果搜尋頁面返回了筆記，直接跳轉到筆記頁面並顯示該筆記
                                if (result != null && result is Map<String, dynamic>) {
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NotesPage(
                                          initialSelectedNote: result['note'],
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                            
                            // 設定卡片
                            _buildFeatureCard(
                              context,
                              icon: Icons.settings_outlined,
                              title: '設定',
                              subtitle: '應用程式設定',
                              color: const Color(0xFF8B5CF6),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SettingPage()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color..withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}