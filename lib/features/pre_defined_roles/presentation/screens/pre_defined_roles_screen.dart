import 'dart:math';

import 'package:crm_flutter_project/core/utils/app_strings.dart';
import 'package:crm_flutter_project/core/utils/constants.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/features/pre_defined_roles/presentation/cubit/pre_defined_roles_cubit.dart';
import 'package:crm_flutter_project/features/pre_defined_roles/presentation/screens/modify_pre_defined_role_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/error_item_widget.dart';

class PreDefinedRolesScreen extends StatelessWidget {
  final String preDefinedRoleType;

  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;

  PreDefinedRolesScreen({Key? key, required this.preDefinedRoleType})
      : super(key: key) {
    if (Responsive.isWindows || Responsive.isLinux || Responsive.isMacOS) {
      _scrollController.addListener(() {
        ScrollDirection scrollDirection =
            _scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = _scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? _extraScrollSpeed
                  : -_extraScrollSpeed);
          scrollEnd = min(_scrollController.position.maxScrollExtent,
              max(_scrollController.position.minScrollExtent, scrollEnd));
          _scrollController.jumpTo(scrollEnd);
        }
      });
    }
  }

  Widget _buildBody(
      PreDefinedRolesCubit preDefinedRolesCubit, PreDefinedRolesState state) {
    if (state is StartGetAllPreDefinedRoles) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is GetAllPreDefinedRolesError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          preDefinedRolesCubit.getAllPreDefinedRoles();
        },
      );
    }


    if (preDefinedRolesCubit.predefinedRoles.isEmpty) {
      return const Center(
        child: Text("لا يوجد اي دور ابدا بالاضافة من علامة + بالاعلي"),
      );
    }

    return Scrollbar(
      child: ListView.separated(
        controller: _scrollController,
        itemBuilder: (context, index) {
          final currentRole = preDefinedRolesCubit.predefinedRoles[index];
          return ListTile(
            onTap: () {
              if (preDefinedRoleType ==
                  PreDefinedRoleType.SELECT_PRE_DEFINED_ROLES.name) {
                Navigator.pop(context, currentRole);
              } else if (preDefinedRoleType ==
                  PreDefinedRoleType.VIEW_PRE_DEFINED_ROLES.name) {

                if (Constants.currentEmployee!.permissions.contains(AppStrings.editPreDefinedRoles)) {
                  Navigator.pushNamed(context, Routes.modifyPreDefinedRoleRoute,
                      arguments: ModifyPreDefinedRoleArgs(
                          preDefinedRolesCubit: preDefinedRolesCubit,
                          fromRoute: Routes.preDefinedRolesRoute,
                          roleModel: currentRole));
                }

              }
            },
            title: Text(currentRole.name),
            trailing: state is StartDeletePredefinedRole ?

            const SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator()) :

            (Constants.currentEmployee!.permissions.contains(AppStrings.deletePreDefinedRoles) ?
            IconButton(
              onPressed: () async {

                final confirmDelete = await Constants.showConfirmDialog(context: context, msg: "هل تريد تأكيد الحذف؟");
                if (confirmDelete) {
                  preDefinedRolesCubit.deletePreDefinedRole(currentRole.roleId!);
                }

              },
              icon: const Icon(Icons.delete),
            ) : null),
          );
        },
        itemCount: preDefinedRolesCubit.predefinedRoles.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreDefinedRolesCubit, PreDefinedRolesState>(
      listener: (context, state) {
        if (state is DeletePredefinedRoleError) {
          Constants.showToast(msg: "DeletePredefinedRoleError: " + state.msg, context: context);
        }

        if (state is EndDeletePredefinedRole) {
          Constants.showToast(msg: "تم حذف الدور بنجاح" , color: Colors.green, context: context);
        }
      },
      builder: (context, state) {
        final preDefinedRolesCubit = PreDefinedRolesCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text("الادوار"),
            actions: [
              
              if (Constants.currentEmployee!.permissions.contains(AppStrings.createPreDefinedRoles))
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, Routes.modifyPreDefinedRoleRoute,
                        arguments: ModifyPreDefinedRoleArgs(
                            preDefinedRolesCubit: preDefinedRolesCubit,
                            fromRoute: Routes.preDefinedRolesRoute));
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          body: _buildBody(preDefinedRolesCubit, state),
        );
      },
    );
  }
}
