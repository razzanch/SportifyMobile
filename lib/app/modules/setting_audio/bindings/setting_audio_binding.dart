import 'package:get/get.dart';

import '../controllers/setting_audio_controller.dart';

class SettingAudioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingAudioController>(
      () => SettingAudioController(),
    );
  }
}
