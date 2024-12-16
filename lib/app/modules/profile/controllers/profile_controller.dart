import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/connection/controllers/connection_controller.dart';

class ProfileController extends GetxController {
  var photoUrl = ''.obs;
  var nama = ''.obs;
  var nomorhandphone = ''.obs;
  var email = ''.obs;
  var instagram = ''.obs;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorhandphoneController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();

  final storage = GetStorage(); // Initialize GetStorage

  // Fungsi untuk memuat data pengguna dari Firestore
  Future<void> loadUserData() async {
    String? userId = getCurrentUserId();

    if (userId != null) {
      final doc = await FirebaseFirestore.instance
          .collection('profile')
          .doc(userId)
          .get();

      if (doc.exists) {
        photoUrl.value = doc['photo_url'] ?? '';
        nama.value = doc['nama'] ?? '';
        nomorhandphone.value = doc['nomorhandphone'] ?? '';
        email.value = doc['email'] ?? '';
        instagram.value = doc['instagram'] ?? '';

        // Update TextEditingController dengan nilai terbaru
        namaController.text = nama.value;
        nomorhandphoneController.text = nomorhandphone.value;
        emailController.text = email.value;
        instagramController.text = instagram.value;
      }
    }
  }

  // Mendapatkan user ID dari Firebase Auth
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Menyimpan data ke Firestore
  Future<void> saveData(String userId) async {
    Map<String, dynamic> data = {
      'photo_url': photoUrl.value,
      'nama': nama.value,
      'nomorhandphone': nomorhandphone.value,
      'email': email.value,
      'instagram': instagram.value,
    };

    try {
      // Periksa koneksi menggunakan ConnectionController
      if (Get.find<ConnectionController>().isConnected.value) {
        // Jika terkoneksi, simpan ke Firestore
        await FirebaseFirestore.instance
            .collection('profile')
            .doc(userId)
            .set(data);
        storage.remove(
            'local_profile_data'); // Hapus data lokal jika berhasil disimpan
        print('Data berhasil disimpan ke Firestore.');
      } else {
        // Jika tidak terkoneksi, simpan ke penyimpanan lokal
        storage.write('local_profile_data', data);
        print('Koneksi terputus. Data disimpan secara lokal.');
      }

      // Print seluruh isi data yang ada di GetStorage
      print('Isi GetStorage (local_profile_data):');
      Map<String, dynamic>? storedData = storage.read('local_profile_data');
      if (storedData != null) {
        storedData.forEach((key, value) {
          print('$key: $value');
        });
      } else {
        print('Tidak ada data di GetStorage.');
      }
    } catch (e) {
      print('Error menyimpan data: $e');
    }
  }

// Fungsi untuk sinkronisasi data lokal ke Firestore jika koneksi aktif
  Future<void> syncLocalData(String userId) async {
    // Periksa apakah koneksi tersedia
    if (Get.find<ConnectionController>().isConnected.value) {
      Map<String, dynamic>? localData = storage.read('local_profile_data');

      if (localData != null) {
        try {
          await FirebaseFirestore.instance
              .collection('profile')
              .doc(userId)
              .set(localData);
          storage.remove('local_profile_data');
          print('Data lokal berhasil disinkronisasi ke Firestore.');
          // Print seluruh isi data yang ada di GetStorage
          print('Isi GetStorage (local_profile_data):');
          Map<String, dynamic>? storedData = storage.read('local_profile_data');
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

  // Fungsi untuk memunculkan dialog pemilihan sumber gambar
  Future<void> showImageSourceDialog(String userId) async {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pilih Sumber Gambar"),
          content: Text(
              "Pilih apakah Anda ingin mengambil foto dari Kamera atau Galeri."),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await pickProfileImage(userId, ImageSource.camera);
              },
              child: Text("Kamera"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await pickProfileImage(userId, ImageSource.gallery);
              },
              child: Text("Galeri"),
            ),
          ],
        );
      },
    );
  }

  // Memilih dan mengunggah foto profil dari sumber yang dipilih
  // Fungsi untuk memilih gambar dari kamera atau galeri
  Future<void> pickProfileImage(String userId, ImageSource camera) async {
    // Menampilkan dialog untuk memilih antara Kamera atau Galeri
    await Get.defaultDialog(
      title: "Pilih Sumber Gambar",
      middleText: "Pilih antara Kamera atau Galeri untuk foto profil.",
      actions: [
        TextButton(
          onPressed: () {
            // Memilih dari Galeri
            pickProfileImageFromGallery(userId);
            Get.back();
          },
          child: Text("Galeri"),
        ),
        TextButton(
          onPressed: () {
            // Memilih dari Kamera
            pickProfileImageWithCamera(userId);
            Get.back();
          },
          child: Text("Kamera"),
        ),
      ],
    );
  }

  Future<void> pickProfileImageFromGallery(String userId) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await uploadProfileImage(File(pickedFile.path), userId);
      await Future.delayed(Duration(milliseconds: 500));
      photoUrl.refresh();
      Get.snackbar("Sukses", "Foto profil berhasil diunggah!");
      Get.back();
    } else {
      Get.snackbar("Gagal", "Tidak ada foto yang dipilih!");
    }
  }

  // Fungsi untuk memilih gambar dari kamera
  Future<void> pickProfileImageWithCamera(String userId) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await uploadProfileImage(File(pickedFile.path), userId);
      await Future.delayed(Duration(milliseconds: 500));
      photoUrl.refresh();
      Get.snackbar("Sukses", "Foto profil berhasil diunggah!");
      Get.back();
    } else {
      Get.snackbar("Gagal", "Tidak ada foto yang dipilih!");
    }
  }

  // Mengunggah foto profil ke Firebase Storage
  Future<void> uploadProfileImage(File imageFile, String userId) async {
    try {
      String fileName = imageFile.path.split('/').last;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/$userId/$fileName');

      await storageRef.putFile(imageFile);

      String downloadUrl = await storageRef.getDownloadURL();

      // Update photo URL di Firestore
      await FirebaseFirestore.instance
          .collection('profile')
          .doc(userId)
          .set({'photo_url': downloadUrl}, SetOptions(merge: true));

      photoUrl.value = downloadUrl;
    } catch (e) {
      Get.snackbar("Error", "Gagal mengunggah foto profil: $e");
    }
  }
}
