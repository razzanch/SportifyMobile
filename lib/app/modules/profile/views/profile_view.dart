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
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.red, // Set the icon color to red
            onPressed: () {
              Get.toNamed(Routes.LOGIN);
            },
            tooltip: 'Logout', // Tooltip for the button
          ),
        ],
        backgroundColor: Colors.white, // Set AppBar background color
        elevation: 0, // Remove shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
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
                              TextButton(
                                onPressed: _pickImage,
                                child: Text(
                                  'Edit Photo or Avatar',
                                  style: TextStyle(
                                    color: Colors.teal,
                                    fontSize: 18, // Increase font size here
                                    fontWeight: FontWeight.bold, // Make it bold
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
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                        SizedBox(height: 10),
                        TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                        SizedBox(height: 10),
                        TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                        SizedBox(height: 10),
                        TextField(
                  decoration: InputDecoration(
                    labelText: 'Instagram',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
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
                              backgroundColor: Colors.black,
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
            SizedBox(height: 60),
          ],
        ),
      ),
      // Bottom Navigation Bar (Navbar)
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.red[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Icon Home
            IconButton(
              padding: EdgeInsets.only(left: 60, right: 60),
              onPressed: () {
                Get.toNamed(Routes.HOMEPAGE);
              },
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              tooltip: 'Home',
            ),
            // Icon Schedule
            IconButton(
              padding: EdgeInsets.only(left: 0, right: 0),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text('Halaman belum dibuat'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Menutup dialog dan berpindah ke halaman Profile
                            Get.back(); // Menutup dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              tooltip: 'Schedule',
            ),
            // Icon Profile
            IconButton(
              padding: EdgeInsets.only(left: 60, right: 60),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Warning'),
                      content:
                          const Text('Anda sudah berada di halaman profile'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Menutup dialog dan berpindah ke halaman Profile
                            Get.back(); // Menutup dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              tooltip: 'Perfil',
            ),
          ],
        ),
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
            color: Colors.grey[350],
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
