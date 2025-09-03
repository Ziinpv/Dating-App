class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final int age;
  final String location;
  final String bio;
  final List<String> photos;
  final List<String> interests;
  final String gender;
  final String lookingFor;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final bool isOnline;
  final DateTime? lastSeen;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.age,
    required this.location,
    required this.bio,
    required this.photos,
    required this.interests,
    required this.gender,
    required this.lookingFor,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.isOnline = false,
    this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      age: json['age'] ?? 0,
      location: json['location'] ?? '',
      bio: json['bio'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      interests: List<String>.from(json['interests'] ?? []),
      gender: json['gender'] ?? '',
      lookingFor: json['lookingFor'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      isVerified: json['isVerified'] ?? false,
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null ? DateTime.parse(json['lastSeen']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'age': age,
      'location': location,
      'bio': bio,
      'photos': photos,
      'interests': interests,
      'gender': gender,
      'lookingFor': lookingFor,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isVerified': isVerified,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    int? age,
    String? location,
    String? bio,
    List<String>? photos,
    List<String>? interests,
    String? gender,
    String? lookingFor,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      photos: photos ?? this.photos,
      interests: interests ?? this.interests,
      gender: gender ?? this.gender,
      lookingFor: lookingFor ?? this.lookingFor,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
