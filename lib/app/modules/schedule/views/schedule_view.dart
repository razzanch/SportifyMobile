import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/create_schedule/views/create_schedule_view.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';

class ScheduleView extends StatefulWidget {
  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ProfileController _profileController = Get.put(ProfileController());
  int currentIndex = 1; // Set initial index to 1 (Schedule)

  @override
  void initState() {
    super.initState();
    // Memuat data profil dari Firebase
    _profileController.loadUserData();
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
                onChanged: (value) {
                  print('Olahraga yang dicari: $value');
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari Olahraga',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
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
              StreamBuilder<QuerySnapshot>(
                stream:
                    firestore.collection('sports').orderBy('date').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
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
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = snapshot.data!.docs[index];
                        Map<String, dynamic> task =
                            document.data() as Map<String, dynamic>;

                        // Extracting date from the task
                        String strDate =
                            task['date']; // Assuming date is a string
                        String day =
                            strDate.split(' ')[0]; // Get the day from date
                        String month =
                            strDate.split(' ')[1]; // Get the month from date

                        return Card(
                          color: Colors.white, // Make the card color brighter
                          child: ListTile(
                            title: Text(
                              task['name'],
                              style: TextStyle(
                                  color: Colors
                                      .black), // Change text color to black for contrast
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task[
                                      'location'], // Menggunakan location sebagai subtitle
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(
                                    height:
                                        4.0), // Add spacing between location and date
                                Row(
                                  children: [
                                    Text(
                                      day,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                        width:
                                            8.0), // Add spacing between day and month
                                    Text(
                                      month,
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ];
                              },
                              onSelected: (String value) async {
                                if (value == 'edit') {
                                  // Navigasi ke halaman CreateScheduleView untuk edit task
                                  bool? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateScheduleView(
                                        isEdit: true,
                                        documentId: document
                                            .id, // Mengirimkan documentId untuk task yang sedang diedit
                                        name: task[
                                            'name'], // Mengirimkan nama task yang ada
                                        location: task[
                                            'location'], // Mengirimkan location yang ada
                                        date: task[
                                            'date'], // Mengirimkan tanggal task yang ada
                                      ),
                                    ),
                                  );

                                  // Menampilkan pesan jika task telah diperbarui
                                  if (result != null && result) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Task has been updated')),
                                    );
                                    setState(
                                        () {}); // Update tampilan setelah edit
                                  }
                                } else if (value == 'delete') {
                                  // Konfirmasi sebelum menghapus task
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete Task"),
                                        content: Text(
                                            "Are you sure you want to delete this task?"),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text("Cancel"),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  false); // Tutup dialog tanpa menghapus
                                            },
                                          ),
                                          TextButton(
                                            child: Text("Delete"),
                                            onPressed: () {
                                              Navigator.of(context).pop(
                                                  true); // Tutup dialog dan konfirmasi penghapusan
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmDelete) {
                                    // Hapus task dari Firestore
                                    await firestore
                                        .collection('sports')
                                        .doc(document.id)
                                        .delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Task has been deleted')),
                                    );
                                    setState(
                                        () {}); // Update tampilan setelah penghapusan
                                  }
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
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
              content: const Text('Anda sedang berada di halaman Schedule'),
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