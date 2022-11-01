import 'package:crm_flutter_project/features/unit_types/presentation/cubit/unit_type_cubit.dart';
import 'package:crm_flutter_project/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/error_item_widget.dart';

class UnitTypesPicker extends StatelessWidget {
  final List<String> selectedUnitTypes;
  final Function onConfirmCallback;

  const UnitTypesPicker(
      {Key? key, required this.selectedUnitTypes, required this.onConfirmCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<UnitTypeCubit>()
        ..setSelectedUnitTypes(selectedUnitTypes)
        ..getAllUnitTypesByNameLike(),

      child: BlocBuilder<UnitTypeCubit, UnitTypeState>(
        builder: (context, state) {
          final unitTypeCubit = UnitTypeCubit.get(context);
          if (state is StartGetAllUnitTypesByNameLike) {
            return const SizedBox(
                height: 500.0,
                width: 500.0,
                child: Center(child: CircularProgressIndicator()));
          }

          if (state is GetAllUnitTypesByNameLikeError) {
            return SizedBox(
              height: 500.0,
              width: 500.0,
              child: ErrorItemWidget(
                msg: state.msg,
                onPress: () {
                  unitTypeCubit.getAllUnitTypesByNameLike();
                },
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        onConfirmCallback(unitTypeCubit.selectedUnitTypes);
                      },
                      style: TextButton.styleFrom(

                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      child: const Text('تأكيد'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        unitTypeCubit.resetSelectedUnitTypes();
                      },
                      style: TextButton.styleFrom(
                          primary: Colors.red,
                          textStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      child: const Text('مسح الكل'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 500.0,
                  width: 500.0,
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      final currentUnitType = unitTypeCubit.unitTypes[index];
                      return ListTile(
                        onTap: () {
                          unitTypeCubit.updateSelectedUnitTypes(currentUnitType.name);
                        },
                        // selectedTileColor: Colors.blueGrey[100],
                        selected:
                            unitTypeCubit.selectedUnitTypes.contains(currentUnitType.name),
                        title: Text(currentUnitType.name),
                      );
                    },
                    itemCount: unitTypeCubit.unitTypes.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
