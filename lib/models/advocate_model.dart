/// Model for Advocate/Lawyer
class AdvocateModel {
  final String id;
  final String name;
  final String specialization;
  final String profileImage;
  final int cases;
  final int clients;
  final bool isOnline;
  final String email;
  final String phone;
  final String experience;
  final List<String> languages;
  final String education;

  AdvocateModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.profileImage,
    required this.cases,
    required this.clients,
    required this.isOnline,
    required this.email,
    required this.phone,
    required this.experience,
    required this.languages,
    required this.education,
  });

  /// Create from Firestore document
  factory AdvocateModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AdvocateModel(
      id: id,
      name: data['name'] ?? '',
      specialization: data['specialization'] ?? '',
      profileImage: data['profileImage'] ?? '',
      cases: data['cases'] ?? 0,
      clients: data['clients'] ?? 0,
      isOnline: data['isOnline'] ?? false,
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      experience: data['experience'] ?? '',
      languages: List<String>.from(data['languages'] ?? []),
      education: data['education'] ?? '',
    );
  }

  /// Create from JSON
  factory AdvocateModel.fromJson(Map<String, dynamic> json, String id) {
    // Extract details from nested structure
    List<dynamic> details = json['details'] ?? [];

    String getDetail(String title) {
      try {
        return details.firstWhere(
              (d) => d['title'] == title,
              orElse: () => {'content': ''},
            )['content'] ??
            '';
      } catch (e) {
        return '';
      }
    }

    return AdvocateModel(
      id: id,
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      profileImage: json['profileImage'] ?? '',
      cases: json['cases'] ?? 0,
      clients: json['clients'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      email: getDetail('Email'),
      phone: getDetail('Phone'),
      experience: getDetail('Experience'),
      languages: getDetail('Languages').split(', '),
      education: getDetail('Education'),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'nameLower': name.toLowerCase(), // For case-insensitive search
      'specialization': specialization,
      'specializationLower': specialization.toLowerCase(),
      'profileImage': profileImage,
      'cases': cases,
      'clients': clients,
      'isOnline': isOnline,
      'email': email,
      'phone': phone,
      'experience': experience,
      'languages': languages,
      'education': education,
      'searchKeywords': _generateSearchKeywords(), // For better search
    };
  }

  /// Generate search keywords for better search experience
  List<String> _generateSearchKeywords() {
    List<String> keywords = [];

    // Add name parts
    keywords.addAll(name.toLowerCase().split(' '));

    // Add specialization parts
    keywords.addAll(specialization.toLowerCase().split(' '));

    // Add languages
    keywords.addAll(languages.map((l) => l.toLowerCase()));

    return keywords.toSet().toList(); // Remove duplicates
  }

  /// Check if advocate matches search query
  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowerQuery) ||
        specialization.toLowerCase().contains(lowerQuery) ||
        languages.any((lang) => lang.toLowerCase().contains(lowerQuery)) ||
        education.toLowerCase().contains(lowerQuery);
  }
}
