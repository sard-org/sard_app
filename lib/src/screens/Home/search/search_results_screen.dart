import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/global_favorite_cubit.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../../AudioBook/audio_book.dart';
import '../widgets/BookCardWidget.dart';
import 'search_books_api_service.dart';
import 'search_books_model.dart';
import 'search_cache_service.dart';
import 'books_suggestions_service.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final SearchBooksApiService _apiService = SearchBooksApiService();
  final BooksSuggestionsService _suggestionsService = BooksSuggestionsService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounceTimer;

  List<SearchBook> searchResults = [];
  bool isLoading = true;
  String? errorMessage;
  String currentQuery = '';
  List<String> searchHistory = [];
  List<String> bookSuggestions = [];
  bool isLoadingSuggestions = false;

  @override
  void initState() {
    super.initState();
    currentQuery = widget.searchQuery;
    _searchController.text = widget.searchQuery;
    _loadSearchHistory();
    _loadBookSuggestions();
    
    if (widget.searchQuery.isNotEmpty) {
      _performSearch(widget.searchQuery);
    } else {
      setState(() {
        isLoading = false;
      });
    }
    
    // تركيز تلقائي على مربع البحث مع تأخير بسيط للسماح للانتقال بالاكتمال
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _searchController.text.isEmpty) {
          _searchFocusNode.requestFocus();
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadSearchHistory() async {
    final history = await SearchCacheService.getSearchHistory();
    setState(() {
      searchHistory = history;
    });
  }

  Future<void> _loadBookSuggestions() async {
    setState(() {
      isLoadingSuggestions = true;
    });
    
    try {
      final suggestions = await _suggestionsService.getRandomBookTitles(count: 8);
      setState(() {
        bookSuggestions = suggestions;
        isLoadingSuggestions = false;
      });
    } catch (e) {
      print('Error loading book suggestions: $e');
      setState(() {
        isLoadingSuggestions = false;
        // Use fallback suggestions
        bookSuggestions = [
          'الإسلام',
          'لسان آدم',
          'فكر تصبح غنيًا',
          'علم النفس',
          'الفلسفة',
          'الروايات العربية',
          'كتب الأطفال',
          'الثقافة العامة',
        ];
      });
    }
  }

  void _onSearchChanged(String query) {
    // Cancel the previous timer if it exists
    _debounceTimer?.cancel();

    // Update UI immediately to show/hide clear button
    setState(() {});

    // Set a new timer for 500ms delay
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchResults = [];
        isLoading = false;
        errorMessage = null;
        currentQuery = '';
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        currentQuery = query;
      });

      final results = await _apiService.searchBooks(query);

      // Save search to history whether results found or not
      await SearchCacheService.addSearchToHistory(query);
      await _loadSearchHistory();

      // Update global favorite state with search results
      if (mounted) {
        final globalFavoriteCubit = context.read<GlobalFavoriteCubit>();
        for (var book in results) {
          globalFavoriteCubit.updateFavoriteStatus(book.id, book.isFavorite);
        }
      }

      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'آخر نتائج البحث',
                  style: AppTexts.heading3Bold.copyWith(
                    color: AppColors.neutral800,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await SearchCacheService.clearSearchHistory();
                    await _loadSearchHistory();
                  },
                  child: Text(
                    'مسح الكل',
                    style: AppTexts.contentBold.copyWith(
                      color: AppColors.primary500,
                        decoration: TextDecoration.underline
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...searchHistory.map((query) => _buildSuggestionItem(
              query,
              Icons.history,
              isHistory: true,
            )),
            const SizedBox(height: 24),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'اقتراحات البحث',
                style: AppTexts.heading3Bold.copyWith(
                  color: AppColors.neutral800,
                ),
              ),
              GestureDetector(
                onTap: isLoadingSuggestions ? null : _loadBookSuggestions,
                child: Text(
                  'تحديث',
                  style: AppTexts.contentBold.copyWith(
                    color: isLoadingSuggestions 
                        ? AppColors.neutral400 
                        : AppColors.primary500,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (isLoadingSuggestions)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  color: AppColors.primary500,
                ),
              ),
            )
          else
            ...bookSuggestions.map((suggestion) => _buildSuggestionItem(
              suggestion,
              Icons.menu_book,
            )),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(String text, IconData icon, {bool isHistory = false}) {
    return GestureDetector(
      onTap: () {
        _searchController.text = text;
        _performSearch(text);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isHistory ? AppColors.neutral500 : AppColors.primary500,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTexts.contentRegular.copyWith(
                  color: AppColors.neutral800,
                ),
              ),
            ),
            if (isHistory)
              GestureDetector(
                onTap: () async {
                  await SearchCacheService.removeSearchFromHistory(text);
                  await _loadSearchHistory();
                },
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.neutral400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج للبحث',
            style: AppTexts.heading3Bold.copyWith(color: AppColors.neutral800),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب البحث بكلمات مختلفة',
            style:
                AppTexts.contentRegular.copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.primary500,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في البحث',
            style: AppTexts.heading3Bold.copyWith(color: AppColors.neutral800),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'خطأ غير معروف',
            style:
                AppTexts.contentRegular.copyWith(color: AppColors.neutral500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _performSearch(currentQuery),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary500,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'إعادة المحاولة',
              style: AppTexts.contentBold.copyWith(color: AppColors.neutral100),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.primary500),
            ),
          ),
          SizedBox(width: 12),
          Text(
            "البحث",
            style: AppTexts.heading2Bold.copyWith(
              color: AppColors.neutral100,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral100,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  textDirection: TextDirection.rtl,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'عن ماذا تبحث؟',
                    hintStyle: AppTexts.contentEmphasis
                        .copyWith(color: AppColors.neutral600),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              _onSearchChanged('');
                              _searchFocusNode.requestFocus();
                            },
                            child: const Icon(
                              Icons.clear,
                              color: AppColors.neutral500,
                              size: 20,
                            ),
                          ),
                        const SizedBox(width: 8),
                        const Icon(Icons.search, color: AppColors.neutral600),
                        const SizedBox(width: 8),
                      ],
                    ),
                    filled: true,
                    fillColor: AppColors.neutral100,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.neutral300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary500, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.neutral300),
                    ),
                  ),
                  style: AppTexts.contentEmphasis
                      .copyWith(color: AppColors.neutral1000),
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                  onSubmitted: _performSearch,
                ),
              ),
              if (currentQuery.isNotEmpty && !isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'نتائج البحث عن: ',
                        style: AppTexts.contentRegular
                            .copyWith(color: AppColors.neutral600),
                      ),
                      Text(
                        '"$currentQuery"',
                        style: AppTexts.contentBold
                            .copyWith(color: AppColors.primary500),
                      ),
                      const Spacer(),
                      Text(
                        '${searchResults.length} نتيجة',
                        style: AppTexts.contentRegular
                            .copyWith(color: AppColors.neutral600),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary500,
                        ),
                      )
                    : errorMessage != null
                        ? _buildErrorState()
                        : currentQuery.isEmpty
                            ? _buildSearchSuggestions()
                            : searchResults.isEmpty
                                ? _buildEmptyState()
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    itemCount: searchResults.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final book = searchResults[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16),
                                        child: BookCardWidget(
                                          id: book.id,
                                          author: book.author.name,
                                          title: book.title,
                                          description: book.description,
                                          imageUrl: book.cover,
                                          is_favorite: book.isFavorite,
                                          price: book.isFree ? null : book.price,
                                          pricePoints: book.pricePoints,
                                          isFree: book.isFree,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AudioBookScreen(
                                                        bookId: book.id),
                                              ),
                                            );
                                          },
                                          onFavoriteTap: () {
                                            final globalFavoriteCubit =
                                                context.read<GlobalFavoriteCubit>();
                                            globalFavoriteCubit
                                                .toggleFavorite(book.id);
                                          },
                                        ),
                                      );
                                    },
                                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
