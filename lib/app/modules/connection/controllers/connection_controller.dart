import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/create_schedule/controllers/create_schedule_controller.dart';


import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final isConnected = true.obs; // Observable untuk status koneksi

  @override
  void onInit() {
    super.onInit();
    // Mendengarkan perubahan konektivitas
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      _updateConnectionStatus(connectivityResult.first);
    });
  }

  // Fungsi untuk mengupdate status koneksi
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      // Jika tidak ada koneksi
      if (isConnected.value) {
        isConnected.value = false;
        _showSnackbar(false);
      }
    } else {
      // Jika ada koneksi
      if (!isConnected.value) {
        isConnected.value = true;
        _showSnackbar(true);

        // Sinkronkan data lokal ke Firestore saat koneksi kembali
        String? userId = Get.find<ProfileController>()
            .getCurrentUserId(); // Mengambil userId dari ProfileController
        if (userId != null) {
          Get.find<CreateScheduleController>().syncLocalData(userId);
        }

        String? userId2 = Get.find<CreateScheduleController>().getCurrentUserId();
        if (userId2 != null) {
          Get.find<CreateScheduleController>().syncLocalData(userId2);
        }
      }
    }
  }

  // Fungsi untuk menampilkan Snackbar
  void _showSnackbar(bool connected) {
    if (connected) {
      // Menutup Snackbar sebelumnya jika koneksi kembali
      Get.closeAllSnackbars();
      Get.snackbar(
        'Connected',
        'You are back online.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } else {
      // Menampilkan Snackbar merah saat tidak ada koneksi
      Get.snackbar(
        'No Internet Connection',
        'Please check your connection.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        isDismissible: false, // Tidak bisa ditutup manual
        duration: Duration(days: 1), // Durasi panjang agar tetap terlihat
      );
    }
  }
}
