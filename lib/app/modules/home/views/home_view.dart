import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      await homeController.checkLoginStatus(); // Cek status login
      if (homeController.isLoggedIn.value) {
        // Jika sudah login, arahkan ke halaman profil
        Get.offNamed(Routes.HOMEPAGE);
      } else {
        // Jika belum login, arahkan ke halaman login
        Get.offNamed(Routes.LOGIN);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Mengubah latar belakang menjadi hitam
      body: Center(
        child: Image.asset(
          'assets/logo app.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
