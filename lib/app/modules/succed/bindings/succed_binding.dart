import 'package:get/get.dart';

import '../controllers/succed_controller.dart';

class SuccedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccedController>(
      () => SuccedController(),
    );
  }
}
