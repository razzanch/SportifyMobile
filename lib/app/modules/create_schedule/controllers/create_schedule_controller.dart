import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:myapp/app/modules/connection/controllers/connection_controller.dart';


class CreateScheduleController extends GetxController {
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = ''.obs;

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

  final GetStorage storage = GetStorage('local_schedule_data');
  
  // Fungsi untuk sinkronisasi data lokal ke Firestore jika koneksi aktif
  Future<void> syncLocalData() async {
    // Periksa apakah koneksi tersedia
    if (Get.find<ConnectionController>().isConnected.value) {
      // Ambil data lokal yang disimpan dengan key 'schedules'
      final List<Map<String, dynamic>>? localData = storage.read<List<dynamic>>('schedules')?.cast<Map<String, dynamic>>();

      if (localData != null && localData.isNotEmpty) {
        try {
          // Loop untuk menyimpan data lokal satu per satu ke Firestore
          for (var schedule in localData) {
            // Misalnya data sudah memiliki field 'documentId' yang unik
            await FirebaseFirestore.instance.collection('sports').add(schedule);
          }

          // Hapus data lokal setelah berhasil disinkronkan
          storage.remove('schedules');

          // Menampilkan pesan sukses
          print('Data lokal berhasil disinkronisasi ke Firestore.');

          // Debug: Cetak data di GetStorage setelah penghapusan
          print('Isi GetStorage (local_schedule_data) setelah sinkronisasi:');
          final storedData = storage.read<List<dynamic>>('schedules');
          if (storedData != null && storedData.isNotEmpty) {
            storedData.asMap().forEach((index, value) {
              print('Data $index: $value');
            });
          } else {
            print('Tidak ada data di GetStorage.');
          }
        } catch (e) {
          // Tangani jika ada error saat sinkronisasi
          print('Error saat menyinkronkan data lokal: $e');
        }
      } else {
        print('Tidak ada data lokal yang perlu disinkronkan.');
      }
    } else {
      print('Tidak ada koneksi. Tidak dapat menyinkronkan data.');
    }
  }
}
