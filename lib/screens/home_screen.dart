import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocfkgg/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _jadwalSwitch = false;
  bool _pompaSwitch = false;
  final TextEditingController _jadwalMulaiPenyiraman =
      TextEditingController(); // waktu mulai
  final TextEditingController _jadwalSelesaiPenyiraman =
      TextEditingController(); // waktu selesai
  final FirestoreCRUD firestoreCRUD = FirestoreCRUD();

  //dialog tambah jadwal
  void dialogTambahJadwal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Masukan Jadwal Baru'),
        backgroundColor: Colors.grey[300],
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _jadwalMulaiPenyiraman,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Waktu Mulai Pernyiraman',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _jadwalSelesaiPenyiraman,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Waktu Selesai Penyiraman',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            // tambah
            onPressed: () {
              firestoreCRUD.addschedule(
                  _jadwalMulaiPenyiraman.text, _jadwalSelesaiPenyiraman.text);
              // clear controller
              _jadwalMulaiPenyiraman.clear();
              _jadwalSelesaiPenyiraman.clear();
              // tutup dialog
              Navigator.pop(context);
            },

            child: Text('Tambah'),
          )
        ],
      ),
    );
  }

  void dialogUbahJadwal(String scheduleID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah Jadwal'),
        backgroundColor: Colors.grey[300],
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _jadwalMulaiPenyiraman,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Waktu Mulai Pernyiraman Baru',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _jadwalSelesaiPenyiraman,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Waktu Selesai Penyiraman Baru',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            // tambah
            onPressed: () {
              firestoreCRUD.updateschedule(scheduleID,
                  _jadwalMulaiPenyiraman.text, _jadwalSelesaiPenyiraman.text);
              // clear controller
              _jadwalMulaiPenyiraman.clear();
              _jadwalSelesaiPenyiraman.clear();
              // tutup dialog
              Navigator.pop(context);
            },

            child: Text('Ubah'),
          )
        ],
      ),
    );  
  }

  void dialogHapusJadwal(String scheduleID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Jadwal ?'),
        backgroundColor: Colors.grey[300],
        actions: [
          ElevatedButton(
            // tambah
            onPressed: () {
              firestoreCRUD.deleteschedule(scheduleID);
              // tutup dialog
              Navigator.pop(context);
            },
            child: Text('Hapus'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Aplikasi Kebun FKGG"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Ketersediaan air
              Column(
                children: [
                  const Text('Ketersediaan Air : '),
                  StreamBuilder<DocumentSnapshot>(
                      stream: firestoreCRUD.getAir(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> watertank =
                              snapshot.data!.data() as Map<String, dynamic>;
                          bool ketersediaanAir = watertank['water_tank_status'];
                          if (ketersediaanAir) {
                            return const Text('Tersedia');
                          } else {
                            return const Text('Tidak Tersedia');
                          }
                        } else {
                          return const Text('Tidak Terkoneksi');
                        }
                      }),
                ],
              ),
              // Penyiraman Terjadwal
              SwitchListTile(
                  title: Text('Penyiraman Terjadwal'),
                  subtitle: Text(
                      'Nyalakan untuk menyiram tanaman secara otomatis sesuai dengan jadwal. Matikan untuk menyiram secara manual'),
                  value: _jadwalSwitch,
                  onChanged: (bool value) {
                    setState(() {
                      _jadwalSwitch = value;
                      _pompaSwitch = false;
                    });
                  }),
              // Penjadwalan Penyiraman
              Visibility(
                visible: _jadwalSwitch,
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: firestoreCRUD.getschedule(),
                        builder: (context, snapshot) {
                          // kalau ada data, ambil semua document
                          if (snapshot.hasData) {
                            List scheduleList = snapshot.data!.docs;

                            //display list
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: scheduleList.length,
                                itemBuilder: (context, index) {
                                  // ambil documen (individual)
                                  DocumentSnapshot scheduledocument =
                                      scheduleList[index];
                                  String scheduledocumentID =
                                      scheduledocument.id;

                                  Map<String, dynamic> scheduledata =
                                      scheduledocument.data()
                                          as Map<String, dynamic>;
                                  String waktuMulai =
                                      scheduledata['schedule_start_time'];
                                  String waktuSelesai =
                                      scheduledata['schedule_end_time'];

                                  return ListTile(
                                    subtitle: Column(
                                      children: [
                                        Text(waktuMulai),
                                        Text(waktuSelesai),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // update atau edit
                                        IconButton(
                                            onPressed: () {
                                              dialogUbahJadwal(
                                                scheduledocumentID);
                                            },
                                            icon: const Icon(Icons.edit)),
                                        // delete
                                        IconButton(
                                            onPressed: () {
                                              dialogHapusJadwal(
                                                scheduledocumentID);
                                            },
                                            icon: const Icon(Icons.delete)),
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return const Text('Tidak ada jadwal');
                          }
                        }),
                        Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        onPressed: () {
                          dialogTambahJadwal();
                        },
                        child: const Text(
                          'Tambah Jadwal',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),],
                ),
              ),
              // Pompa & Valve

              Visibility(
                visible: !_jadwalSwitch,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: firestoreCRUD.getLand1(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> land =
                            snapshot.data!.data() as Map<String, dynamic>;
                        bool valve = land['valve_status'];
                        _pompaSwitch = valve;
                        return SwitchListTile(
                            title: Text('Siram Kebun'),
                            subtitle: Text(
                                'Nyalakan untuk menyiram tanaman. Matikan untuk berhenti menyiram'),
                            value: _pompaSwitch,
                            onChanged: (bool value) {
                              setState(() {
                                _pompaSwitch = value;
                                firestoreCRUD.updatevalve('land 1', value);
                              });
                            });
                      } else {
                        return const Text('Tidak Terkoneksi');
                      }
                    }),
              ),
              // Kelembapan
              Column(
                children: [
                  const Text('Kelembaban : '),
                  StreamBuilder<DocumentSnapshot>(
                      stream: firestoreCRUD.getLand1(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> land =
                              snapshot.data!.data() as Map<String, dynamic>;
                          int kelembaban = land['soil_moisture'];
                          return Text(kelembaban.toString());
                        } else {
                          return const Text('Tidak Terkoneksi');
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
