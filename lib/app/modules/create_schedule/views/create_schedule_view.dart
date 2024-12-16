import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:myapp/app/modules/connection/controllers/connection_controller.dart';
import 'package:myapp/app/modules/create_schedule/controllers/create_schedule_controller.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class CreateScheduleView extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String location;
  final String date;

  CreateScheduleView({
    required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.location = '',
    this.date = '',
  });

  @override
  _CreateScheduleViewState createState() => _CreateScheduleViewState();
}

class _CreateScheduleViewState extends State<CreateScheduleView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerLocation = TextEditingController();
  final TextEditingController controllerDate = TextEditingController();
  final CreateScheduleController controllerConvert =
      Get.put(CreateScheduleController());

  late double widthScreen;
  late double heightScreen;
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  bool isLoading = false;
  String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Location and Map Data
  latlong2.LatLng currentLocation = latlong2.LatLng(0, 0);

  bool isMapLoading = true;
  final distanceInKm = 0.0.obs;
  final distanceInMeters = 0.0.obs;
  final MapController mapController = MapController();

  void _calculateDistance() {
    final distanceCalculator = latlong2.Distance();
    final double distance = distanceCalculator.as(
      latlong2.LengthUnit.Meter, // Menggunakan satuan meter
      latlong2.LatLng(currentLocation.latitude, currentLocation.longitude),
      latlong2.LatLng(
          controllerConvert.latitude.value, controllerConvert.longitude.value),
    );
    distanceInKm.value =
        distance / 1000; // Simpan dalam kilometer juga jika diperlukan
    distanceInMeters.value = distance;
    print(
        "Distance Calculated: $distance meters"); // Perbarui observable untuk meter
  }

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();

    if (!widget.isEdit) {
      controllerConvert.latitude.value = 0.0;
      controllerConvert.longitude.value = 0.0;
    }

    // Capture arguments using GetX
    final arguments = Get.arguments;
    if (arguments != null) {
      bool isEdit = arguments['isEdit'] ?? false;
      String name = arguments['name'] ?? '';
      String location = arguments['location'] ?? '';
      String dateString = arguments['date'] ?? '';

      if (isEdit) {
        try {
          selectedDate = DateFormat('d MMMM yyyy').parse(dateString);
          controllerName.text = name;
          controllerLocation.text = location;
          controllerDate.text = dateString;
        } catch (e) {
          print("Error parsing date: $e");
          controllerDate.text = '';
        }
      } else {
        controllerName.text = name;
        controllerDate.text = DateFormat('d MMMM yyyy').format(selectedDate);
      }
    }

    if (widget.isEdit && widget.documentId.isNotEmpty) {
      _loadDataFromFirebase(widget.documentId);
    } else {
      controllerDate.text = DateFormat('d MMMM yyyy').format(selectedDate);
    }

    // Get current user location
  }

  void _showSnackBarMessageCL(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white), // Warna teks
      ),
      backgroundColor: Colors.green, // Warna latar belakang Snackbar
      duration: Duration(seconds: 3), // Durasi tampil Snackbar
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Cek dan minta izin lokasi
      var status = await Permission.location.request();

      if (status.isGranted) {
        // Izin diberikan
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          currentLocation =
              latlong2.LatLng(position.latitude, position.longitude);
          isMapLoading = false;
          print(
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}");
          _showSnackBarMessageCL(
              "Your Current Location: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
        });
      } else if (status.isDenied) {
        // Izin ditolak
        _showSnackBarMessage(
            "Location permission denied. Please enable it in settings.");
      } else if (status.isPermanentlyDenied) {
        // Izin ditolak secara permanen, arahkan ke pengaturan
        _showSnackBarMessage(
            "Location permission permanently denied. Please enable it in app settings.");
        openAppSettings();
      }
    } catch (e) {
      print("Error getting location: $e");
      _showSnackBarMessage("Failed to get current location.");
    }
  }

  Future<void> _loadDataFromFirebase(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('sports').doc(documentId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        controllerName.text = data['name'] ?? '';
        controllerLocation.text = data['location'] ?? '';
        controllerConvert.address.value = data['location'] ?? '';

        String dateString = data['date'] ?? '';
        selectedDate = DateFormat('d MMMM yyyy').parse(dateString);
        controllerDate.text = dateString;

        // Pastikan lokasi saat ini sudah diinisialisasi
        if (currentLocation.latitude == 0.0 &&
            currentLocation.longitude == 0.0) {
          await _getCurrentLocation();
        }

        await controllerConvert
            .getCoordinatesFromAddress(controllerConvert.address.value);

        // Cetak nilai koordinat yang telah dihasilkan
        print(
            'Current location: ${currentLocation.latitude}, ${currentLocation.longitude}');
        print(
            'ControllerConvert location: ${controllerConvert.latitude.value}, ${controllerConvert.longitude.value}');

        setState(() {
          _calculateDistance();
        }); // Hitung jarak ulang dan perbarui jarak di UI
      }
    } catch (e) {
      print("Error loading data from Firebase: $e");
      _showSnackBarMessage("Failed to load data. Please try again.");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controllerDate.text = DateFormat('d MMMM yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1f1f1f),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Sports Schedule'),
        backgroundColor: Colors.red[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildWidgetFormPrimary(),
            SizedBox(height: 20),
            Text(
              'Map Preview',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 300,
              width: 360,
              child: isMapLoading
                  ? Center(child: CircularProgressIndicator())
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20.0), // Border radius untuk map
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              center: currentLocation,
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
                                  Marker(
                                    point: currentLocation,
                                    builder: (ctx) => Icon(
                                      Icons.person_pin,
                                      color: Colors.red,
                                      size: 40.0,
                                    ),
                                  ),
                                  Marker(
                                    point: latlong2.LatLng(
                                      controllerConvert.latitude.value,
                                      controllerConvert.longitude.value,
                                    ),
                                    builder: (ctx) => Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                      size: 40.0,
                                    ),
                                  ),
                                ],
                              ),
                              PolylineLayer(
                                polylines: controllerConvert.latitude.value !=
                                            0 &&
                                        controllerConvert.longitude.value != 0
                                    ? [
                                        Polyline(
                                          points: [
                                            currentLocation,
                                            latlong2.LatLng(
                                              controllerConvert.latitude.value,
                                              controllerConvert.longitude.value,
                                            ),
                                          ],
                                          strokeWidth: 4.0,
                                          color: Colors.black,
                                        ),
                                      ]
                                    : [],
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 16, // Posisi tombol melayang dari bawah
                            right: 16, // Posisi tombol melayang dari kanan
                            child: FloatingActionButton(
                              backgroundColor: Colors.red,
                              onPressed: () {
                                // Logika untuk memindahkan peta ke currentLocation
                                mapController.move(currentLocation,
                                    13.0); // Zoom level tetap 13
                              },
                              child: Icon(
                                Icons.person_pin,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWidgetFormPrimary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          TextField(
            controller: controllerLocation,
            decoration: InputDecoration(
              labelText: 'Location (Place Name or Full Address)',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(fontSize: 18.0, color: Colors.white),
            onChanged: (value) {
              controllerConvert.address.value = value;
            },
            onEditingComplete: () async {
              FocusScope.of(context).unfocus();
              // Pastikan proses async selesai
              await controllerConvert
                  .getCoordinatesFromAddress(controllerConvert.address.value);

              // Perbarui UI untuk merefleksikan data baru
              setState(() {
                _calculateDistance(); // Hitung jarak ulang dan perbarui jarak di UI
              });
            },
          ),

          TextField(
            controller: controllerDate,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Date',
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: Icon(Icons.calendar_today, color: Colors.white),
            ),
            style: TextStyle(fontSize: 18.0, color: Colors.white),
            onTap: () => _selectDate(context),
          ),
          SizedBox(height: 8.0), // Spasi kecil
          Obx(() => Text(
                'Distance: ${distanceInKm.value.toStringAsFixed(2)} km (${distanceInMeters.value.toStringAsFixed(2)} m)',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              )),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: Colors.red[700],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _saveData,
          ),
        ],
      ),
    );
  }

