import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note_model.dart';

class NoteService {
  static final NoteService _instance = NoteService._internal();
  factory NoteService() => _instance;
  List<Note> _notes = [];
  NoteService._internal();
  late File _notesFile;
  
  // 初始化並載入數據
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _notesFile = File('${directory.path}/notes.json');
    await _loadNotes();
  }
  
  // 從文件載入筆記
  Future<void> _loadNotes() async {
    try {
      if (await _notesFile.exists()) {
        final jsonString = await _notesFile.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        _notes = jsonList.map((json) => Note.fromJson(json)).toList();
      }
    } catch (e) {
      // 載入筆記時發生錯誤 - 在生產環境中應使用適當的日誌記錄
      debugPrint('載入筆記時發生錯誤: $e');
    }
  }
    // 保存筆記到文件
  Future<void> _saveNotes() async {
    try {
      final jsonList = _notes.map((note) => note.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await _notesFile.writeAsString(jsonString);
    } catch (e) {
      // 處理保存筆記時的錯誤
      debugPrint('保存筆記時發生錯誤: $e');
    }
  }
  
  Future<void> addNote(String title, String content) async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _notes.add(note);
    await _saveNotes();
  }
  
  List<Note> getNotes() {
    return List.from(_notes);
  }
  
  Future<void> deleteNote(int index) async {
    if (index >= 0 && index < _notes.length) {
      _notes.removeAt(index);
      await _saveNotes();
    }
  }
  
  Future<void> updateNote(int index, String title, String content) async {
    if (index >= 0 && index < _notes.length) {
      final existingNote = _notes[index];
      _notes[index] = existingNote.copyWith(
        title: title,
        content: content,
        updatedAt: DateTime.now(),
      );
      await _saveNotes();
    }
  }
}
