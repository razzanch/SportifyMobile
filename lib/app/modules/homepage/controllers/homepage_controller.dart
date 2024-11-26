import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class HomepageController extends GetxController {
  // Variabel untuk Speech to Text
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  RxBool isListening = false.obs; // Menyimpan status apakah sedang mendengarkan
  // RxString recognizedText =
  //     ''.obs; // Menyimpan teks yang dikenali oleh speech-to-text
  // late TextEditingController textController;
  var textController = TextEditingController();
  var recognizedText = ''.obs; // Menyimpan teks yang diinputkan
  var searchResults = <int>[].obs; // Menyimpan indeks olahraga yang cocok

  // Menyimpan daftar nama olahraga
  final List<String> sportNames = [
    "Sepak Bola",
    "Futsal",
    "Bulutangkis",
    "Pencak Silat",
    "Berenang",
    "Basket",
    "Tennis",
    "Karate",
    "Taekwondo",
    "Voly",
  ];

  // Variabel untuk menyimpan hasil pencarian
  // RxList<int> searchResults =
  //     RxList<int>([]); // Menyimpan indeks olahraga yang cocok

  // Fungsi untuk menginisialisasi speech-to-text dan meminta izin
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

// Fungsi untuk mulai atau berhenti mendengarkan
  void toggleListening() async {
    if (isListening.value) {
      _speechToText.stop();
      isListening.value = false;
    } else {
      _speechToText.listen(
        onResult: (result) {
          recognizedText.value = result.recognizedWords;
          textController.text = recognizedText
              .value; // Update textController dengan recognizedText
          print('Olahraga yang dicari: ${recognizedText.value}');
          searchForSport(recognizedText
              .value); // Pencarian ketika ada hasil dari speech-to-text
        },
      );
      isListening.value = true;
    }
  }

  // Fungsi untuk mencari olahraga yang sesuai dengan input
  void searchForSport(String query) {
    if (query.isEmpty) {
      // Jika query kosong, tampilkan semua olahraga
      searchResults.clear(); // Kosongkan hasil pencarian
    } else {
      // Jika ada query, filter olahraga yang sesuai
      searchResults.value = sportNames
          .asMap() // Mengonversi daftar menjadi Map dengan indeks
          .entries
          .where((entry) =>
              entry.value.toLowerCase().contains(query.toLowerCase()))
          .map((entry) => entry.key) // Ambil index dari olahraga yang cocok
          .toList();
    }
  }

  @override
  void onInit() {
    super.onInit();
    textController = TextEditingController();
    initializeSpeech();
  }

  @override
  void onClose() { // Membersihkan controller saat widget ditutup
    super.onClose();
  }
}