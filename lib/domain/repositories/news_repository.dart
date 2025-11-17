import '../../data/models/news_article.dart';
import '../../data/remote/api/news_api_service.dart';

abstract class NewsRepository {
  Future<NewsArticle> fetchNews();
}

class NewsRepositoryImpl implements NewsRepository {
  final NewsApiService api;
  NewsRepositoryImpl(this.api);

  @override
  Future<NewsArticle> fetchNews() => api.fetchNews();
}