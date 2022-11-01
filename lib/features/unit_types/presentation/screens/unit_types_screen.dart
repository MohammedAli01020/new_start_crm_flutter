import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../cubit/unit_type_cubit.dart';
import '../widgets/modify_unit_type_widget.dart';
import '../widgets/unit_type_app_bar.dart';

class UnitTypesScreen extends StatelessWidget {
  final UnitTypesArgs unitTypesArgs;

  final _scrollController = ScrollController();

   UnitTypesScreen({Key? key, required this.unitTypesArgs})
      : super(key: key) {
     if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
       _scrollController.addListener(() {
         ScrollDirection scrollDirection =
             _scrollController.position.userScrollDirection;
         if (scrollDirection != ScrollDirection.idle) {
           double scrollEnd = _scrollController.offset +
               (scrollDirection == ScrollDirection.reverse
                   ? Constants.extraScrollSpeed
                   : -Constants.extraScrollSpeed);
           scrollEnd = min(_scrollController.position.maxScrollExtent,
               max(_scrollController.position.minScrollExtent, scrollEnd));
           _scrollController.jumpTo(scrollEnd);
         }
       });
     }
   }

  Widget _buildBody(UnitTypeCubit sourceCubit, UnitTypeState state) {
    if (state is StartGetAllUnitTypesByNameLike) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetAllUnitTypesByNameLikeError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          sourceCubit.getAllUnitTypesByNameLike();
        },
      );
    }

    return Scrollbar(
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          final currentUnitType = sourceCubit.unitTypes[index];
          return ListTile(
            onTap: () {
              if (unitTypesArgs.unitTypesType ==
                  UnitTypesType.SELECT_UNIT_TYPES.name) {
                sourceCubit.updateSelectedUnitTypes(currentUnitType.name);
              } else if (unitTypesArgs.unitTypesType ==
                  UnitTypesType.VIEW_UNIT_TYPES.name) {

                if (Constants.currentEmployee!.permissions.contains(AppStrings.editUnitTypes)) {
                  Constants.showDialogBox(
                      context: context,
                      title: "عدل العنصر",
                      content: ModifyUnitTypeWidget(
                        unitTypeModel: currentUnitType,
                        unitTypeCubit: sourceCubit,
                        state: state,
                      ));
                }

              }
            },
            selectedTileColor: Colors.blueGrey[100],
            selected:
                sourceCubit.selectedUnitTypes.contains(currentUnitType.name),
            title: Text(currentUnitType.name),
          );
        },
        itemCount: sourceCubit.unitTypes.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UnitTypeCubit, UnitTypeState>(
      listener: (context, state) {
        if (state is ModifyUnitTypeError) {
          Constants.showToast(
              msg: "ModifyUnitTypeError: " + state.msg, context: context);
        }

        if (state is EndModifyUnitType) {
          Constants.showToast(
              msg: "تم بنجاح", color: Colors.green, context: context);
        }
      },
      builder: (context, state) {
        final unitTypeCubit = UnitTypeCubit.get(context);

        return Scaffold(
          appBar: UnitTypesAppBar(
            sourceType: unitTypesArgs.unitTypesType,
            onSearchChangeCallback: (search) {
              unitTypeCubit.getAllUnitTypesByNameLike(name: search);
            },
            onCancelTapCallback: (isSearch) {
              if (!isSearch) {
                unitTypeCubit.getAllUnitTypesByNameLike();
              }
            },
            onDoneTapCallback: () {
              Navigator.pop(context, unitTypeCubit.selectedUnitTypes);
            },
            onNewTapCallback: () {
              Constants.showDialogBox(
                  context: context,
                  title: "أضف مصدر جديد",
                  content: ModifyUnitTypeWidget(
                    unitTypeCubit: unitTypeCubit,
                    state: state,
                  ));
            },
          ),
          body: _buildBody(unitTypeCubit, state),
        );
      },
    );
  }
}

class UnitTypesArgs {
  final String unitTypesType;
  final List<String>? selectedUnitTypesNames;

  UnitTypesArgs({required this.unitTypesType, this.selectedUnitTypesNames});
}
