import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Tambahkan GetX untuk navigasi
import 'package:myapp/app/routes/app_pages.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon atau Logo
                Image.asset(
                  'assets/logo app.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                // Nama Aplikasi
                const Text(
                  'SPORTIFY',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // Deskripsi Aplikasi
                const Text(
                  'Aplikasi latihan olahraga Anda',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                // Input Username
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Input Password
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Teks "Belum punya akun? Daftar" untuk navigasi ke halaman Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigasi ke halaman Register
                        Get.toNamed(Routes.REGISTER);
                      },
                      child: const Text(
                        'Belum punya akun? Daftar',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Tombol Login
                ElevatedButton(
                  onPressed: () {
                    // Menampilkan dialog saat tombol diklik
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Login Berhasil'),
                          content: const Text('Anda telah berhasil masuk.'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                // Menutup dialog dan berpindah ke halaman Homepage
                                Get.back(); // Menutup dialog
                                Get.toNamed(Routes.HOMEPAGE); // Navigasi ke halaman homepage
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
