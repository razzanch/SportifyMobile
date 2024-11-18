import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  int currentIndex = 4;
  bool _isEditable = false;

  final ProfileController _profileController = Get.put(ProfileController());

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _profileController.photoUrl.value = pickedFile.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _profileController.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              // Log out and navigate to login
              Get.offNamed(Routes.LOGIN);
            },
            tooltip: 'Logout',
          ),
        ],
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Obx(() => CircleAvatar(
                                    radius: 60,
                                    backgroundImage: _profileController
                                            .photoUrl.value.isNotEmpty
                                        ? NetworkImage(
                                            _profileController.photoUrl.value)
                                        : AssetImage('assets/profildefault.png')
                                            as ImageProvider,
                                  )),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: TextButton(
                                  onPressed: () {
                                    // Memanggil fungsi untuk memilih gambar
                                    // For choosing the camera or gallery, update this to specify the ImageSource
                                    _profileController.pickProfileImage(
                                      _profileController.getCurrentUserId()!,
                                      ImageSource
                                          .gallery, // or ImageSource.camera, based on your logic
                                    );
                                  },
                                  child: Text(
                                    'Edit Photo or Avatar',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                  // User Information
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => TextField(
                              enabled: _isEditable,
                              style: TextStyle(
                                  color: _isEditable
                                      ? Colors.black
                                      : Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _isEditable
                                    ? Colors.white
                                    : const Color.fromRGBO(31, 31, 31, 1),
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                    color: _isEditable
                                        ? Colors.black
                                        : Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              controller: TextEditingController(
                                  text: _profileController.nama.value),
                              onChanged: (value) {
                                _profileController.nama.value = value;
                              },
                            )),

                        SizedBox(height: 40),
                        Obx(() => TextField(
                              enabled: _isEditable,
                              style: TextStyle(
                                  color: _isEditable
                                      ? Colors.black
                                      : Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _isEditable
                                    ? Colors.white
                                    : const Color.fromRGBO(31, 31, 31, 1),
                                labelText: 'Nomor Handphone',
                                labelStyle: TextStyle(
                                    color: _isEditable
                                        ? Colors.black
                                        : Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              controller: TextEditingController(
                                  text:
                                      _profileController.nomorhandphone.value),
                              onChanged: (value) {
                                _profileController.nomorhandphone.value = value;
                              },
                            )),
                        SizedBox(height: 40),
                        Obx(() => TextField(
                              enabled: _isEditable,
                              style: TextStyle(
                                  color: _isEditable
                                      ? Colors.black
                                      : Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _isEditable
                                    ? Colors.white
                                    : const Color.fromRGBO(31, 31, 31, 1),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: _isEditable
                                        ? Colors.black
                                        : Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              controller: TextEditingController(
                                  text: _profileController.email.value),
                              onChanged: (value) {
                                _profileController.email.value = value;
                              },
                            )),
                        SizedBox(height: 40),
                        Obx(() => TextField(
                              enabled: _isEditable,
                              style: TextStyle(
                                  color: _isEditable
                                      ? Colors.black
                                      : Colors.white),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _isEditable
                                    ? Colors.white
                                    : const Color.fromRGBO(31, 31, 31, 1),
                                labelText: 'Instagram',
                                labelStyle: TextStyle(
                                    color: _isEditable
                                        ? Colors.black
                                        : Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              controller: TextEditingController(
                                  text: _profileController.instagram.value),
                              onChanged: (value) {
                                _profileController.instagram.value = value;
                              },
                            )),
                        // Additional TextFields for phone, email, etc., similar to the above TextField
                        SizedBox(height: 40),
                        Center(
                          child: Container(
                            width: double
                                .infinity, // Makes the button take the full width of the screen
                            child: ElevatedButton(
                              onPressed: () {
                                if (_isEditable) {
                                  _profileController.saveDataToFirestore(
                                      _profileController.getCurrentUserId()!);
                                }
                                setState(() {
                                  _isEditable = !_isEditable;
                                });
                              },
                              child: Text(
                                _isEditable ? 'Save Profile' : 'Update Profile',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Sets the border radius to 10
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: Container(
                            width: double
                                .infinity, // Makes the button take the full width of the screen
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(Routes.SETTING_AUDIO);
                              },
                              child: Text(
                               'Setting Opening Audio',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Sets the border radius to 10
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar (Navbar)
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
              Get.toNamed(Routes.PLAYBACKS); // Arahkan ke Playbacks
              break;

            case 4:
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Peringatan'),
                    content:
                        const Text('Anda sedang berada di halaman PlayBacks'),
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