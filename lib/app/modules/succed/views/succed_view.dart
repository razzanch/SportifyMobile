import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

class SuccedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text "Jadwal Berhasil Disimpan"
            Text(
              'Jadwal Berhasil Disimpan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            // Gambar centang hijau
            Image.asset(
              'assets/sukses.png',
              width: 200,
              height: 150,
            ),
            SizedBox(height: 30),
            // Tombol Back to Home
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.HOMEPAGE);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Back to Home',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
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
                Get.toNamed(Routes.HOMEPAGE);
                // Tidak ada logika navigasi
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              tooltip: 'Home',
            ),
            // Icon Schedule
            IconButton(
              padding:
                  EdgeInsets.only(left: 0, right: 0), // Padding kiri dan kanan
              onPressed: () {
                // Tidak ada logika navigasi
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
                  left: 60, right: 60), // Padding kiri dan kanan,
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
}
