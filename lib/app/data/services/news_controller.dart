import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart'; // Pastikan Anda sudah mengimpor model Article yang telah Anda buat

class NewsController extends GetxController {
  final String apiKey = '7441af2afcca484170536935a940ab7f'; // API key
  final String baseUrl = 'https://gnews.io/api/v4/top-headlines';

  var articles = <ArticleElement>[].obs; // Menyimpan daftar artikel
  var isLoading = true.obs; // Status loading

  @override
  void onInit() {
    fetchArticles(); // Mengambil artikel saat controller diinisialisasi
    super.onInit();
  }

  Future<void> fetchArticles() async {
    final url = '$baseUrl?country=us&category=sports&apikey=$apiKey';
    
    try {
      isLoading.value = true; // Set status loading menjadi true
      // Melakukan request GET ke API
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Jika server mengembalikan respons OK, parse data JSON
        final articleResponse = articleFromJson(response.body);
        if (articleResponse != null) {
          articles.value = articleResponse.articles; // Menyimpan daftar artikel
        }
      } else {
        // Jika response tidak OK, throw exception
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      // Menangani error
      print('Error fetching articles: $e');
    } finally {
      isLoading.value = false; // Set status loading menjadi false setelah selesai
    }
  }
}
