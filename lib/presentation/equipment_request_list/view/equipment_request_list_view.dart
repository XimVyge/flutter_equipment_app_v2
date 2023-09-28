import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_equipment_app_v2/domain/models/equipment.dart';
import 'package:flutter_equipment_app_v2/shared/widgets/center_app_bar.dart';

import '../../../shared/widgets/custom_dialog.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../equipment_detail/view/equipment_detail_view.dart';
import '../view_model/equipment_request_list_view_model.dart';

class EquipmentRequestListView extends StatelessWidget {
  EquipmentRequestListView({super.key});

  final viewModel = EquipmentRequestListViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CenterAppBar(
          'Available Equipments',
          context,
          shouldShowLeading: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showAddEquipmentDialog(context);
          },
          label: const Text('Add Equipment'),
          icon: const Icon(Icons.add),
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
                                equipment.isAssigned = data.docs[index]['isAssigned'];
                                equipment.id = data.docs[index].id;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EquipmentDetailView(equipment)));
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
                        return Container(
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void showAddEquipmentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      builder: (context) => CustomDialog(
        padding: EdgeInsets.zero,
        onPressed: () async {
          if (viewModel.equipmentFormkey.currentState!.validate()) {
            viewModel.addEquipment();
            Navigator.of(context).pop();
          }
        },
        height: MediaQuery.of(context).size.height / 1.3,
        description: Padding(
            padding: const EdgeInsets.fromLTRB(23, 0, 23, 16),
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        padding: const EdgeInsets.only(bottom: 24, top: 16),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.primary,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Form(
                      key: viewModel.equipmentFormkey,
                      child: Column(
                        children: [
                          CustomTextField(
                            viewModel.codeController,
                            labelText: 'Code',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter code.';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            viewModel.descriptionController,
                            labelText: 'Description',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter description.';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            viewModel.specsController,
                            labelText: 'Specs',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter specs.';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            viewModel.imageController,
                            labelText: 'Image',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter image url.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
        bottomPadding: const EdgeInsets.only(bottom: 24),
        buttonLabel: 'ADD',
      ),
      barrierColor: Colors.black.withOpacity(0.4),
    );
  }
}