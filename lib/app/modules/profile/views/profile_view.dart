import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  int currentIndex = 3;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white), // Set title color to white
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.white, // Set the logout icon color to white
            onPressed: () {
              Get.toNamed(Routes.LOGIN);
            },
            tooltip: 'Logout', // Tooltip for the button
          ),
        ],
        backgroundColor: Colors.black, // Set AppBar background color to black
        elevation: 0, // Remove shadow
        iconTheme: IconThemeData(
            color:
                Colors.white), // Set the color of the back arrow icon to white
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: const Color.fromARGB(255, 0, 0, 0),
              child: Column(
                children: [
                  // Header with Avatar
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              SizedBox(
                                  height: 10), // Adjust this value to move down
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: _image == null
                                    ? AssetImage('assets/permana.jpg')
                                    : FileImage(_image!) as ImageProvider,
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal:
                                        16), // Optional: Add some padding
                                child: TextButton(
                                  onPressed: _pickImage,
                                  child: Text(
                                    'Edit Photo or Avatar',
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontSize: 18, // Increase font size here
                                      fontWeight:
                                          FontWeight.bold, // Make it bold
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
                        TextField(
                          style: TextStyle(
                              color:
                                  Colors.white), // Set the text color to white
                          decoration: InputDecoration(
                            filled: true, // Enable fill color
                            fillColor: Color.fromRGBO(
                                31, 31, 31, 1), // Set the background color
                            labelText: 'Name',
                            labelStyle: TextStyle(
                                color: Colors
                                    .white), // Set label text color to white
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide.none, // Remove the border line
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(
                              color:
                                  Colors.white), // Set the text color to white
                          decoration: InputDecoration(
                            filled: true, // Enable fill color
                            fillColor: Color.fromRGBO(
                                31, 31, 31, 1), // Set the background color
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                                color: Colors
                                    .white), // Set label text color to white
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide.none, // Remove the border line
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(
                              color:
                                  Colors.white), // Set the text color to white
                          decoration: InputDecoration(
                            filled: true, // Enable fill color
                            fillColor: Color.fromRGBO(
                                31, 31, 31, 1), // Set the background color
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                color: Colors
                                    .white), // Set label text color to white
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide.none, // Remove the border line
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(
                              color:
                                  Colors.white), // Set the text color to white
                          decoration: InputDecoration(
                            filled: true, // Enable fill color
                            fillColor: Color.fromRGBO(
                                31, 31, 31, 1), // Set the background color
                            labelText: 'Instagram',
                            labelStyle: TextStyle(
                                color: Colors
                                    .white), // Set label text color to white
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide.none, // Remove the border line
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Action untuk update profile (jika diperlukan)
                            },
                            child: Text(
                              'Update Profile',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(31, 31, 31, 1),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Placeholder to avoid overflow
          ],
        ),
      ),
      // Bottom Navigation Bar (Navbar)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Menampilkan semua item
        backgroundColor: Colors.red[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndex, // Menandakan halaman profil sedang aktif
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed(Routes.HOMEPAGE);
              break;
            case 1:
              Get.toNamed(Routes.SUCCED);
              break;
            case 2:
              // Navigasi ke halaman news
              Get.toNamed(Routes.NEWS);
              break;
            case 3:
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Peringatan'),
                    content: const Text('Anda sedang berada di halaman Berita'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.back(); // Tutup dialog
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
                  if (currentIndex == 0) // Ganti '2' dengan 'currentIndex'
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
                  Icon(Icons.article),
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
                  Icon(Icons.person),
                ],
              ),
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(31, 31, 31, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
