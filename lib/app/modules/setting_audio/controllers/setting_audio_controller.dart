import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SettingAudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // URL audio dan visibilitas dropdown
  var audioUrl = "https://l.top4top.io/m_3245hy2nb1.mp3".obs;
  var isDropdownVisible = false.obs;

  // Status pemutaran, durasi total, dan posisi saat ini
  var isPlaying = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

    // Memonitor perubahan durasi audio
    _audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });

    // Memonitor perubahan posisi audio
    _audioPlayer.onPositionChanged.listen((p) {
      position.value = p;
    });
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  // Fungsi untuk memutar audio
  Future<void> playAudio() async {
    await _audioPlayer.play(UrlSource(audioUrl.value));
    isPlaying.value = true;
  }

  // Fungsi untuk menjeda audio
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    isPlaying.value = false;
  }

  // Fungsi untuk melanjutkan pemutaran audio
  Future<void> resumeAudio() async {
    await _audioPlayer.resume();
    isPlaying.value = true;
  }

  // Fungsi untuk menghentikan audio
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    isPlaying.value = false;
    position.value = Duration.zero;
  }

  // Fungsi untuk mengatur posisi audio
  void seekAudio(Duration newPosition) {
    _audioPlayer.seek(newPosition);
  }
}