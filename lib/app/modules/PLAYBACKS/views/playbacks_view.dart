import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/PLAYBACKS/views/video_player_widget.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';


class PlaybacksView extends StatefulWidget {
  const PlaybacksView({super.key});

  @override
  State<PlaybacksView> createState() => _PlaybacksViewState();
}

class _PlaybacksViewState extends State<PlaybacksView> {
  final ImagePicker _picker = ImagePicker();
  int currentIndex = 3;
  final ProfileController _profileController = Get.put(ProfileController());

@override
  void initState() {
    super.initState();
    _profileController.loadUserData();
  }

  // Method untuk menghapus video dari Firestore dan Firebase Storage
  Future<void> _deleteVideo(String videoUrl, String videoId) async {
    try {

      // Hapus video dari Firebase Storage
      Reference storageRef = FirebaseStorage.instance.refFromURL(videoUrl);
      await storageRef.delete();

      // Hapus video dari Firestore
      await FirebaseFirestore.instance
          .collection('playbacks')
          .doc(videoId)  // Gunakan videoId untuk menghapus dokumen yang sesuai
          .delete();

      // Setelah berhasil menghapus, tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video berhasil dihapus')),
      );
      
      // Perbarui UI setelah penghapusan
      setState(() {});
    } catch (e) {
      print('Error deleting video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting video')),
      );
    }
  }

  // Method untuk memilih dan mengunggah video
  Future<void> _pickVideoAndUpload(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Source'),
        content: const Text('Select video from Camera or Gallery.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'camera'),
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'gallery'),
            child: const Text('Gallery'),
          ),
        ],
      ),
    );

    if (result != null) {
      final XFile? video = await _picker.pickVideo(
        source: result == 'camera' ? ImageSource.camera : ImageSource.gallery,
      );

      if (video != null) {
        String videoPath = video.path;
        String? videoUrl = await _uploadVideo(videoPath);

        if (videoUrl != null) {
          _showVideoDetailsDialog(context, videoUrl);
        }
      }
    }
  }

  // Method untuk mengunggah video ke Firebase Storage
  Future<String?> _uploadVideo(String videoPath) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String fileName = videoPath.split('/').last;
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('playbacks/$userId/$fileName');

      await storageRef.putFile(File(videoPath));
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }

  // Method untuk menyimpan informasi video ke Firestore
  Future<void> _saveToFirestore(String videoUrl, String caption) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('playbacks').add({
        'uid': userId,
        'video_url': videoUrl,
        'caption': caption,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }

  // Method untuk menampilkan dialog detil video
  void _showVideoDetailsDialog(BuildContext context, String videoUrl) {
    final TextEditingController captionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Video Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: videoUrl),
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Video URL'),
            ),
            TextField(
              controller: captionController,
              decoration: const InputDecoration(labelText: 'Caption'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String caption = captionController.text;
              await _saveToFirestore(videoUrl, caption);
              Navigator.pop(context);
              // Perbarui UI setelah penghapusan
              setState(() {});
            },
            child: const Text('UPLOAD'),
          ),
        ],
      ),
    );
  }

  // Method untuk mengambil playbacks dari Firestore
  Future<List<Map<String, dynamic>>> _fetchPlaybacks() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('playbacks')
        .where('uid', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Menambahkan id dokumen untuk referensi penghapusan
      return data;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'PlayBacks',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
         Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Obx(() => CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 20.0,
                  backgroundImage: _profileController.photoUrl.value.isNotEmpty
                      ? NetworkImage(_profileController.photoUrl.value)
                      : AssetImage('assets/profildefault.png') as ImageProvider,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchPlaybacks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading playbacks.'));
                }
                final playbacks = snapshot.data ?? [];
                if (playbacks.isEmpty) {
                  return const Center(child: Text('No playbacks available.'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: playbacks.length,
                  itemBuilder: (context, index) {
                    final playback = playbacks[index];
                    return Card(
  color: Colors.grey[800],
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  child: Padding(
    padding: const EdgeInsets.all(12.0),
    child: Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VideoPlayerWidget(videoUrl: playback['video_url']),
          const SizedBox(height: 12),
          // Divider sebelum caption
          const Divider(color: Colors.white, thickness: 1),
          const SizedBox(height: 8), // Space after divider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menyebar antara caption dan icon
            children: [
              Expanded(
                child: Text(
                  playback['caption'] ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  overflow: TextOverflow.ellipsis, // Menambahkan overflow jika caption terlalu panjang
                ),
              ),
              // IconButton untuk menghapus video
              IconButton(
                onPressed: () => _deleteVideo(playback['video_url'], playback['id']),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (playback['timestamp'] != null)
            Text(
              _formatTimestamp(playback['timestamp']),
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
        ],
      ),
    ),
  ),
);


                  },
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _pickVideoAndUpload(context),
              icon: const Icon(Icons.upload, color: Colors.white),
              label: const Text('UPLOAD VIDEO', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  backgroundColor: Colors.red[700],
  selectedItemColor: Colors.white,
  unselectedItemColor: Colors.white70,
  currentIndex: currentIndex,
  onTap: (index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.HOMEPAGE);
        break;
      case 1:
        Get.toNamed(Routes.SCHEDULE);
        break;
      case 2:
        Get.toNamed(Routes.NEWS);
        break;
      case 3:
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Peringatan'),
              content: const Text('Anda sedang berada di halaman PlayBacks'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        break;
       
      case 4:
         Get.toNamed(Routes.PROFILE); // Arahkan ke Playbacks
        break;
    }
  },
  items: [
    BottomNavigationBarItem(
      icon: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentIndex == 0)
              Container(
                height: 3,
                width: 34,
                color: Colors.white,
              ),
            Icon(Icons.home),
          ],
        ),
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentIndex == 1)
              Container(
                height: 3,
                width: 34,
                color: Colors.white,
              ),
            Icon(Icons.calendar_today),
          ],
        ),
      ),
      label: 'Schedule',
    ),
    BottomNavigationBarItem(
      icon: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentIndex == 2)
              Container(
                height: 3,
                width: 34,
                color: Colors.white,
              ),
            Icon(Icons.newspaper),
          ],
        ),
      ),
      label: 'News',
    ),
    BottomNavigationBarItem(
      icon: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentIndex == 3)
              Container(
                height: 3,
                width: 34,
                color: Colors.white,
              ),
            Icon(Icons.play_arrow), // Icon Playbacks
          ],
        ),
      ),
      label: 'Playbacks',
    ),
    BottomNavigationBarItem(
      icon: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentIndex == 4)
              Container(
                height: 3,
                width: 34,
                color: Colors.white,
              ),
            Icon(Icons.person),
          ],
        ),
      ),
      label: 'Profile',
    ),
  ],
),
    );
  }
}

// Method untuk format timestamp
String _formatTimestamp(Timestamp timestamp) {
  final DateTime dateTime = timestamp.toDate();
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
}
