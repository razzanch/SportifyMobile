import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/modules/login/views/login_view.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  final HomeController isLoggedIn = Get.put(HomeController());
  Stream<User?> get streamAuthStatus => _auth.authStateChanges();

  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar('Success', 'Registration successful',
          backgroundColor: Colors.green);
      Get.off(LoginView()); // Navigasi ke halaman Login
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void login(String email, String password) async {
    try {
      // Proses login ke Firebase dengan email dan password
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Jika berhasil login, simpan status login di SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'token', 'your_token_value'); // atau simpan tanda autentikasi lainnya

      // Menampilkan notifikasi keberhasilan login
      Get.snackbar('Success', 'Login successful',
          backgroundColor: Colors.green);
      isLoggedIn.isLoggedIn = true.obs;
      // Jika berhasil login, arahkan ke HOME
      Get.offAllNamed(Routes.HOMEPAGE);
    } on FirebaseAuthException catch (e) {
      // Tangani setiap error yang terjadi berdasarkan kode error dari Firebase
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        Get.snackbar('Error', 'The email format is invalid.');
      } else if (e.code == 'user-disabled') {
        Get.snackbar('Error', 'This user has been disabled.');
      } else {
        Get.snackbar('Error', e.message ?? 'An unknown error occurred.');
      }
    } catch (e) {
      // Tangani error lain yang tidak berhubungan dengan FirebaseAuthException
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();

    // Hapus token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Arahkan ke halaman login
    Get.offAllNamed(Routes.LOGIN);
  }
}
