import 'package:flutter/material.dart';
import '../../../data/services/note_service.dart';
import '../../../data/services/message_service.dart';
import '../search/search_page.dart';

// AddNoteDialog class for creating new notes
class AddNoteDialog {
  static Future<bool?> show(BuildContext context) async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF374151),
        title: const Text('新增筆記', style: TextStyle(color: Colors.white)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: '標題',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
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
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: '內容',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
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
            child: const Text('取消', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await NoteService().addNote(
                    titleController.text.trim(),
                    contentController.text.trim(),
                  );
                  Navigator.pop(context, true);
                  MessageService.showSuccessMessage(context, '筆記已新增！');
                } catch (e) {
                  MessageService.showErrorMessage(context, '新增失敗: $e');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF374151),
              foregroundColor: Colors.white,
            ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedNote != null ? "" : '我的筆記'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: const Color(0xFF1F2937),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: _selectedNote != null 
          ? IconButton(
              onPressed: _backToNotesList,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            )
          : null,
        actions: _selectedNote != null ? [
          if (_isEditing)
            IconButton(
              onPressed: _saveNote,
              icon: const Icon(Icons.save, color: Colors.white),
            )
          else ...[
            IconButton(
              onPressed: _startEditing,
              icon: const Icon(Icons.edit, color: Colors.white),
            ),
            IconButton(
              onPressed: _deleteNote,
              icon: const Icon(Icons.delete, color: Colors.white),
            ),
          ],
        ] : [
          IconButton(
            onPressed: _openSearchPage,
            icon: const Icon(Icons.search, color: Colors.white),
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
          child: _selectedNote != null 
            ? _buildNoteDetailView()
            : _buildNotesListView(),
        ),
      ),
      floatingActionButton: _selectedNote == null 
        ? FloatingActionButton(
            onPressed: _addNewNote,
            backgroundColor: const Color(0xFF374151),
            child: const Icon(Icons.add, color: Colors.white),
          )
        : null,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildNotesListView() {
    if (_noteService.getNotes().isEmpty) {
      return const Center(
        child: Text(
          '還沒有任何筆記\n點擊右下角按鈕新增筆記',
          style: TextStyle(
            fontSize: 18, 
            color: Colors.grey,
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
          elevation: 2,
          color: const Color(0xFF374151),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _formatDate(note.date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
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
                  // 標題
                  if (_isEditing)
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: '輸入標題...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    )
                  else
                    Text(
                      _selectedNote!.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  
                  // 日期
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _formatDate(_selectedNote!.date),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  
                  const Divider(color: Colors.grey),
                  
                  // 內容
                  Expanded(
                    child: _isEditing
                      ? TextField(
                          controller: _contentController,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          decoration: const InputDecoration(
                            hintText: '輸入內容...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                        )
                      : SingleChildScrollView(
                          child: Text(
                            _selectedNote!.content,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
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
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF374151),
        title: const Text('放棄編輯', style: TextStyle(color: Colors.white)),
        content: const Text(
          '您有未儲存的修改，確定要放棄編輯嗎？',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('繼續編輯', style: TextStyle(color: Colors.grey)),
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
              backgroundColor: Colors.red,
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
      showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF374151),
          title: const Text('刪除筆記', style: TextStyle(color: Colors.white)),
          content: Text('確定要刪除「${_selectedNote!.title}」這篇筆記嗎？', 
                      style: const TextStyle(color: Colors.grey)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消', style: TextStyle(color: Colors.grey)),
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
                backgroundColor: Colors.red,
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
