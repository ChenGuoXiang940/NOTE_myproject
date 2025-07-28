import 'package:flutter/material.dart';
import 'note_service.dart';
import 'message_service.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final NoteService _noteService = NoteService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        if (_hasUnsavedContent()) {
          if (!mounted) return;
          final navigator = Navigator.of(context);
          final shouldDiscard = await _showDiscardDialog();
          if (shouldDiscard == true && mounted) {
            navigator.pop(false);
          }
        } else {
          if (mounted) {
            Navigator.pop(context, false);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新增筆記'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: const Color(0xFF1F2937),
          foregroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            onPressed: _handleBackPress,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: _saveNote,
              icon: const Icon(Icons.save, color: Colors.white),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1F2937),
              Color(0xFF111827),
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 筆記內容卡片
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF374151),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 標題輸入框
                        TextField(
                          controller: _titleController,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            hintText: '輸入筆記標題...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          maxLength: 50,
                        ),
                        
                        const Divider(color: Colors.grey),
                        
                        // 內容輸入框
                        Expanded(
                          child: TextField(
                            controller: _contentController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                            decoration: const InputDecoration(
                              hintText: '輸入筆記內容...',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
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
      ),
    ),
    );
  }

  bool _hasUnsavedContent() {
    return _titleController.text.trim().isNotEmpty || _contentController.text.trim().isNotEmpty;
  }
  // 處理返回按鈕的邏輯
  void _handleBackPress() async {
    if (_hasUnsavedContent()) {
      final shouldDiscard = await _showDiscardDialog();
      if (shouldDiscard == true && mounted) {
        Navigator.pop(context, false);
      }
    } else {
      if (mounted) {
        Navigator.pop(context, false);
      }
    }
  }

  // 顯示放棄編輯的對話框
  Future<bool?> _showDiscardDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF374151),
        title: const Text('放棄編輯', style: TextStyle(color: Colors.white)),
        content: const Text(
          '您有未儲存的內容，確定要放棄編輯嗎？',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('繼續編輯', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('放棄'),
          ),
        ],
      ),
    );
  }
  // 儲存筆記
  void _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    if (title.isNotEmpty && content.isNotEmpty) {
      await _noteService.addNote(title, content);
      if (mounted) {
        Navigator.pop(context, true);
        MessagePage.showMessage(context, '筆記新增成功！');
      }
    } else {
      if (mounted) {
        MessagePage.showMessage(context, '請填寫完整的標題和內容');
      }
    }
  }
}

// 用於對話框式的新增筆記功能
class AddNoteDialog {
  static Future<bool?> show(BuildContext context) async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final noteService = NoteService();

    return await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF374151),
        title: const Text('新增筆記', style: TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: '筆記標題',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                maxLength: 50,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: contentController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: '筆記內容',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _showDiscardEditDialog(context, titleController, contentController),
            child: const Text('取消', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();
              if (title.isNotEmpty && content.isNotEmpty) {
                await noteService.addNote(title, content);
                if (context.mounted) {
                  Navigator.pop(context, true);
                  MessagePage.showMessage(context, '筆記新增成功！');
                }
              } else {
                if (context.mounted) {
                  MessagePage.showMessage(context, '請填寫完整的標題和內容');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1F2937),
              foregroundColor: Colors.white,
            ),
            child: const Text('儲存'),
          ),
        ],
      ),
    );
  }

  // 顯示放棄編輯的對話框 for AddNoteDialog
  static Future<void> _showDiscardEditDialog(BuildContext context, 
      TextEditingController titleController, 
      TextEditingController contentController) async {
    
    // 檢查是否有未儲存的內容
    bool hasUnsavedContent = titleController.text.trim().isNotEmpty || contentController.text.trim().isNotEmpty;
    
    if (!hasUnsavedContent) {
      Navigator.pop(context, false);
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF374151),
        title: const Text('放棄編輯', style: TextStyle(color: Colors.white)),
        content: const Text(
          '您有未儲存的內容，確定要放棄編輯嗎？',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('繼續編輯', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('放棄'),
          ),
        ],
      ),
    );

    if (shouldDiscard == true) {
      if (context.mounted) {
        Navigator.pop(context, false);
      }
    }
  }
}
