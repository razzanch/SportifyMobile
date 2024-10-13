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
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Memastikan teks terletak di kiri dan kanan
                  children: [
                    // Teks di sebelah kiri
                    TextButton(
                      onPressed: () {
                        // Aksi lupa password di kiri
                      },
                      child: const Text(
                        'Belum punya akun? Daftar',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    // Teks di sebelah kanan
                    TextButton(
                      onPressed: () {
                        // Aksi lupa password di kanan
                      },
                      child: const Text('Lupa Password?'),
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
                                // Menutup dialog dan berpindah ke halaman Profile
                                Get.back(); // Menutup dialog
                                // Navigasi ke halaman profile
                                Get.toNamed(Routes.HOMEPAGE);
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
                const SizedBox(height: 10),

                // Garis pembatas
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('atau'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 10),
                // Tombol Sosial Media
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Aksi Google
                      },
                      icon: Image.asset(
                        'assets/google.png',
                        height: 40, // Ukuran tinggi logo
                        width: 40, // Ukuran lebar logo
                      ),
                      label: const Text('Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Aksi LinkedIn
                      },
                      icon: Image.asset(
                        'assets/linkedin.png',
                        height: 40, // Ukuran tinggi logo
                        width: 40, // Ukuran lebar logo
                      ),
                      label: const Text('LinkedIn'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Aksi Instagram
                  },
                  icon: Image.asset(
                    'assets/instagram.jpg',
                    height: 20, // Ukuran tinggi logo
                    width: 40, // Ukuran lebar logo
                  ),
                  label: const Text('Instagram'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width: 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 85, vertical: 10),
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
