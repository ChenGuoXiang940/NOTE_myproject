import 'note_service.dart';

class SearchService {
  static final SearchService _instance = SearchService._internal();
  factory SearchService() => _instance;
  SearchService._internal();

  final NoteService _noteService = NoteService();

  /// 根據關鍵字搜尋筆記
  /// [query] 搜尋關鍵字
  /// 返回匹配的筆記列表
  List<Note> searchNotes(String query) {
    if (query.trim().isEmpty) {
      return _noteService.getNotes();
    }

    final String lowerQuery = query.toLowerCase().trim();
    final List<Note> allNotes = _noteService.getNotes();

    return allNotes.where((note) {
      final bool titleMatch = note.title.toLowerCase().contains(lowerQuery);
      final bool contentMatch = note.content.toLowerCase().contains(lowerQuery);
      
      return titleMatch || contentMatch;
    }).toList();
  }
  
  List<SearchResult> searchNotesWithHighlight(String query) {
    if (query.trim().isEmpty) {
      return _noteService.getNotes()
          .map((note) => SearchResult(note: note, matchType: MatchType.none))
          .toList();
    }

    final String lowerQuery = query.toLowerCase().trim();
    final List<Note> allNotes = _noteService.getNotes();
    List<SearchResult> results = [];

    for (Note note in allNotes) {
      final bool titleMatch = note.title.toLowerCase().contains(lowerQuery);
      final bool contentMatch = note.content.toLowerCase().contains(lowerQuery);

      if (titleMatch || contentMatch) {
        MatchType matchType;
        if (titleMatch && contentMatch) {
          matchType = MatchType.both;
        } else if (titleMatch) {
          matchType = MatchType.title;
        } else {
          matchType = MatchType.content;
        }

        results.add(SearchResult(
          note: note,
          matchType: matchType,
          query: query,
        ));
      }
    }

    return results;
  }

  /// 獲取搜尋建議（基於現有筆記的標題和內容中的關鍵字）
  List<String> getSearchSuggestions(String query, {int maxSuggestions = 5}) {
    if (query.trim().isEmpty) {
      return [];
    }

    final String lowerQuery = query.toLowerCase().trim();
    final List<Note> allNotes = _noteService.getNotes();
    Set<String> suggestions = {};

    for (Note note in allNotes) {
      // 從標題中提取建議
      List<String> titleWords = note.title.toLowerCase().split(RegExp(r'\s+'));
      for (String word in titleWords) {
        if (word.contains(lowerQuery) && word.length > lowerQuery.length) {
          suggestions.add(word);
        }
      }

      // 從內容中提取建議（限制長度避免過長的詞）
      List<String> contentWords = note.content.toLowerCase().split(RegExp(r'\s+'));
      for (String word in contentWords) {
        if (word.contains(lowerQuery) && 
            word.length > lowerQuery.length && 
            word.length <= 20) {
          suggestions.add(word);
        }
      }
    }

    return suggestions.take(maxSuggestions).toList();
  }
}

/// 搜尋結果包裝類
class SearchResult {
  final Note note;
  final MatchType matchType;
  final String? query;

  SearchResult({
    required this.note,
    required this.matchType,
    this.query,
  });

  /// 獲取帶有高亮的標題
  String getHighlightedTitle() {
    if (query == null || matchType == MatchType.content) {
      return note.title;
    }
    return _highlightText(note.title, query!);
  }

  /// 獲取帶有高亮的內容預覽
  String getHighlightedContentPreview({int maxLength = 100}) {
    String content = note.content;
    if (content.length > maxLength) {
      if (query != null && matchType != MatchType.title) {
        // 如果內容匹配，嘗試顯示包含關鍵字的部分
        int index = content.toLowerCase().indexOf(query!.toLowerCase());
        if (index != -1) {
          int start = (index - 30).clamp(0, content.length);
          int end = (index + query!.length + 70).clamp(0, content.length);
          content = content.substring(start, end);
          if (start > 0) content = '...$content';
          if (end < note.content.length) content = '$content...';
        } else {
          content = '${content.substring(0, maxLength)}...';
        }
      } else {
        content = '${content.substring(0, maxLength)}...';
      }
    }
    
    if (query != null && matchType != MatchType.title) {
      return _highlightText(content, query!);
    }
    return content;
  }

  /// 高亮文本（未完成）
  String _highlightText(String text, String query) {
    return text;
  }
}

/// 匹配類型枚舉
enum MatchType {
  none,     // 無匹配（顯示所有筆記時使用）
  title,    // 僅標題匹配
  content,  // 僅內容匹配
  both,     // 標題和內容都匹配
}
