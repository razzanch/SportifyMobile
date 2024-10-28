import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  late double widthScreen;
  late double heightScreen;
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Capture arguments using GetX
    final arguments = Get.arguments;
    if (arguments != null) {
      // Create local variables for assignments
      bool isEdit = arguments['isEdit'] ?? false;
      String documentId = arguments['documentId'] ?? '';
      String name = arguments['name'] ?? ''; // Ambil nama dari argumen
      String location = arguments['location'] ?? '';
      String dateString = arguments['date'] ?? '';

      // Assign values to the widget properties
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
        controllerName.text = name; // Set nama untuk tampilan baru
        controllerDate.text = DateFormat('d MMMM yyyy').format(selectedDate);
      }
    }

    // Tambahkan bagian dari fungsi initState kedua
    if (widget.isEdit && widget.documentId.isNotEmpty) {
      // Jika dalam mode edit, ambil data dari Firebase berdasarkan documentId
      _loadDataFromFirebase(widget.documentId);
    } else {
      // Jika dalam mode create, set tanggal default
      controllerDate.text = DateFormat('d MMMM yyyy').format(selectedDate);
    }
  }

  Future<void> _loadDataFromFirebase(String documentId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await firestore.collection('sports').doc(documentId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        controllerName.text = data['name'] ?? '';
        controllerLocation.text = data['location'] ?? '';
        
        // Parsing date dari Firebase
        String dateString = data['date'] ?? '';
        selectedDate = DateFormat('d MMMM yyyy').parse(dateString);
        controllerDate.text = dateString;
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
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
              onPressed: () async {
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

                setState(() => isLoading = true);

                try {
                  if (widget.isEdit) {
                    DocumentReference documentTask =
                        firestore.collection('sports').doc(widget.documentId);
                    await firestore.runTransaction((transaction) async {
                      DocumentSnapshot task = await transaction.get(documentTask);
                      if (task.exists) {
                        await transaction.update(
                          documentTask,
                          <String, dynamic>{
                            'name': name,
                            'location': location,
                            'date': date,
                          },
                        );
                      }
                    });
                    _showSnackBarMessage('Data updated successfully');
                  } else {
                    CollectionReference tasks = firestore.collection('sports');
                    await tasks.add(<String, dynamic>{
                      'name': name,
                      'location': location,
                      'date': date,
                    });
                    _showSnackBarMessage('Data saved successfully');
                  }
                  Navigator.pop(context, true);
                } catch (e) {
                  _showSnackBarMessage('An error occurred. Please try again.');
                } finally {
                  setState(() => isLoading = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetFormPrimary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          Text(
            widget.isEdit ? 'Edit Schedule' : 'Create New Schedule',
            style: Theme.of(context).textTheme.headlineMedium?.merge(
                  TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: controllerName,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(fontSize: 18.0, color: Colors.white),
            readOnly: true,
          ),
          TextField(
            controller: controllerLocation,
            decoration: InputDecoration(
              labelText: 'Location',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          TextField(
  controller: controllerDate,
  readOnly: true,
  decoration: InputDecoration(
    labelText: 'Date',
    labelStyle: TextStyle(color: Colors.white),
    prefixIcon: Icon(Icons.calendar_today, color: Colors.white), // Add the calendar icon here
  ),
  style: TextStyle(fontSize: 18.0, color: Colors.white),
  onTap: () => _selectDate(context),
),
        ],
      ),
    );
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    ));
  }
}
