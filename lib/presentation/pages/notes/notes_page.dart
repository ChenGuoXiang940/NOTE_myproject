import 'package:flutter/material.dart';
import '../../../data/services/note_service.dart';
import '../../../data/models/note_model.dart';
import '../../../data/services/message_service.dart';
import '../search/search_page.dart';

// AddNoteDialog class for creating new notes
class AddNoteDialog {
  static Future<bool?> show(BuildContext context) async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text('新增筆記', style: TextStyle(color: theme.textTheme.titleLarge?.color)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                decoration: InputDecoration(
                  labelText: '標題',
                  labelStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '請輸入標題';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contentController,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                decoration: InputDecoration(
                  labelText: '內容',
                  labelStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '請輸入內容';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消', style: TextStyle(color: theme.textTheme.bodySmall?.color)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await NoteService().addNote(
                    titleController.text.trim(),
                    contentController.text.trim(),
                  );
                  if (context.mounted) {
                    Navigator.pop(context, true);
                    MessageService.showSuccessMessage(context, '筆記已新增！');
                  }
                } catch (e) {
                  if (context.mounted) {
                    MessageService.showErrorMessage(context, '新增失敗: $e');
                  }
                }
              }
            },
            child: const Text('新增'),
          ),
        ],
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  final Note? initialSelectedNote;
  
  const NotesPage({super.key, this.initialSelectedNote});
  
  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NoteService _noteService = NoteService();
  Note? _selectedNote;
  bool _isEditing = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 如果有傳入初始選定的筆記，設置為當前選定的筆記
    if (widget.initialSelectedNote != null) {
      _selectedNote = widget.initialSelectedNote;
      _titleController.text = _selectedNote!.title;
      _contentController.text = _selectedNote!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedNote != null ? "" : '我的筆記'),
        leading: _selectedNote != null 
          ? IconButton(
              onPressed: _backToNotesList,
              icon: const Icon(Icons.arrow_back),
            )
          : null,
        actions: _selectedNote != null ? [
          if (_isEditing)
            IconButton(
              onPressed: _saveNote,
              icon: const Icon(Icons.save),
            )
          else ...[
            IconButton(
              onPressed: _startEditing,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: _deleteNote,
              icon: const Icon(Icons.delete),
            ),
          ],
        ] : [
          IconButton(
            onPressed: _openSearchPage,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: _selectedNote != null 
            ? _buildNoteDetailView()
            : _buildNotesListView(),
        ),
      ),
      floatingActionButton: _selectedNote == null 
        ? FloatingActionButton(
            onPressed: _addNewNote,
            child: const Icon(Icons.add),
          )
        : null,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildNotesListView() {
    final theme = Theme.of(context);
    
    if (_noteService.getNotes().isEmpty) {
      return Center(
        child: Text(
          '還沒有任何筆記\n點擊右下角按鈕新增筆記',
          style: TextStyle(
            fontSize: 18, 
            color: theme.textTheme.bodySmall?.color,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _noteService.getNotes().length,
      itemBuilder: (context, index) {
        final note = _noteService.getNotes()[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showNoteDetail(note),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleMedium?.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDate(note.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodySmall?.color,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoteDetailView() {
    if (_selectedNote == null) return Container();
    
    final theme = Theme.of(context);
    
    return Padding(
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
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 標題
                  if (_isEditing)
                    TextField(
                      controller: _titleController,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                      decoration: InputDecoration(
                        hintText: '輸入標題...',
                        hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                        border: InputBorder.none,
                      ),
                    )
                  else
                    Text(
                      _selectedNote!.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                  
                  // 日期
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _formatDate(_selectedNote!.createdAt),
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                  
                  Divider(color: theme.dividerColor),
                  
                  // 內容
                  Expanded(
                    child: _isEditing
                      ? TextField(
                          controller: _contentController,
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.textTheme.bodyMedium?.color,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            hintText: '輸入內容...',
                            hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                        )
                      : SingleChildScrollView(
                          child: Text(
                            _selectedNote!.content,
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color,
                              height: 1.5,
                            ),
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoteDetail(Note note) {
    setState(() {
      _selectedNote = note;
    });
  }

  void _addNewNote() async {
    final result = await AddNoteDialog.show(context);
    if (result == true) {
      setState(() {});
    }
  }

  void _backToNotesList() {
    if (_isEditing) {
      _showDiscardEditDialog();
    } else {
      setState(() {
        _selectedNote = null;
        _isEditing = false;
      });
    }
  }

  // 顯示放棄編輯的對話框
  void _showDiscardEditDialog() {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text('放棄編輯', style: TextStyle(color: theme.textTheme.titleLarge?.color)),
        content: Text(
          '您有未儲存的修改，確定要放棄編輯嗎？',
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('繼續編輯', style: TextStyle(color: theme.textTheme.bodySmall?.color)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedNote = null;
                _isEditing = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('放棄'),
          ),
        ],
      ),
    );
  }

  void _startEditing() {
    if (_selectedNote != null) {
      _titleController.text = _selectedNote!.title;
      _contentController.text = _selectedNote!.content;
      setState(() {
        _isEditing = true;
      });
    }
  }

  void _saveNote() {
    if (_selectedNote != null) {
      final title = _titleController.text.trim();
      final content = _contentController.text.trim();
      
      if (title.isNotEmpty && content.isNotEmpty) {
        final noteIndex = _noteService.getNotes().indexOf(_selectedNote!);
        if (noteIndex != -1) {
          _noteService.updateNote(noteIndex, title, content);
          setState(() {
            _selectedNote = _noteService.getNotes()[noteIndex];
            _isEditing = false;
          });
          MessageService.showSuccessMessage(context, '筆記已儲存！');
        }
      } else {
        MessageService.showErrorMessage(context, '請填寫完整的標題和內容');
      }
    }
  }

  void _deleteNote() {
    if (_selectedNote != null) {
      final theme = Theme.of(context);
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme.cardColor,
          title: Text('刪除筆記', style: TextStyle(color: theme.textTheme.titleLarge?.color)),
          content: Text('確定要刪除「${_selectedNote!.title}」這篇筆記嗎？', 
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('取消', style: TextStyle(color: theme.textTheme.bodySmall?.color)),
            ),
            ElevatedButton(
              onPressed: () {
                final noteIndex = _noteService.getNotes().indexOf(_selectedNote!);
                if (noteIndex != -1) {
                  _noteService.deleteNote(noteIndex);
                  setState(() {
                    _selectedNote = null;
                    _isEditing = false;
                  });
                  Navigator.pop(context);
                  MessageService.showSuccessMessage(context, '筆記已刪除！');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('刪除'),
            ),
          ],
        ),
      );
    }
  }

  void _openSearchPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchPage(),
      ),
    );
    
    if (result != null && result is Map<String, dynamic>) {
      final Note note = result['note'];
      _showNoteDetail(note);
    }
  }
}
