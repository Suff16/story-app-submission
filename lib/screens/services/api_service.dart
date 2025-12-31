import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/models.dart';

class ApiService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';

  // Register
  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      return RegisterResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return RegisterResponse(error: true, message: 'Failed to register: $e');
    }
  }

  // Login
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      return LoginResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return LoginResponse(error: true, message: 'Failed to login: $e');
    }
  }

  // Get All Stories
  Future<StoriesResponse> getStories(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stories'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return StoriesResponse.fromJson(jsonDecode(response.body));
      } else {
        return StoriesResponse(
          error: true,
          message: 'Failed to load stories',
          listStory: [],
        );
      }
    } catch (e) {
      return StoriesResponse(
        error: true,
        message: 'Failed to load stories: $e',
        listStory: [],
      );
    }
  }

  // Get Story Detail
  Future<Story?> getStoryDetail(String token, String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stories/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data['error']) {
          return Story.fromJson(data['story']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Add New Story
  Future<AddStoryResponse> addStory(
    String token,
    File imageFile,
    String description,
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/stories'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['description'] = description;

      var multipartFile = await http.MultipartFile.fromPath(
        'photo',
        imageFile.path,
      );
      request.files.add(multipartFile);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return AddStoryResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      return AddStoryResponse(error: true, message: 'Failed to add story: $e');
    }
  }
}
