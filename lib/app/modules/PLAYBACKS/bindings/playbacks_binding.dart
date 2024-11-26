import 'package:get/get.dart';

import '../controllers/playbacks_controller.dart';

class PlaybacksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaybacksController>(
      () => PlaybacksController(),
    );
  }
}
