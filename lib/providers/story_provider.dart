import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../screens/services/api_service.dart';
import '../screens/services/preferences_service.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesService _prefsService = PreferencesService();

  final List<Story> _stories = [];
  Story? _selectedStory;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  String? _errorMessage;
  String? _successMessage;

  int _currentPage = 1;
  final int _pageSize = 15;

  double? _tempLat;
  double? _tempLon;

  List<Story> get stories => _stories;
  Story? get selectedStory => _selectedStory;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  double? get tempLat => _tempLat;
  double? get tempLon => _tempLon;

  void setTempLocation(double? lat, double? lon) {
    _tempLat = lat;
    _tempLon = lon;
    notifyListeners();
  }

  Future<void> fetchStories({bool refresh = false}) async {
    if (_isLoading || _isLoadingMore) return;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _stories.clear();
    }

    if (!_hasMore) return;

    if (_currentPage == 1) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }

    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _prefsService.getToken();
      if (token == null) {
        _errorMessage = 'No token found';
        return;
      }

      final response = await _apiService.getStories(
        token,
        page: _currentPage,
        size: _pageSize,
      );

      if (response.error) {
        _errorMessage = response.message;
        return;
      }

      final newStories = response.listStory;

      if (newStories.isEmpty) {
        _hasMore = false;
        return;
      }
      final existingIds = _stories.map((e) => e.id).toSet();
      final uniqueStories = newStories
          .where((e) => !existingIds.contains(e.id))
          .toList();
      if (uniqueStories.isEmpty) {
        _hasMore = false;
        return;
      }

      _stories.addAll(uniqueStories);
      _currentPage++;
    } catch (e) {
      _errorMessage = 'Failed to load stories: $e';
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> fetchStoryDetail(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _prefsService.getToken();
      if (token == null) {
        _errorMessage = 'No token found';
        return;
      }

      final story = await _apiService.getStoryDetail(token, id);
      if (story == null) {
        _errorMessage = 'Failed to load story detail';
      } else {
        _selectedStory = story;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addStory(
    File imageFile,
    String description, {
    double? lat,
    double? lon,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final token = await _prefsService.getToken();
      if (token == null) {
        _errorMessage = 'No token found';
        return false;
      }

      final response = await _apiService.addStory(
        token,
        imageFile,
        description,
        lat: lat,
        lon: lon,
      );

      if (response.error) {
        _errorMessage = response.message;
        return false;
      }

      _successMessage = response.message;

      await fetchStories(refresh: true);
      return true;
    } catch (e) {
      _errorMessage = 'Error uploading story: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void clearSelectedStory() {
    _selectedStory = null;
    notifyListeners();
  }
}
