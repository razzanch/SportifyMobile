import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/homepage/controllers/homepage_controller.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class HomepageView extends StatelessWidget {
  // Mengambil instance HomepageController menggunakan GetX
  final HomepageController controller = Get.put(HomepageController());
  final ProfileController _profileController = Get.put(ProfileController());

  int currentIndexNow = 0;

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

  final List<String> sportNames = [
    "Sepak Bola",
    "Futsal",
    "Bulutangkis",
    "Pencak Silat",
    "Berenang",
    "Basket",
    "Tennis",
    "Karate",
    "Taekwondo",
    "Voly",
  ];

  final List<String> rotatingImages = [
    'assets/quote.png',
    'assets/ronaldo.png',
    'assets/ricardo.png',
    'assets/lindan.png',
    'assets/federer.png',
  ];

  // Reactive int untuk mengganti gambar yang sedang ditampilkan
  final RxInt currentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    // Setiap 1 detik, update gambar yang ditampilkan
    Future.delayed(Duration(seconds: 1), () {
      if (currentIndex.value < rotatingImages.length - 1) {
        currentIndex.value++;
      } else {
        currentIndex.value = 0;
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1f1f1f),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Obx(() {
                return TextField(
                  controller: controller.textController,
                  onChanged: (value) {
                    controller.recognizedText.value = value;
                    controller.searchForSport(
                        value); // Panggil pencarian saat teks berubah
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Cari Olahraga',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isListening.value
                            ? Icons.mic
                            : Icons.mic_none,
                        color: Colors.white,
                      ),
                      onPressed: controller.toggleListening,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                );
              }),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() => CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 20.0,
                  backgroundImage: _profileController.photoUrl.value.isNotEmpty
                      ? NetworkImage(_profileController.photoUrl.value)
                      : AssetImage('assets/profildefault.png') as ImageProvider,
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Menampilkan gambar yang berputar
              Obx(() => Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 20.0, bottom: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1f1f1f),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset(
                            rotatingImages[currentIndex.value],
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                        ),
                        // Indikator lingkaran
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(rotatingImages.length, (index) {
                            return Container(
                              margin: const EdgeInsets.all(5.0),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == currentIndex.value
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  )),
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
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF1f1f1f),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Obx(() {
                  // Mendapatkan hasil pencarian yang langsung ter-update
                  var filteredResults = controller.searchResults.isEmpty
                      ? imageNames
                      : controller.searchResults
                          .map((index) => imageNames[index])
                          .toList();

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: filteredResults.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigasi ke CreateSchedule dengan parameter nama olahraga yang sesuai
                            Get.toNamed(Routes.CREATE_SCHEDULE, arguments: {
                              'name': sportNames[
                                  controller.searchResults.isEmpty
                                      ? index
                                      : controller.searchResults[index]],
                              'isEdit': false,
                              'location': '',
                              'date': '',
                            });
                          },
                          child: Image.asset(
                            filteredResults[
                                index], // Menampilkan gambar sesuai dengan hasil pencarian
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.red[700],
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white70,
  currentIndex: currentIndexNow,
  onTap: (index) {
    switch (index) {
      case 0:
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Peringatan'),
              content: const Text('Anda sedang berada di halaman HomePage'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        break;
        
      case 1:
        Get.toNamed(Routes.SCHEDULE);
        break;
      case 2:
      Get.toNamed(Routes.NEWS);
        break;
        
      case 3:
      Get.toNamed(Routes.PLAYBACKS); // Arahkan ke Playbacks
        break;
       
      case 4:
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
            if (currentIndex == 0)
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
            Icon(Icons.newspaper),
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
            Icon(Icons.play_arrow), // Icon Playbacks
          ],
        ),
      ),
      label: 'Playbacks',
    ),
    BottomNavigationBarItem(
      icon: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentIndex == 4)
              Container(
                height: 3,
                width: 34,
                color: Colors.white,
              ),
            Icon(Icons.person),
          ],
        ),
      ),
      label: 'Profile',
    ),
  ],
),
    );
  }
}