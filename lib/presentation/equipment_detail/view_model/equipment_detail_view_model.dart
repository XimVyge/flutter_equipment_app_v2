import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_equipment_app_v2/domain/models/equipment.dart';

import '../../../services/firebase/authentication.dart';
import '../../../services/firebase/firestore_services.dart';

class EquipmentDetailViewModel {
  final firebaseAuth = Authentication(FirebaseAuth.instance);
  final employeeNameController = TextEditingController();
  final positionController = TextEditingController();
  final scheduleController = TextEditingController();
  final purposeController = TextEditingController();
  final equipmentFormkey = GlobalKey<FormState>();

  Future<void> assignEquipment(Equipment equipment) async {
    final fireStoreService =
    FireStoreServices(userUid: firebaseAuth.getCurrentUserUid() ?? '');
    fireStoreService.assignEquipment(equipment.code, equipment.description,
        equipment.specs, equipment.image, employeeNameController.text,
        positionController.text, scheduleController.text, purposeController.text);
  }
}