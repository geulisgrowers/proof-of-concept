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
        title: const Text('Masukan Jadwal Baru'),
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
        title: const Text('Ubah Jadwal'),
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
                  hintStyle: const TextStyle(color: Colors.grey),
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
                  hintStyle: const TextStyle(color: Colors.grey),
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

            child: const Text('Ubah'),
          )
        ],
      ),
    );
  }

  void dialogHapusJadwal(String scheduleID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jadwal ?'),
        backgroundColor: Colors.grey[300],
        actions: [
          ElevatedButton(
            // tambah
            onPressed: () {
              firestoreCRUD.deleteschedule(scheduleID);
              // tutup dialog
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
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
          title: const Text(
            "Aplikasi Kebun FKGG",
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Ketersediaan air
              Card(
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Ketersediaan Air : ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: firestoreCRUD.getAir(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> watertank =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              bool ketersediaanAir =
                                  watertank['water_tank_status'];
                              if (ketersediaanAir) {
                                return const Text(
                                  'Tersedia',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              } else {
                                return const Text(
                                  'Tidak Tersedia',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            } else {
                              return const Text(
                                'Tidak Terkoneksi',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
              // Kelembapan
              Card(
                color: Colors.white,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Text(
                        'Kelembaban : ',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: firestoreCRUD.getLand1(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> land =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              int kelembaban = land['soil_moisture'];
                              return Text(
                                '${kelembaban.toString()} %',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return const Text(
                                'Tidak Terkoneksi',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
              // Penyiraman Terjadwal
              Card(
                color: Colors.white,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  children: [
                    SwitchListTile(
                        title: const Text(
                          'Penyiraman Terjadwal',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Nyalakan untuk menyiram tanaman secara otomatis sesuai dengan jadwal. Matikan untuk menyiram secara manual',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                waktuMulai,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                '  -  ',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                waktuSelesai,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                '  WIB',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
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
                                                  icon:
                                                      const Icon(Icons.delete)),
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  return const Text('Tidak ada jadwal');
                                }
                              }),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 15),
                            child: Padding(
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
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
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
              // Pompa & Valve

              Visibility(
                visible: !_jadwalSwitch,
                child: Card(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: firestoreCRUD.getLand1(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> land =
                              snapshot.data!.data() as Map<String, dynamic>;
                          bool valve = land['valve_status'];
                          _pompaSwitch = valve;
                          return SwitchListTile(
                              title: const Text(
                                'Siram Kebun',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: const Text(
                                'Nyalakan untuk menyiram tanaman. Matikan untuk berhenti menyiram',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
