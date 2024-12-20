import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
 final FirebaseAuth _auth = FirebaseAuth.instance;
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 var isLoggedIn = false.obs;
 var audioUrl = ''.obs;

 @override
 void onInit() {
   super.onInit();
   checkLoginStatus();
 }

 Future<void> checkLoginStatus() async {
   final prefs = await SharedPreferences.getInstance();
   final tokenExists = prefs.getString('token') != null;

   if (tokenExists) {
     final User? currentUser = _auth.currentUser;
     if (currentUser != null) {
       isLoggedIn.value = true;
       await fetchAudioUrl(currentUser.uid);
     } else {
       isLoggedIn.value = false;
      audioUrl.value = 'https://l.top4top.io/m_3245hy2nb1.mp3';
     }
   } else {
     isLoggedIn.value = false;
     audioUrl.value = 'https://l.top4top.io/m_3245hy2nb1.mp3';
   }
 }

 Future<void> fetchAudioUrl(String userId) async {
   try {
     final doc = await _firestore.collection('audio').doc(userId).get();
     if (doc.exists) {
       audioUrl.value = doc.data()?['audio_url'] ?? '';
     }
   } catch (e) {
     print('Error fetching audio URL: $e');
   }
 }
}