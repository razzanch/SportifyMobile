import 'package:get/get.dart';

import '../controllers/create_schedule_controller.dart';

class CreateScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateScheduleController>(
      () => CreateScheduleController(),
    );
  }
}
