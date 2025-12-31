import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../screens/services/api_service.dart';
import '../screens/services/preferences_service.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final PreferencesService _prefsService = PreferencesService();

  List<Story> _stories = [];
  Story? _selectedStory;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<Story> get stories => _stories;
  Story? get selectedStory => _selectedStory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Fetch all stories
  Future<void> fetchStories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final token = await _prefsService.getToken();
    if (token == null) {
      _errorMessage = 'No token found';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final response = await _apiService.getStories(token);

    _isLoading = false;

    if (response.error) {
      _errorMessage = response.message;
      notifyListeners();
      return;
    }

    _stories = response.listStory;
    notifyListeners();
  }

  // Fetch story detail
  Future<void> fetchStoryDetail(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final token = await _prefsService.getToken();
    if (token == null) {
      _errorMessage = 'No token found';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final story = await _apiService.getStoryDetail(token, id);

    _isLoading = false;

    if (story == null) {
      _errorMessage = 'Failed to load story detail';
      notifyListeners();
      return;
    }

    _selectedStory = story;
    notifyListeners();
  }

  // Add new story
  Future<bool> addStory(File imageFile, String description) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final token = await _prefsService.getToken();
    if (token == null) {
      _errorMessage = 'No token found';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final response = await _apiService.addStory(token, imageFile, description);

    _isLoading = false;

    if (response.error) {
      _errorMessage = response.message;
      notifyListeners();
      return false;
    }

    _successMessage = response.message;
    notifyListeners();

    // Refresh stories list
    await fetchStories();

    return true;
  }

  // Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // Clear selected story
  void clearSelectedStory() {
    _selectedStory = null;
    notifyListeners();
  }
}
