import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eimunisasi_nakes/features/jadwal/data/models/jadwal_model.dart';

class JadwalRepository {
  final FirebaseFirestore _firestore;

  JadwalRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String collection = 'appointments';

  Future<List<JadwalPasienModel>?> getJadwalActivity(
      {required String? uid}) async {
    List<JadwalPasienModel>? result = [];
    final jadwalPasien = await _firestore
        .collection(collection)
        .where('uid', isEqualTo: uid)
        .get();
    for (var element in jadwalPasien.docs) {
      result.add(JadwalPasienModel.fromMap(element.data(), element.id));
    }
    return result;
  }

  Future<List<JadwalPasienModel>?> getSpecificJadwalActivity(
      {required String? uid, DateTime? date}) async {
    List<JadwalPasienModel>? result;
    final jadwalPasien = await _firestore
        .collection(collection)
        .where('uid', isEqualTo: uid)
        .where('date', isEqualTo: date)
        .get();
    for (var element in jadwalPasien.docs) {
      result?.add(JadwalPasienModel.fromMap(element.data(), element.id));
    }
    return result;
  }

  Future<void> addJadwalActivity({
    required JadwalPasienModel jadwalPasienModel,
  }) async {
    final DocumentReference reference = _firestore.collection(collection).doc();
    await reference.set(jadwalPasienModel.toMap());
  }

  Future<void> updateJadwalActivity(
      {required JadwalPasienModel jadwalPasienModel,
      required String? docId}) async {
    final DocumentReference reference =
        _firestore.collection(collection).doc(docId);
    await reference.update(jadwalPasienModel.toMap());
  }

  Future<void> deleteJadwalActivity({required String docId}) async {
    final DocumentReference reference =
        _firestore.collection(collection).doc(docId);
    await reference.delete();
  }
}