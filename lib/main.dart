import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/controllers/auth_controller.dart';
import 'package:myapp/app/modules/create_schedule/controllers/create_schedule_controller.dart';
import 'package:myapp/app/modules/notification_handler.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/dependency_injection.dart';
import 'package:myapp/firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Push Notifications
  FirebaseMessagingHandler firebaseMessagingHandler = FirebaseMessagingHandler();
  await firebaseMessagingHandler.initPushNotification();

  // Inject AuthController with GetX
  Get.put<AuthController>(AuthController());
  Get.put(CreateScheduleController()); // Inisialisasi CreateScheduleController
  Get.put(ProfileController()); // Inisialisasi ProfileController

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: (context, child) {
        return NotificationListener(
          child: child!,
        );
      },
    ),
  );
  DependencyInjection.init();
}
