import 'package:dio/dio.dart';

class NewsService {
  static const String _baseUrl = 'https://gnews.io/api/v4';
  static const String _apiKey =
      'd59a5a5428e2ece3fbc1f6aaaa200cc4'; // Your API key

  final Dio _dio = Dio();

  Future<List<Map<String, dynamic>>> fetchNews({
    String query = 'example',
    String lang = 'en',
    String country = 'us',
    int max = 10,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/search',
        queryParameters: {
          'q': query,
          'lang': lang,
          'country': country,
          'max': max,
          'apikey': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articles = response.data['articles'] ?? [];
        return articles
            .map((article) => {
                  'title': article['title'] ?? 'No Title',
                  'description': article['description'] ?? 'No Description',
                  'image': article['image'] ?? 'assets/images/bg4.jpg',
                  'url': article['url'] ?? '',
                  'source': article['source']['name'] ?? 'Unknown Source',
                  'publishedAt': article['publishedAt'] ?? '',
                  'author': article['source']['url'] ?? 'Unknown',
                })
            .cast<Map<String, dynamic>>()
            .toList();
      } else {
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching news: ${e.message}');
    }
  }
}
