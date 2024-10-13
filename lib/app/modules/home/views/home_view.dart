import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/logo app.png',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 20),
            // Nama aplikasi
            Text(
              'SPORTIFY',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF262626),
              ),
            ),
            SizedBox(height: 10),
            // Subtitle
            Text(
              'Saatnya untuk berolahraga....',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 5),
            // Deskripsi
            Text(
              'Atur jadwal olahraga harianmu dan mulai perjalanan kebugaranmu sekarang!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFFFFFFF),
              ),
            ),
            SizedBox(height: 50),
            // Tombol Get Started (tanpa logika navigasi)
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.LOGIN);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.black, // Diganti dari primary ke backgroundColor
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
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