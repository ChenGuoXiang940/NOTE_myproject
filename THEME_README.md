# 筆記應用 - 深色主題功能

## 功能概述

這個筆記應用現在支持完整的深色主題功能，包括：

### 🌟 主要特性

1. **完整的深色主題支持**
   - 淺色主題
   - 深色主題  
   - 跟隨系統設定

2. **主題持久化**
   - 使用 SharedPreferences 保存主題設定
   - 應用重啟後保持使用者選擇的主題

3. **多種切換方式**
   - 設定頁面的詳細主題選項
   - 導航欄的快速切換開關
   - FloatingActionButton 快速切換

### 🎨 主題顏色配置

#### 淺色主題
- 主色：#6366F1 (Indigo)
- 次要色：#8B5CF6 (Purple)
- 背景色：#FAFAFA (淺灰)
- 表面色：#FFFFFF (白色)
- 文字色：#212121 (深灰)

#### 深色主題  
- 主色：#6366F1 (Indigo)
- 次要色：#8B5CF6 (Purple)
- 背景色：#111827 (深灰)
- 表面色：#1F2937 (中灰)
- 卡片色：#374151 (淺深灰)
- 文字色：#F9FAFB (淺色)

### 🛠️ 技術實現

#### 1. 主題服務 (ThemeService)
```dart
class ThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  // 切換主題
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await setThemeMode(newMode);
  }
  
  // 設定主題模式
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_themeKey, themeString);
    notifyListeners();
  }
}
```

#### 2. 主題配置 (AppTheme)
- 使用 Material 3 設計系統
- 完整的 ColorScheme 配置
- 統一的組件主題設定

#### 3. 狀態管理
- 使用 Provider 進行狀態管理
- Consumer 模式響應主題變更
- 自動重繪相關 UI 組件

### 📱 使用方式

#### 在設定頁面切換主題：
1. 打開應用
2. 進入設定頁面
3. 在「外觀設定」區域選擇主題模式

#### 快速切換：
1. 使用導航欄的主題切換開關
2. 點擊 FloatingActionButton
3. 使用 AppBar 的主題切換按鈕

### 🧪 測試應用

運行主題測試應用：
```bash
flutter run -d windows --target=lib\theme_test_main.dart
```

測試功能包括：
- 實時主題切換
- 顏色展示
- 頁面導航測試
- 主題狀態顯示

### 📁 檔案結構

```
lib/
├── core/
│   ├── services/
│   │   └── theme_service.dart          # 主題服務
│   ├── themes/
│   │   └── app_theme.dart              # 主題配置
│   └── constants/
│       └── app_colors.dart             # 顏色常數
├── presentation/
│   ├── pages/
│   │   ├── notes/
│   │   │   └── add_note_page.dart      # 已更新支持主題
│   │   └── settings/
│   │       └── new_settings_page.dart  # 新的設定頁面
│   └── widgets/
│       └── common/
│           └── custom_drawer.dart      # 已更新支持主題切換
├── app/
│   └── app.dart                        # 主應用配置
└── theme_test_main.dart               # 主題測試應用
```

### 🔧 依賴包

新增的依賴：
```yaml
dependencies:
  shared_preferences: ^2.2.2  # 主題設定持久化
  provider: ^6.1.1            # 狀態管理
```

### ✨ 特色功能

1. **智能對比度**：自動計算文字和背景的對比度，確保可讀性
2. **平滑過渡**：主題切換時的流暢動畫效果
3. **系統整合**：支持跟隨系統深色模式設定
4. **完整覆蓋**：所有 UI 組件都支持深色主題

### 🚀 未來計劃

- [ ] 自定義主題顏色
- [ ] 多種主題預設選項
- [ ] 定時主題切換（夜間模式）
- [ ] 主題動畫效果優化

---

## 截圖展示

### 淺色主題
![淺色主題](screenshots/light_theme.png)

### 深色主題  
![深色主題](screenshots/dark_theme.png)

### 設定頁面
![設定頁面](screenshots/settings_page.png)

---

**開發者：** ChenGuoXiang  
**電子郵件：** s1411232069@ad1.nutc.edu.tw  
**版本：** v1.0.0
