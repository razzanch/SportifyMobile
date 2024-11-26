import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

import '../../../data/models/article.dart';
import '../controllers/article_detail_controller.dart';

class ArticleDetailView extends GetView<ArticleDetailController> {
  final ArticleElement article;

  const ArticleDetailView({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang hitam
      appBar: AppBar(
        title: const Text('News App'),
        backgroundColor: Colors.black, // Warna AppBar hitam
        iconTheme: const IconThemeData(color: Colors.white), // Tombol Back warna putih
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20), // Teks AppBar warna putih
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: article.image, // Menggunakan 'image' sebagai tag untuk Hero
              child: article.image.isNotEmpty
                  ? Image.network(
                      article.image,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: Colors.grey,
                      child: const Center(
                        child: Text(
                          'No Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white), // Teks putih
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.description.isNotEmpty ? article.description : "-",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white), // Teks putih
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white), // Teks putih
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    'Published At: ${article.publishedAt}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white), // Teks putih
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Source: ${article.source.name}', // Menampilkan nama sumber
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white), // Teks putih
                  ),
                  const Divider(color: Colors.grey),
                  Text(
                    article.content.isNotEmpty ? article.content : "-",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white), // Teks putih
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text('Read more'),
                    onPressed: () {
                      Get.toNamed(Routes.ARTICLE_DETAIL_WEBVIEW, arguments: article);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800], // Tombol dengan warna lebih gelap
                      foregroundColor: Colors.white, // Teks tombol putih
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