Future<void> _saveData() async {
  // Ambil input dari TextField
  String name = controllerName.text;
  String location = controllerLocation.text;
  String date = controllerDate.text;

  // Validasi input
  if (name.isEmpty) {
    _showSnackBarMessage('Name is required');
    return;
  } else if (location.isEmpty) {
    _showSnackBarMessage('Location is required');
    return;
  } else if (date.isEmpty) {
    _showSnackBarMessage('Date is required');
    return;
  }

  // Data yang akan disimpan
  final data = {
    'uid': currentUserUid,
    'name': name,
    'location': location,
    'date': date,
    'documentId': widget.isEdit ? widget.documentId : DateTime.now().toString(),
  };

  setState(() => isLoading = true);

  // Controller koneksi
  final connectionController = Get.find<ConnectionController>();
  final storage = GetStorage('local_schedule_data');

  try {
    if (connectionController.isConnected.value) {
      // Jika terkoneksi, simpan ke Firestore
      if (widget.isEdit) {
        await FirebaseFirestore.instance
            .collection('sports')
            .doc(widget.documentId)
            .set(data); // Menggunakan `set` untuk overwrite
        _showSnackBarMessage('Data updated successfully');
      } else {
        await FirebaseFirestore.instance.collection('sports').add(data);
        _showSnackBarMessage('Data saved successfully');
      }

      // Hapus data lokal setelah sukses menyimpan
      storage.remove('schedules');
    } else {
      // Jika tidak terkoneksi, simpan ke penyimpanan lokal
      final List<Map<String, dynamic>> localData =
          storage.read<List<dynamic>>('schedules')?.cast<Map<String, dynamic>>() ??
              [];
      localData.add(data);
      storage.write('schedules', localData);

      _showSnackBarMessage('No connection. Data saved locally.');
    }

    // Debug: Cetak data di GetStorage
    print('Isi GetStorage (local_schedule_data):');
    final storedData = storage.read<List<dynamic>>('schedules');
    if (storedData != null && storedData.isNotEmpty) {
      storedData.asMap().forEach((index, value) {
        print('Data $index: $value');
      });
    } else {
      print('Tidak ada data di GetStorage.');
    }
  } catch (e) {
    _showSnackBarMessage('An error occurred. Please try again.');
    print('Error: $e');
  } finally {
    setState(() => isLoading = false);
  }

  Navigator.pop(context, true);
}



  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    ));
  }
}
