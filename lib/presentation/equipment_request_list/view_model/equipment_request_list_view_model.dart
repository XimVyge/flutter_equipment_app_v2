import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase/authentication.dart';
import '../../../services/firebase/firestore_services.dart';

class EquipmentRequestListViewModel {
  final firebaseAuth = Authentication(FirebaseAuth.instance);
  final codeController = TextEditingController();
  final descriptionController = TextEditingController();
  final specsController = TextEditingController();
  final imageController = TextEditingController();
  final equipmentFormkey = GlobalKey<FormState>();

  Stream<QuerySnapshot> getEquipmentStream() {
    return FirebaseFirestore.instance
        .collection('equipment')
        .where('isAssigned', isEqualTo: false)
        .snapshots();
  }

  Future<void> addEquipment() async {
    final fireStoreService =
    FireStoreServices(userUid: firebaseAuth.getCurrentUserUid() ?? '');
    fireStoreService.addEquipment(codeController.text, descriptionController.text,
        specsController.text, imageController.text);
  }
}
