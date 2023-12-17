import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCRUD {
  final CollectionReference schedule =
      FirebaseFirestore.instance.collection('irigation/land 1/schedule');
  final CollectionReference irigasi =
      FirebaseFirestore.instance.collection('irigation');
  final CollectionReference kelembaban =
      FirebaseFirestore.instance.collection('irigation');

  // create jadwal
  Future<void> addschedule(
      String scheduleStartTime, String scheduleEndTime) {
    return schedule.add({
      'schedule_start_time': scheduleStartTime,
      'schedule_end_time': scheduleEndTime,
    });
  }

  // read jadwal
  Stream<QuerySnapshot> getschedule() {
    final scheduleStream = schedule.snapshots();
    return scheduleStream;
  }

  //update jadwal
  Future<void> updateschedule(String scheduleID, String newScheduleStartTime,
      String newScheduleEndTime) {
    return schedule.doc(scheduleID).update({
      'schedule_start_time': newScheduleStartTime,
      'schedule_end_time': newScheduleEndTime,
    });
  }

  //delete jadwal
  Future<void> deleteschedule(String scheduleID) {
    return schedule.doc(scheduleID).delete();
  }

  // read irigasi
  Stream<DocumentSnapshot> getAir() {
    final irigasiStream = irigasi.doc('water_tank').snapshots();
    return irigasiStream;
  }

  // read land1 lahan konvensional
  Stream<DocumentSnapshot> getLand1() {
    final irigasiStream = irigasi.doc('land 1').snapshots();
    return irigasiStream;
  }

  // update valve
  Future<void> updatevalve(String landID, bool valveStatus) {
    return irigasi.doc(landID).update({
      'valve_status': valveStatus,
    });
  }
}
