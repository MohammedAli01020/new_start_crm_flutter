import 'package:crm_flutter_project/features/unit_types/presentation/screens/unit_types_screen.dart';
import 'package:flutter/material.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/enums.dart';


class PickUnitTypes extends StatefulWidget {
  final List<String> unitTypes;
  final Function onPickedUnitTypesCallback;
  final VoidCallback onRemoveCallback;
  const PickUnitTypes({Key? key, required this.unitTypes,
    required this.onPickedUnitTypesCallback,
    required this.onRemoveCallback}) : super(key: key);

  @override
  State<PickUnitTypes> createState() => _PickUnitTypesState();
}

class _PickUnitTypesState extends State<PickUnitTypes> {

  List<String> selectedUnitTypes = [];

  @override
  void initState() {
    super.initState();
    selectedUnitTypes = widget.unitTypes;
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: ListTile(
              onTap: () async {
                final pickedSources = await Navigator.pushNamed(context, Routes.unitTypesRoute,
                    arguments: UnitTypesArgs(unitTypesType: UnitTypesType.SELECT_UNIT_TYPES.name,
                        selectedUnitTypesNames: selectedUnitTypes));

                if (pickedSources != null && pickedSources is List<String>) {

                  selectedUnitTypes = pickedSources;

                  setState(() {
                  });

                  widget.onPickedUnitTypesCallback(pickedSources);
                }
              },
              title: Text(selectedUnitTypes.isNotEmpty ? "عدل الاهتمامات" : "احتر الاهتمامات"),
              subtitle: Text(selectedUnitTypes.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
        if (selectedUnitTypes.isNotEmpty)
        IconButton(
          onPressed: () {
            selectedUnitTypes = [];

            setState(() {});

            widget.onRemoveCallback();
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}