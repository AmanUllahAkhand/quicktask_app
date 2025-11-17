import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/news_article.dart';

class NewsDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Articles article = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text('News Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(article.urlToImage!, height: 220, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              article.title ?? '',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('By ${article.author ?? 'Unknown'} • ${article.source?.name ?? ''}'),
            const SizedBox(height: 16),
            Text(article.description ?? 'No description available.'),
            const SizedBox(height: 16),
            Text(article.content ?? ''),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _launchURL(article.url!),
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Read Full Article'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}