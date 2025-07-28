import 'package:flutter/material.dart';
import '../../../data/services/search_service.dart';
import '../../../data/services/note_service.dart';
import '../../../data/models/note_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  List<SearchResult> _searchResults = [];
  bool _isSearching = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    // 初始顯示所有筆記
    _performSearch('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
      _currentQuery = query;
    });

    // 模擬搜尋延遲，在實際應用中可以添加防抖功能
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && _currentQuery == query) {
        setState(() {
          _searchResults = _searchService.searchNotesWithHighlight(query);
          _isSearching = false;
        });
      }
    });
  }

  void _onSearchChanged(String value) {
    _performSearch(value);
  }

  void _clearSearch() {
    _searchController.clear();
    _performSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('搜尋筆記'),
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            // 搜尋輸入框
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                decoration: InputDecoration(
                  hintText: '搜尋標題或內容...',
                  hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: _clearSearch,
                          icon: Icon(
                            Icons.clear,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            
            // 搜尋結果統計
            if (_currentQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '找到 ${_searchResults.length} 條結果',
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 8),
            
            // 搜尋結果列表
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final theme = Theme.of(context);
    
    if (_isSearching) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _currentQuery.isEmpty ? Icons.search : Icons.search_off,
              size: 64,
              color: theme.textTheme.bodySmall?.color,
            ),
            const SizedBox(height: 16),
            Text(
              _currentQuery.isEmpty 
                  ? '輸入關鍵字開始搜尋' 
                  : '沒有找到匹配的筆記',
              style: TextStyle(
                color: theme.textTheme.bodySmall?.color,
                fontSize: 16,
              ),
            ),
            if (_currentQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '嘗試使用不同的關鍵字',
                style: TextStyle(
                  color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final searchResult = _searchResults[index];
        return _buildSearchResultItem(searchResult, index);
      },
    );
  }

  Widget _buildSearchResultItem(SearchResult searchResult, int index) {
    final note = searchResult.note;
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () => _openNoteDetail(note, index),
        title: Row(
          children: [
            Expanded(
              child: Text(
                note.title,
                style: TextStyle(
                  color: theme.textTheme.titleMedium?.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildMatchTypeIndicator(searchResult.matchType),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              searchResult.getHighlightedContentPreview(maxLength: 80),
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              _formatDate(note.createdAt),
              style: TextStyle(
                color: theme.textTheme.bodySmall?.color,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchTypeIndicator(MatchType matchType) {
    IconData icon;
    Color color;
    String tooltip;

    switch (matchType) {
      case MatchType.title:
        icon = Icons.title;
        color = const Color(0xFF10B981);
        tooltip = '標題匹配';
        break;
      case MatchType.content:
        icon = Icons.description;
        color = const Color(0xFF3B82F6);
        tooltip = '內容匹配';
        break;
      case MatchType.both:
        icon = Icons.done_all;
        color = const Color(0xFF8B5CF6);
        tooltip = '標題和內容都匹配';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Tooltip(
      message: tooltip,
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _openNoteDetail(Note note, int searchResultIndex) {
    // 找到筆記在原始筆記列表中的索引
    final NoteService noteService = NoteService();
    final List<Note> allNotes = noteService.getNotes();
    final int actualIndex = allNotes.indexWhere((n) => 
        n.title == note.title && 
        n.content == note.content && 
        n.createdAt == note.createdAt
    );
    
    Navigator.pop(context, {
      'note': note, 
      'index': actualIndex >= 0 ? actualIndex : searchResultIndex
    });
  }
}