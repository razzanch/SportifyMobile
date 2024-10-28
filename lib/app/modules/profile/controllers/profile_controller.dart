import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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
  Future<void> saveDataToFirestore(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('profile').doc(userId).set({
        'photo_url': photoUrl.value,
        'nama': nama.value,
        'nomorhandphone': nomorhandphone.value,
        'email': email.value,
        'instagram': instagram.value,
      });
      print('Data berhasil disimpan.');
    } catch (e) {
      print('Error menyimpan data: $e');
    }
  }

  // Memilih dan mengunggah foto profil
// Memilih dan mengunggah foto profil
  Future<void> pickProfileImage(String userId) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await uploadProfileImage(File(pickedFile.path), userId);

      // Memberikan jeda untuk pembaruan
      await Future.delayed(Duration(milliseconds: 500));
      photoUrl.refresh();

      // Tampilkan snackbar
      Get.snackbar("Sukses", "Foto profil berhasil diunggah!");

      // Kembali ke halaman sebelumnya
      Get.back();
    } else {
      // Jika tidak ada file yang dipilih
      Get.snackbar("Gagal", "Tidak ada foto yang dipilih!");
    }
  }

  // Mengunggah foto profil ke Firebase Storage
  Future<void> uploadProfileImage(File imageFile, String userId) async {
    try {
      String fileName = basename(imageFile.path);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/$userId/$fileName');

      // Unggah gambar
      await storageRef.putFile(imageFile);

      // Ambil URL setelah diunggah
      String downloadUrl = await storageRef.getDownloadURL();
      photoUrl.value = '$downloadUrl?${DateTime.now().millisecondsSinceEpoch}';

      // Print untuk memastikan downloadUrl telah diperbarui
      print('URL baru untuk foto profil: $downloadUrl');

      // Simpan URL di Firestore
      await FirebaseFirestore.instance
          .collection('profile')
          .doc(userId)
          .set({'photo_url': downloadUrl}, SetOptions(merge: true));

      print('Foto profil berhasil diunggah.');
    } catch (e) {
      print('Error mengunggah foto profil: $e');
      Get.snackbar("Error", "Gagal mengunggah foto profil: $e");
    }
  }
}
