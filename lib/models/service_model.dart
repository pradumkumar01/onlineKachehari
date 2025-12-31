/// Model for Legal Services
class ServiceModel {
  final String id;
  final String title;
  final String icon;
  final String screen;
  final String? description;

  ServiceModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.screen,
    this.description,
  });

  /// Create from Firestore document
  factory ServiceModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ServiceModel(
      id: id,
      title: data['title'] ?? '',
      icon: data['icon'] ?? 'miscellaneous_services',
      screen: data['screen'] ?? '',
      description: data['description'],
    );
  }

  /// Create from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json, String id) {
    return ServiceModel(
      id: id,
      title: json['title'] ?? '',
      icon: json['icon'] ?? 'miscellaneous_services',
      screen: json['screen'] ?? '',
      description: json['description'],
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'titleLower': title.toLowerCase(), // For case-insensitive search
      'icon': icon,
      'screen': screen,
      'description': description,
      'searchKeywords': _generateSearchKeywords(),
    };
  }

  /// Generate search keywords
  List<String> _generateSearchKeywords() {
    List<String> keywords = [];
    keywords.addAll(title.toLowerCase().split(' '));
    if (description != null) {
      keywords.addAll(description!.toLowerCase().split(' '));
    }
    return keywords.toSet().toList();
  }

  /// Check if service matches search query
  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
        (description?.toLowerCase().contains(lowerQuery) ?? false);
  }
}
