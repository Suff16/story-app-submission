// User Model
class User {
  final String userId;
  final String name;
  final String token;

  User({required this.userId, required this.name, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'name': name, 'token': token};
  }
}

// Story Model
class Story {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  Story({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      lat: json['lat']?.toDouble(),
      lon: json['lon']?.toDouble(),
    );
  }
}

// API Response Models
class LoginResponse {
  final bool error;
  final String message;
  final User? loginResult;

  LoginResponse({required this.error, required this.message, this.loginResult});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      loginResult: json['loginResult'] != null
          ? User.fromJson(json['loginResult'])
          : null,
    );
  }
}

class RegisterResponse {
  final bool error;
  final String message;

  RegisterResponse({required this.error, required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class StoriesResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  StoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) {
    var list = json['listStory'] as List? ?? [];
    List<Story> stories = list.map((i) => Story.fromJson(i)).toList();

    return StoriesResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      listStory: stories,
    );
  }
}

class AddStoryResponse {
  final bool error;
  final String message;

  AddStoryResponse({required this.error, required this.message});

  factory AddStoryResponse.fromJson(Map<String, dynamic> json) {
    return AddStoryResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
