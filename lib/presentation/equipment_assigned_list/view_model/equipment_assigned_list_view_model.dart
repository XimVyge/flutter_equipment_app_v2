import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase/authentication.dart';
import '../../../services/firebase/firestore_services.dart';

class EquipmentAssignedListViewModel {
  final firebaseAuth = Authentication(FirebaseAuth.instance);
  final codeController = TextEditingController();
  final descriptionController = TextEditingController();
  final specsController = TextEditingController();
  final imageController = TextEditingController();
  final equipmentFormkey = GlobalKey<FormState>();

  Stream<QuerySnapshot> getEquipmentStream() {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(firebaseAuth.getCurrentUserUid())
        .collection('equipments')
        .snapshots();
  }

}
