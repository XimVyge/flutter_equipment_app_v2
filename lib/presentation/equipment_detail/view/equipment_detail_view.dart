import 'package:flutter/material.dart';
import 'package:flutter_equipment_app_v2/shared/widgets/center_app_bar.dart';

import '../../../domain/models/equipment.dart';
import '../../../shared/widgets/custom_dialog.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../view_model/equipment_detail_view_model.dart';

enum ViewType { assigned, request}

class EquipmentDetailView extends StatelessWidget {
  EquipmentDetailView(this.equipment, this.view, {super.key});

  final ViewType view;
  final Equipment equipment;
  final viewModel = EquipmentDetailViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CenterAppBar(equipment.code, context),
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100), child: Image.network(equipment.image),)),
                const SizedBox(height: 16),
                Text(equipment.description,
                    style: Theme.of(context).textTheme.headlineMedium),
                Text(equipment.specs,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 30),
                if (view == ViewType.request) ...[
                  FilledButton(
                    onPressed: () {
                      showAssignEquipmentDialog(context, equipment);
                    },
                    child: const Text('Request Equipment'),
                  ),
                ],
                if (view == ViewType.assigned) ...[
                  Text("Assigned to: ",
                      style: Theme.of(context).textTheme.headlineSmall),
                  Text(equipment.employeeName,
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text("Position: ${equipment.position}",
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text("Schedule: ${equipment.schedule}",
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text("Purpose: ${equipment.purpose}",
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }

  void showAssignEquipmentDialog(BuildContext context, Equipment equipment) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      builder: (context) => CustomDialog(
        padding: EdgeInsets.zero,
        onPressed: () async {
          if (viewModel.equipmentFormkey.currentState!.validate()) {
            viewModel.assignEquipment(equipment);
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
                            viewModel.employeeNameController,
                            labelText: 'Full Name',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter employee full name.';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            viewModel.positionController,
                            labelText: 'Position',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter position.';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            viewModel.scheduleController,
                            labelText: 'Schedule',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter schedule.';
                              }
                              return null;
                            },
                          ),
                          CustomTextField(
                            viewModel.purposeController,
                            labelText: 'Purpose',
                            required: true,
                            validator: (value) {
                              if (value!.isEmpty || value.trim().isEmpty) {
                                return 'Please enter purpose for the request.';
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