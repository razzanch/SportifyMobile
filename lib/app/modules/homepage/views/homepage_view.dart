import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart'; // Pastikan untuk mengimpor halaman detail
import 'package:myapp/app/routes/app_pages.dart';

class HomepageView extends GetView<HomeController> {
  HomepageView({super.key});

  // Daftar nama file gambar
  final List<String> imageNames = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.png',
    'assets/6.png',
    'assets/7.png',
    'assets/8.png',
    'assets/9.png',
    'assets/10.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rakhmat Fadhilah',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10), // Jarak antara nama dan textfield
            TextField(
              onChanged: (value) {
                // Logika pencarian saat teks berubah
                print('Olahraga yang dicari: $value');
              },
              decoration: InputDecoration(
                labelText: 'Cari Olahraga', // Label di dalam TextField
                border: OutlineInputBorder(), // Border untuk TextField
                prefixIcon: const Icon(Icons.search), // Ikon pencarian
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Olahraga yang tersedia',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount:
                    imageNames.length, // Menggunakan jumlah gambar dalam daftar
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: GestureDetector(
                      onTap: () {
                        // Menampilkan dialog konfirmasi
                        _showConfirmationDialog(context, index);
                      }, // Membuat sudut gambar melengkung
                      child: Image.asset(
                        imageNames[
                            index], // Mengambil gambar berdasarkan indeks
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar (Navbar)
      bottomNavigationBar: Container(
        height: 50, // Mengatur tinggi dari BottomAppBar
        color: Colors.red[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Icon Home
            IconButton(
              padding: EdgeInsets.only(
                  left: 60, right: 60), // Padding kiri dan kanan
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Warning'),
                      content: const Text('Anda telah berada di halaman Home'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Menutup dialog dan berpindah ke halaman Profile
                            Get.back(); // Menutup dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              tooltip: 'Home',
            ),
            // Icon Schedule
            IconButton(
              padding: EdgeInsets.zero, // Padding kiri dan kanan
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Halaman belum dibuat'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Menutup dialog dan berpindah ke halaman Profile
                            Get.back(); // Menutup dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              tooltip: 'Schedule',
            ),
            // Icon Profile
            IconButton(
              padding: EdgeInsets.only(
                  left: 60, right: 60), // Padding kiri dan kanan
              onPressed: () {
                Get.toNamed(Routes.PROFILE);
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              tooltip: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi
  void _showConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Apakah Anda ingin memilih jadwal olahraga ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                // Navigasi ke halaman detail olahraga
                Get.toNamed(Routes.SUCCED);
              },
              child: const Text('Iya'),
            ),
          ],
        );
      },
    );
  }
}
