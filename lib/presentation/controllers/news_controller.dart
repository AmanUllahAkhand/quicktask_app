import 'package:get/get.dart';
import '../../../domain/repositories/news_repository.dart';
import '../../../data/models/news_article.dart';

class NewsController extends GetxController {
  final NewsRepository newsRepository;

  NewsController(this.newsRepository);

  var articles = <Articles>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchNews();
    super.onInit();
  }

  Future<void> fetchNews() async {
    try {
      isLoading(true);
      final news = await newsRepository.fetchNews();
      articles.assignAll(news.articles ?? []);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load news');
    } finally {
      isLoading(false);
    }
  }
}