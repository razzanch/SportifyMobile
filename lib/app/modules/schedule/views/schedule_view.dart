import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/create_schedule/controllers/create_schedule_controller.dart';
import 'package:myapp/app/modules/create_schedule/views/create_schedule_view.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/modules/schedule/controllers/schedule_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:permission_handler/permission_handler.dart';


class ScheduleView extends StatefulWidget {
  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ProfileController _profileController = Get.put(ProfileController());
  final ScheduleController controller = Get.put(ScheduleController());
  int currentIndex = 1; // Set initial index to 1 (Schedule)
  String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    // Memuat data profil dari Firebase
    _profileController.loadUserData();
  }


void showTaskDetailsDialog(
    BuildContext context, Map<String, dynamic> task) async {
  // Gunakan controller untuk mendapatkan koordinat dari nama lokasi
  final controller = CreateScheduleController();
  final String location = task['location']; // Nama lokasi (contoh: Google 2000)

  late latlong2.LatLng targetLocation;

  // Konversi nama lokasi menjadi koordinat
  await controller.getCoordinatesFromAddress(location);

  // Gunakan koordinat hasil konversi
  if (controller.latitude.value != 0.0 && controller.longitude.value != 0.0) {
    targetLocation = latlong2.LatLng(
      controller.latitude.value,
      controller.longitude.value,
    );
  } else {
    // Default lokasi jika konversi gagal
    targetLocation = latlong2.LatLng(0.0, 0.0);
  }

  // Dapatkan lokasi saat ini
  late latlong2.LatLng currentLocation;
  try {
    // Cek dan minta izin lokasi
    var status = await Permission.location.request();

    if (status.isGranted) {
      // Izin diberikan
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentLocation = latlong2.LatLng(position.latitude, position.longitude);
    } else if (status.isDenied) {
      // Izin ditolak
      _showSnackBarMessage(context,
          "Location permission denied. Please enable it in settings.");
      currentLocation = latlong2.LatLng(0.0, 0.0); // Default fallback
    } else if (status.isPermanentlyDenied) {
      // Izin ditolak secara permanen, arahkan ke pengaturan
      _showSnackBarMessage(context,
          "Location permission permanently denied. Please enable it in app settings.");
      openAppSettings();
      currentLocation = latlong2.LatLng(0.0, 0.0); // Default fallback
    }
  } catch (e) {
    currentLocation = latlong2.LatLng(0, 0); // Default fallback
    print("Error getting current location: $e");
  }

  // Tampilkan dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black, // Ubah warna dialog menjadi hitam
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text(
          task['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Teks menjadi putih
          ),
        ),
        content: SizedBox(
          height: 450,
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Map
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: MapOptions(
                      center: targetLocation,
                      zoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          // Marker lokasi saat ini
                          Marker(
                            point: currentLocation,
                            builder: (ctx) => Icon(
                              Icons.person_pin,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                          // Marker lokasi target
                          Marker(
                            point: targetLocation,
                            builder: (ctx) => Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                      // Polyline antara lokasi saat ini dan target
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [currentLocation, targetLocation],
                            strokeWidth: 4.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.grey), // Divider untuk memisahkan map dan detail lokasi

              // Detail Lokasi dan Informasi Lain
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Location:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${currentLocation.latitude}, ${currentLocation.longitude}',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Divider(color: Colors.grey),
                    Text(
                      'Target Location:',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      location,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey),

              // Bagian Tanggal
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Date: ${task['date']}',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              // Bagian Deskripsi (opsional)
              if (task.containsKey('description') && task['description'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.grey),
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        task['description'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// Fungsi untuk menampilkan Snackbar
void _showSnackBarMessage(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1f1f1f),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
          controller: controller.textController,
          onChanged: (value) {
            controller.recognizedText.value = value;
            controller.searchForSport(value); // Memfilter berdasarkan input teks
          },
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Cari Olahraga',
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            suffixIcon: Obx(() => IconButton(
                  icon: Icon(
                    controller.isListening.value
                        ? Icons.mic
                        : Icons.mic_none,
                    color: Colors.white,
                  ),
                  onPressed: controller.toggleListening, // Fungsi toggle
                )),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          ),
        ),
            ),
          ],
        ),
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
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: const Text(
                  'Jadwal Anda',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
           Obx(() {
  // Hanya tampilkan data yang terfilter dan memiliki uid yang sama dengan currentUserUid
  final displayedDocs = controller.searchResults.isEmpty
      ? controller.allSportsDocs
      : controller.searchResults;

  // Filter hasil yang hanya memiliki UID yang sesuai dengan currentUserUid
  final filteredDocs = displayedDocs
      .where((doc) => doc['uid'] == currentUserUid)
      .toList();

  if (filteredDocs.isEmpty) {
    return const Center(
      child: Text(
        'No data available.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  return Container(
    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: const Color(0xFF1f1f1f),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredDocs.length,
      itemBuilder: (context, index) {
        final document = filteredDocs[index];
        final task = document.data() as Map<String, dynamic>;

        // Extracting date from the task
        String strDate = task['date']; // Assuming date is a string
        String day = strDate.split(' ')[0]; // Get the day from date
        String month = strDate.split(' ')[1]; // Get the month from date

        return Card(
          color: Colors.white,
          child: ListTile(
            onTap: () {
              showTaskDetailsDialog(context, task); // Tampilkan dialog detail task
            },
            title: Text(
              task['name'],
              style: const TextStyle(color: Colors.black),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['location'], // Menggunakan location sebagai subtitle
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      month,
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ];
              },
              onSelected: (String value) async {
                if (value == 'edit') {
                  bool? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateScheduleView(
                        isEdit: true,
                        documentId: document.id,
                        name: task['name'],
                        location: task['location'],
                        date: task['date'],
                      ),
                    ),
                  );

                  if (result != null && result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task has been updated')),
                    );
                  }
                } else if (value == 'delete') {
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete Task"),
                        content: const Text(
                            "Are you sure you want to delete this task?"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: const Text("Delete"),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmDelete) {
                    await firestore
                        .collection('sports')
                        .doc(document.id)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Task has been deleted')),
                    );
                  }
                }
              },
            ),
          ),
        );
      },
    ),
  );
}),

            ],
          ),
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
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Peringatan'),
              content: const Text('Anda sedang berada di halaman '),
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
        
      case 2:
      Get.toNamed(Routes.NEWS);
        break;
        
      case 3:
      Get.toNamed(Routes.PLAYBACKS); // Arahkan ke Playbacks
        break;
       
      case 4:
      Get.toNamed(Routes.PROFILE);
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