import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:myapp/app/modules/connection/controllers/connection_controller.dart';


class CreateScheduleController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = ''.obs;
  final storage = GetStorage(); // Initialize GetStorage

  // Fungsi untuk mendapatkan koordinat dari alamat menggunakan OpenCage API
  Future<void> getCoordinatesFromAddress(String addressInput) async {
    final apiKey =
        '419aef5d70d64449a1a882ded88bd465'; // Ganti dengan API Key Anda
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$addressInput&key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          latitude.value = data['results'][0]['geometry']['lat'];
          longitude.value = data['results'][0]['geometry']['lng'];

          // Menampilkan hasil latitude dan longitude di debug console
          print('Latitude: ${latitude.value}');
          print('Longitude: ${longitude.value}');

          // Menampilkan Snackbar jika koordinat berhasil ditemukan
          Get.snackbar(
            'Target Location Found',
            'Latitude: ${latitude.value}\nLongitude: ${longitude.value}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          print("Alamat tidak ditemukan");
          // Menampilkan Snackbar jika alamat tidak ditemukan
          Get.snackbar(
            'Koordinat Tidak Ditemukan',
            'Alamat yang Anda masukkan tidak ditemukan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print("Error fetching data");
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      // Menampilkan Snackbar jika terjadi kesalahan
      Get.snackbar(
        'Terjadi Kesalahan',
        'Tidak dapat menghubungi server geocoding.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

 String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Fungsi untuk sinkronisasi data lokal ke Firestore jika koneksi aktif
Future<void> syncLocalData(String userId) async {
  // Periksa apakah koneksi tersedia
  if (Get.find<ConnectionController>().isConnected.value) {
    Map<String, dynamic>? localData = storage.read('local_schedule_data');
    
    if (localData != null) {
      try {
        await FirebaseFirestore.instance.collection('sports').doc(userId).set(localData);
        storage.remove('local_schedule_data');
        print('Data lokal berhasil disinkronisasi ke Firestore.');
         // Print seluruh isi data yang ada di GetStorage
    print('Isi GetStorage (local_profile_data):');
    Map<String, dynamic>? storedData = storage.read('local_schedule_data');
    if (storedData != null) {
      storedData.forEach((key, value) {
        print('$key: $value');
      });
    } else {
      print('Tidak ada data di GetStorage.');
    }
      } catch (e) {
        print('Error saat menyinkronkan data lokal: $e');
      }
    }
  }
}
}