import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_equipment_app_v2/domain/models/equipment.dart';
import 'package:flutter_equipment_app_v2/presentation/equipment_request_list/view/equipment_request_list_view.dart';
import 'package:flutter_equipment_app_v2/shared/widgets/center_app_bar.dart';

import '../../../shared/widgets/custom_dialog.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../equipment_detail/view/equipment_detail_view.dart';
import '../view_model/equipment_assigned_list_view_model.dart';

class EquipmentAssignedListView extends StatelessWidget {
  EquipmentAssignedListView({super.key});

  final viewModel = EquipmentAssignedListViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CenterAppBar(
          'Assigned Equipments',
          context,
          shouldShowLeading: false,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EquipmentRequestListView()));
          },
          label: const Text('Request Equipment'),
          icon: const Icon(Icons.assignment),
          backgroundColor: Colors.lightBlue,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: viewModel.getEquipmentStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          final data = snapshot.requireData;
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.size,
                              itemBuilder: (context, index) {
                                final equipment = Equipment();
                                equipment.code = data.docs[index]['code'];
                                equipment.description =
                                data.docs[index]['description'];
                                equipment.specs = data.docs[index]['specs'];
                                equipment.image = data.docs[index]['image'];
                                equipment.employeeName = data.docs[index]['employeeName'];
                                equipment.schedule = data.docs[index]['schedule'];
                                equipment.position = data.docs[index]['position'];
                                equipment.purpose = data.docs[index]['purpose'];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EquipmentDetailView(equipment, ViewType.assigned)));
                                    },
                                    leading: Image.network(equipment.image),
                                    title: Text(equipment.code),
                                    trailing: Text(equipment.description),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}