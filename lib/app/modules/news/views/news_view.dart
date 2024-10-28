import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/article_detail/views/article_detail_view.dart';
import 'package:myapp/app/data/services/news_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class NewsView extends GetView<NewsController> {
  NewsView({Key? key}) : super(key: key);
  int currentIndex = 2; // Indeks halaman yang aktif saat ini

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Articles',
          style: TextStyle(color: Colors.white), // Warna putih untuk teks
        ),
        backgroundColor:
            const Color.fromARGB(255, 0, 0, 0), // Warna hitam untuk AppBar
        iconTheme: const IconThemeData(
            color: Colors.white), // Warna putih untuk ikon back arrow
      ),
      backgroundColor: Color.fromARGB(255, 0, 0, 0), // Latar belakang utama warna hitam
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.articles.isEmpty) {
          return const Center(
              child: Text('No articles available.',
                  style: TextStyle(color: Colors.white)));
        }

        return ListView.builder(
          itemCount: controller.articles.length,
          itemBuilder: (context, index) {
            final article = controller.articles[index];

            return Card(
              color: const Color.fromRGBO(
                  35, 35, 35, 1), // Warna abu-abu untuk latar belakang artikel
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: InkWell(
                onTap: () {
                  Get.to(() => ArticleDetailView(article: article));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menampilkan gambar dari urlToImage
                      article.image.isNotEmpty
                          ? Image.network(
                              article.image,
                              fit: BoxFit.cover,
                              height:
                                  200, // Atur tinggi gambar sesuai kebutuhan
                              width: double.infinity,
                            )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              color: Colors.grey,
                              child: const Center(
                                child: Text(
                                  'No Image Available',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                      const SizedBox(height: 10),
                      Text(
                        article.title,
                        style: const TextStyle(
                          color: Colors.white, // Teks berwarna putih
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        article.description,
                        style: const TextStyle(
                          color: Colors.white70, // Teks deskripsi warna abu-abu
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Published on: ${article.publishedAt}',
                        style: const TextStyle(
                          color:
                              Colors.white60, // Teks tanggal warna lebih pudar
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Menampilkan semua item
        backgroundColor: Colors.red[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndex, // Menandakan halaman profil sedang aktif
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed(Routes.HOMEPAGE);
              break;
            case 1:
              Get.toNamed(Routes.SUCCED);
              break;
            case 2:
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Peringatan'),
                    content: const Text('Anda sedang berada di halaman Berita'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.back(); // Tutup dialog
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
              break;
            case 3:
              Get.toNamed(Routes.PROFILE);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentIndex == 0) // Ganti '2' dengan 'currentIndex'
                    Container(
                      height: 3,
                      width: 34,
                      color: Colors.white,
                    ),
                  Icon(Icons.home),
                ],
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentIndex == 1)
                    Container(
                      height: 3,
                      width: 34,
                      color: Colors.white,
                    ),
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentIndex == 2)
                    Container(
                      height: 3,
                      width: 34,
                      color: Colors.white,
                    ),
                  Icon(Icons.article),
                ],
              ),
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentIndex == 3)
                    Container(
                      height: 3,
                      width: 34,
                      color: Colors.white,
                    ),
                  Icon(Icons.person),
                ],
              ),
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
