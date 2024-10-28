import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';


class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

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
                const SizedBox(height: 30),
                // Tombol Register
                ElevatedButton(
                  onPressed: () {
                    // Menampilkan dialog saat tombol diklik
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Registrasi Berhasil'),
                          content: const Text('Silahkan Login!'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                // Menutup dialog dan berpindah ke halaman LOGIN
                                Get.back(); // Menutup dialog
                                Get.toNamed(Routes.LOGIN); // Navigasi ke halaman login
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
                    'Register',
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
