import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    // Menggunakan Future.delayed untuk navigasi setelah 5 detik
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(Routes.LOGIN); // Pindah ke halaman LOGIN setelah 5 detik
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
