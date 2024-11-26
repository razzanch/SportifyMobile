import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/setting_audio_controller.dart';

class SettingAudioView extends StatelessWidget {
  final SettingAudioController controller = Get.put(SettingAudioController());
  // Instance Firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk menyimpan data audio ke Firebase
  Future<void> _saveAudioToFirebase() async {
    try {
      // Mendapatkan current user
      final User? currentUser = _auth.currentUser;
      
      if (currentUser != null) {
        // Menyimpan data ke collection 'audio' dengan document ID sesuai user ID
        await _firestore.collection('audio').doc(currentUser.uid).set({
          'audio_url': controller.audioUrl.value,
          'updated_at': FieldValue.serverTimestamp(),
        });
        
        // Menampilkan snackbar sukses
        Get.snackbar(
          'Success',
          'Audio URL has been saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No user logged in',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Menampilkan snackbar error
      Get.snackbar(
        'Error',
        'Failed to save audio URL: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Set AppBar color to black
        title: const Text('Setting Audio', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back button
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black, // Set background color of the page to black
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Increase padding for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Row(
                    children: [
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                            text: controller.audioUrl.value,
                          ),
                          style: const TextStyle(color: Colors.white), // Set text color to white
                          decoration: const InputDecoration(
                            labelText: 'Audio URL',
                            labelStyle: TextStyle(color: Colors.white), // White label text
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(controller.isDropdownVisible.value
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down, color: Colors.white), // White icon
                        onPressed: () {
                          controller.isDropdownVisible.value =
                              !controller.isDropdownVisible.value;
                        },
                      ),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => controller.isDropdownVisible.value
                  ? TextField(
                      style: const TextStyle(color: Colors.white), // Set text color to white
                      decoration: const InputDecoration(
                        labelText: 'Enter new Audio URL',
                        labelStyle: TextStyle(color: Colors.white), // White label text
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          controller.audioUrl.value = value;
                          controller.isDropdownVisible.value = false;
                        }
                      },
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 16),
              Obx(() {
                return Column(
                  children: [
                    Slider(
                      min: 0.0,
                      max: controller.duration.value.inSeconds.toDouble(),
                      value: controller.position.value.inSeconds.toDouble(),
                      onChanged: (value) {
                        controller.seekAudio(Duration(seconds: value.toInt()));
                      },
                    ),
                    Text(
                      '${_formatDuration(controller.position.value)} / ${_formatDuration(controller.duration.value)}',
                      style: const TextStyle(color: Colors.white), // White text
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: controller.isPlaying.value
                              ? controller.pauseAudio
                              : controller.resumeAudio,
                          child: Text(
                              controller.isPlaying.value ? 'Pause' : 'Resume'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent, // Button color
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: controller.playAudio,
                          child: const Text('Play'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Play button color
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: controller.stopAudio,
                          child: const Text('Stop'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Stop button color
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Tombol Save
                    ElevatedButton.icon(
                      onPressed: _saveAudioToFirebase,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}
