import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class ScheduleController extends GetxController {
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  // Observables
  RxBool isListening = false.obs; // Status apakah sedang mendengarkan
  RxString recognizedText = ''.obs; // Teks hasil Speech-to-Text
  TextEditingController textController = TextEditingController(); // Kontrol input TextField
  RxList<DocumentSnapshot> searchResults = RxList<DocumentSnapshot>(); // Hasil pencarian
  RxList<DocumentSnapshot> allSportsDocs = RxList<DocumentSnapshot>(); // Semua dokumen olahraga

  // Inisialisasi speech-to-text
  Future<void> initializeSpeech() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      bool available = await _speechToText.initialize();
      if (!available) {
        print("Speech-to-text tidak tersedia");
      }
    } else {
      print("Permission tidak diberikan");
    }
  }

  // Ambil data olahraga dari Firestore
  void fetchSportsData() {
    FirebaseFirestore.instance
        .collection('sports')
        .snapshots()
        .listen((querySnapshot) {
      allSportsDocs.value = querySnapshot.docs;
      searchResults.value = querySnapshot.docs; // Tampilkan semua data awal
    });
  }

  // Aktifkan atau hentikan mendengarkan suara
  void toggleListening() async {
    if (isListening.value) {
      _speechToText.stop();
      isListening.value = false;
    } else {
      _speechToText.listen(
        onResult: (result) {
          recognizedText.value = result.recognizedWords; // Teks hasil suara
          textController.text = recognizedText.value; // Update TextField
          print('Olahraga yang dicari: ${recognizedText.value}');
          searchForSport(recognizedText.value); // Pencarian langsung
        },
      );
      isListening.value = true;
    }
  }

  // Cari olahraga berdasarkan input
  void searchForSport(String query) {
    if (query.isEmpty) {
      searchResults.value = allSportsDocs; // Jika kosong, tampilkan semua data
    } else {
      searchResults.value = allSportsDocs
          .where((doc) =>
              (doc.data() as Map<String, dynamic>)['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    initializeSpeech(); // Inisialisasi speech-to-text
    fetchSportsData(); // Ambil data olahraga
    textController.addListener(() {
      searchForSport(textController.text); // Pencarian otomatis saat input berubah
    });
  }
}
