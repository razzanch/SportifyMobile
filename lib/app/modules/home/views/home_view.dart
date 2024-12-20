import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/home_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController homeController = Get.put(HomeController());
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeAppAndPlayAudio();
  }

  Future<void> _initializeAppAndPlayAudio() async {
    // First check login and fetch audio URL
    await homeController.checkLoginStatus();

    // Play audio if URL exists (regardless of login status)
    if (homeController.audioUrl.value.isNotEmpty) {
      try {
        await _audioPlayer.play(UrlSource(homeController.audioUrl.value));

        // Wait for 5 seconds
        await Future.delayed(const Duration(seconds: 5));

        // Stop audio after 5 seconds
        await _audioPlayer.stop();
      } catch (e) {
        print('Failed to play audio: $e');
      }
    } else {
      // Tunggu 5 detik jika tidak ada audio
      await Future.delayed(const Duration(seconds: 5));
      print(homeController.audioUrl.value);
    }

    // Navigate after audio finishes
    if (homeController.isLoggedIn.value) {
      Get.offNamed(Routes.HOMEPAGE);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/logo app.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
