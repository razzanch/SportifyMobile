import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

// ignore: must_be_immutable
class HomepageView extends GetView<HomeController> {
  
  HomepageView({super.key});

  int currentIndexnav = 0;

  

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

  // Daftar gambar yang akan ditampilkan secara bergantian
  final List<String> rotatingImages = [
    'assets/quote.png',
    'assets/ronaldo.png',
    'assets/ricardo.png',
    'assets/lindan.png',
    'assets/federer.png',
  ];

  // Indeks gambar yang sedang ditampilkan
  final RxInt currentIndex = 0.obs;

  

  @override
  Widget build(BuildContext context) {
    
    // Timer untuk mengubah gambar setiap beberapa detik
    Future.delayed(Duration(seconds: 1), () {
      if (currentIndex.value < rotatingImages.length - 1) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }
      // Restart timer
      Future.delayed(Duration(seconds: 0), () {});
    });

    return Scaffold(
      backgroundColor: Colors.black, // Ubah background menjadi hitam
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Column(
          children: [
            const SizedBox(height: 10), // Adjust this value to control the space above the TextField
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1f1f1f),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                onChanged: (value) {
                  print('Olahraga yang dicari: $value');
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari Olahraga',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0), // Adjust this value to control the vertical position
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 20.0,
              child: ClipOval(
                child: Image.asset(
                  'assets/permana.jpg',
                  fit: BoxFit.cover,
                  width: 40.0,
                  height: 40.0,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10), // Jarak antara konten
              const SizedBox(height: 10),
              // Menampilkan gambar yang berputar
              Obx(() => Container(
                margin: const EdgeInsets.only(left: 10.0, right: 20.0, bottom: 10.0),
                padding: const EdgeInsets.all(10.0), // Padding di dalam container
                decoration: BoxDecoration(
                  color: const Color(0xFF1f1f1f), // Warna container
                  borderRadius: BorderRadius.circular(20.0), // Sudut melengkung
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        rotatingImages[currentIndex.value],
                        fit: BoxFit.cover,
                        height: 200, // Mengatur tinggi gambar
                      ),
                    ),
                    // Indikator lingkaran
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(rotatingImages.length, (index) {
                        return Container(
                          margin: const EdgeInsets.all(5.0),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == currentIndex.value ? Colors.white : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              )),
              // Memindahkan teks di sini, di bawah tampilan gambar
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: const Text(
                  'Olahraga yang tersedia',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
              // Container untuk menampung gambar
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                padding: const EdgeInsets.all(10.0), // Padding di dalam container
                decoration: BoxDecoration(
                  color: const Color(0xFF1f1f1f), // Warna container
                  borderRadius: BorderRadius.circular(20.0), // Sudut melengkung
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: imageNames.length, // Menggunakan jumlah gambar dalam daftar
                  physics: const NeverScrollableScrollPhysics(), // Mencegah scroll di dalam GridView
                  shrinkWrap: true, // Mengatur ukuran GridView agar sesuai dengan konten
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: GestureDetector(
                        onTap: () {
                          _showConfirmationDialog(context, index);
                        },
                        child: Image.asset(
                          imageNames[index],
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
      ),
      // Bottom Navigation Bar (Navbar)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Menampilkan semua item
        backgroundColor: Colors.red[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndexnav, // Menandakan halaman profil sedang aktif
        onTap: (index) {
          switch (index) {
            case 0:
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
            case 1:
              Get.toNamed(Routes.SUCCED);
              break;
            case 2:
              // Navigasi ke halaman news
              Get.toNamed(Routes.NEWS);
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

  void _showConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi', style: TextStyle(color: Colors.black)),
          content: const Text('Apakah Anda ingin memilih jadwal olahraga ini?', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: const Text('Tidak', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                Get.toNamed(Routes.SUCCED);
              },
              child: const Text('Iya', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
