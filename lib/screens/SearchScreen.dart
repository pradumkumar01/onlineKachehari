import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_online_kachehari/models/advocate_model.dart';
import 'package:flutter_online_kachehari/models/service_model.dart';
import 'package:flutter_online_kachehari/services/search_service.dart';
import 'package:flutter_online_kachehari/provider/theme.dart';
import 'package:flutter_online_kachehari/components/LiveAdvoactes/ChatScreen/ChatScreen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Search results
  List<AdvocateModel> _advocateResults = [];
  List<ServiceModel> _serviceResults = [];
  List<String> _suggestions = [];

  // UI states
  bool _isLoading = false;
  bool _showSuggestions = false;
  String _errorMessage = '';
  String _currentSearchQuery = '';

  // Debouncer for search
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  // Search filter
  SearchFilter _currentFilter = SearchFilter.all;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
    _loadInitialSuggestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Handle focus changes
  void _onFocusChange() {
    if (_searchFocusNode.hasFocus && _searchController.text.isEmpty) {
      setState(() => _showSuggestions = true);
    }
  }

  /// Load initial search suggestions
  Future<void> _loadInitialSuggestions() async {
    try {
      final suggestions = await _searchService.getSearchSuggestions('');
      if (mounted) {
        setState(() => _suggestions = suggestions);
      }
    } catch (e) {
      print('Error loading suggestions: $e');
    }
  }

  /// Handle search input with debouncing
  void _onSearchChanged(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Show suggestions for empty or short queries
    if (query.isEmpty) {
      setState(() {
        _showSuggestions = true;
        _advocateResults = [];
        _serviceResults = [];
        _errorMessage = '';
      });
      _loadInitialSuggestions();
      return;
    }

    // Update suggestions immediately for better UX
    _updateSuggestions(query);

    // Debounce the actual search
    _debounceTimer = Timer(_debounceDuration, () {
      _performSearch(query);
    });
  }

  /// Update search suggestions
  Future<void> _updateSuggestions(String query) async {
    try {
      final suggestions = await _searchService.getSearchSuggestions(query);
      if (mounted) {
        setState(() => _suggestions = suggestions);
      }
    } catch (e) {
      print('Error updating suggestions: $e');
    }
  }

  /// Perform the actual search
  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _showSuggestions = false;
      _errorMessage = '';
      _currentSearchQuery = query;
    });

    try {
      List<AdvocateModel> advocates = [];
      List<ServiceModel> services = [];

      // Search based on filter
      if (_currentFilter == SearchFilter.all ||
          _currentFilter == SearchFilter.advocates) {
        advocates = await _searchService.searchAdvocates(query);
      }

      if (_currentFilter == SearchFilter.all ||
          _currentFilter == SearchFilter.services) {
        services = await _searchService.searchServices(query);
      }

      if (mounted) {
        setState(() {
          _advocateResults = advocates;
          _serviceResults = services;
          _isLoading = false;

          // Show message if no results
          if (advocates.isEmpty && services.isEmpty) {
            _errorMessage = 'No results found for "$query"';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error searching: ${e.toString()}';
        });
      }
    }
  }

  /// Handle suggestion tap
  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _performSearch(suggestion);
    _searchFocusNode.unfocus();
  }

  /// Clear search
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _advocateResults = [];
      _serviceResults = [];
      _errorMessage = '';
      _showSuggestions = true;
      _currentSearchQuery = '';
    });
    _loadInitialSuggestions();
  }

  /// Change search filter
  void _changeFilter(SearchFilter filter) {
    setState(() => _currentFilter = filter);
    if (_currentSearchQuery.isNotEmpty) {
      _performSearch(_currentSearchQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeData = Provider.of<ThemeProviderState>(context);

    return Scaffold(
      backgroundColor: themeData.isDarkMode ? Colors.black : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(themeData),

          // Filter chips
          if (!_showSuggestions) _buildFilterChips(themeData),

          // Content area
          Expanded(
            child: _showSuggestions
                ? _buildSuggestions(themeData)
                : _isLoading
                    ? _buildLoadingState()
                    : _errorMessage.isNotEmpty
                        ? _buildErrorState(themeData)
                        : _buildSearchResults(themeData),
          ),
        ],
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar(ThemeProviderState themeData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _onSearchChanged,
        onSubmitted: _performSearch,
        style: TextStyle(
          color: themeData.isDarkMode ? Colors.white : Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Search advocates, services...',
          hintStyle: TextStyle(
            color: themeData.isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.deepPurple),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  /// Build filter chips
  Widget _buildFilterChips(ThemeProviderState themeData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', SearchFilter.all, themeData),
            const SizedBox(width: 8),
            _buildFilterChip('Advocates', SearchFilter.advocates, themeData),
            const SizedBox(width: 8),
            _buildFilterChip('Services', SearchFilter.services, themeData),
          ],
        ),
      ),
    );
  }

  /// Build individual filter chip
  Widget _buildFilterChip(
      String label, SearchFilter filter, ThemeProviderState themeData) {
    final isSelected = _currentFilter == filter;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _changeFilter(filter),
      backgroundColor: themeData.isDarkMode ? Colors.grey[800] : Colors.white,
      selectedColor: Colors.deepPurple,
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : (themeData.isDarkMode ? Colors.white : Colors.black87),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      checkmarkColor: Colors.white,
    );
  }

  /// Build suggestions list
  Widget _buildSuggestions(ThemeProviderState themeData) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Popular Searches',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeData.isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ..._suggestions
            .map((suggestion) => _buildSuggestionTile(suggestion, themeData)),
      ],
    );
  }

  /// Build suggestion tile
  Widget _buildSuggestionTile(String suggestion, ThemeProviderState themeData) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(
        suggestion,
        style: TextStyle(
          color: themeData.isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.north_west, color: Colors.grey, size: 16),
      onTap: () => _onSuggestionTap(suggestion),
    );
  }

  /// Build loading state
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
          SizedBox(height: 16),
          Text(
            'Searching...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// Build error state
  Widget _buildErrorState(ThemeProviderState themeData) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: themeData.isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _performSearch(_currentSearchQuery),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build search results
  Widget _buildSearchResults(ThemeProviderState themeData) {
    final hasAdvocates = _advocateResults.isNotEmpty;
    final hasServices = _serviceResults.isNotEmpty;

    return RefreshIndicator(
      onRefresh: () async {
        _searchService.clearCache();
        await _performSearch(_currentSearchQuery);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Results count
          Text(
            '${_advocateResults.length + _serviceResults.length} results found',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // Advocates section
          if (hasAdvocates) ...[
            _buildSectionHeader(
                'Advocates', _advocateResults.length, themeData),
            const SizedBox(height: 12),
            ..._advocateResults
                .map((advocate) => _buildAdvocateCard(advocate, themeData)),
            const SizedBox(height: 24),
          ],

          // Services section
          if (hasServices) ...[
            _buildSectionHeader('Services', _serviceResults.length, themeData),
            const SizedBox(height: 12),
            ..._serviceResults
                .map((service) => _buildServiceCard(service, themeData)),
          ],
        ],
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(
      String title, int count, ThemeProviderState themeData) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: themeData.isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Build advocate card
  Widget _buildAdvocateCard(
      AdvocateModel advocate, ThemeProviderState themeData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: themeData.isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(advocate.profileImage),
          onBackgroundImageError: (_, __) {},
          child: advocate.profileImage.isEmpty
              ? const Icon(Icons.person, size: 30)
              : null,
        ),
        title: Text(
          advocate.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: themeData.isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              advocate.specialization,
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  advocate.isOnline ? Icons.circle : Icons.circle_outlined,
                  size: 10,
                  color: advocate.isOnline ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  advocate.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: advocate.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.cases_outlined, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${advocate.cases} cases',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: () {
          // Navigate to advocate details or chat
          // Create advocate map for ChatScreen
          final advocateMap = {
            'name': advocate.name,
            'profileImage': advocate.profileImage,
            'specialization': advocate.specialization,
            'isOnline': advocate.isOnline,
            'cases': advocate.cases,
            'clients': advocate.clients,
          };

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                advocate: advocateMap,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build service card
  Widget _buildServiceCard(ServiceModel service, ThemeProviderState themeData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: themeData.isDarkMode ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.miscellaneous_services,
            color: Colors.deepPurple,
            size: 28,
          ),
        ),
        title: Text(
          service.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: themeData.isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: service.description != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  service.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: () {
          // Navigate to service screen
          _navigateToService(service);
        },
      ),
    );
  }

  /// Navigate to service screen
  void _navigateToService(ServiceModel service) {
    // Show message for now - in production, implement proper navigation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${service.title}...'),
        duration: const Duration(seconds: 1),
      ),
    );

    // TODO: Implement proper service navigation based on service.screen
    // Example:
    // if (service.screen == 'LegalNotice') {
    //   Navigator.push(context, MaterialPageRoute(builder: (_) => LegalNoticeScreen()));
    // }
  }
}

/// Search filter enum
enum SearchFilter {
  all,
  advocates,
  services,
}
