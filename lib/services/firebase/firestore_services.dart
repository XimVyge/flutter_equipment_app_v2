import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FireStoreServices {
  FireStoreServices({required this.userUid});
  final String userUid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEquipment(
      String code, String description, String specs, String image) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'code': code,
      'description': description,
      'specs': specs,
      'image': image,
    };

    final DocumentReference documentReferencer = _firestore
        .collection('equipment')
        .doc();

    await documentReferencer.set(data).whenComplete(() {
      if (kDebugMode) {
        print('equipment added to the database');
      }
    }).catchError((e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    });
  }

  Future<void> assignEquipment(
      String code,
      String description,
      String specs,
      String image,
      String employeeName,
      String position,
      String schedule,
      String purpose
      ) async {
    final Map<String, dynamic> data = <String, dynamic>{
      'code': code,
      'description': description,
      'specs': specs,
      'image': image,
      'employeeName' : employeeName,
      'position' : position,
      'schedule' : schedule,
      'purpose' : purpose
    };

    final DocumentReference documentReferencer = _firestore
        .collection('user')
        .doc(userUid)
        .collection('equipments')
        .doc();

    await documentReferencer.set(data).whenComplete(() {
      if (kDebugMode) {
        print('equipment added to the database');
      }
    }).catchError((e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    });
  }
}
