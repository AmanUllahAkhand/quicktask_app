import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/constants.dart';
import '../../models/news_article.dart';

class NewsApiService {
  Future<NewsArticle> fetchNews() async {
    final response = await http.get(Uri.parse(Constants.newsApiUrl + Constants.newsApiKey));

    if (response.statusCode == 200) {
      return NewsArticle.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }
}