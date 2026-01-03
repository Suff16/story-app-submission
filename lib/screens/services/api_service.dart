import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../models/models.dart';
import '../../config/flavor_config.dart';

class ApiService {
  final String baseUrl = FlavorConfig.instance.apiBaseUrl;

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

  Future<StoriesResponse> getStories(
    String token, {
    int page = 1,
    int size = 10,
    int location = 0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stories?page=$page&size=$size&location=$location'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return StoriesResponse.fromJson(jsonDecode(response.body));
      } else {
        return const StoriesResponse(
          error: true,
          message: 'Failed to load stories',
          listStory: [],
        );
      }
    } catch (e) {
      return StoriesResponse(
        error: true,
        message: 'Failed to load stories: $e',
        listStory: const [],
      );
    }
  }

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

  Future<AddStoryResponse> addStory(
    String token,
    File imageFile,
    String description, {
    double? lat,
    double? lon,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/stories'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.fields['description'] = description;

      if (lat != null && lon != null) {
        request.fields['lat'] = lat.toString();
        request.fields['lon'] = lon.toString();
      }

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
