import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/core/widgets/default_hieght_sized_box.dart';
import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';
import 'package:crm_flutter_project/features/permissions/presentation/cubit/permission_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/error_item_widget.dart';

class ModifyRoleScreen extends StatefulWidget {
  final RoleModel? roleModel;

  const ModifyRoleScreen({Key? key, this.roleModel}) : super(key: key);

  @override
  State<ModifyRoleScreen> createState() => _ModifyRoleScreenState();
}

class _ModifyRoleScreenState extends State<ModifyRoleScreen> {
  final formKey = GlobalKey<FormState>();

  int? roleId;
  final _roleNameController = TextEditingController();

  Widget _buildListView(PermissionCubit cubit, PermissionState state) {
    if (state is StartGetAllPermissionsByNameLike) {
      return const CircularProgressIndicator();
    }

    if (state is GetAllPermissionsByNameLikeError) {
      return ErrorItemWidget(
        msg: state.msg,
        onPress: () {
          cubit.getAllPermissionsByNameLike();
        },
      );
    }

    return Expanded(
        child: ListView.separated(
      itemBuilder: (context, index) {
        final currentPermission = cubit.permissions[index];

        return CheckboxListTile(
            value: cubit.selectedPermissions.contains(currentPermission),
            title: Text(currentPermission.name),
            selected: cubit.selectedPermissions.contains(currentPermission),
            onChanged: (val) {
              cubit.updateSelectedPermissions(currentPermission);
            });
      },
      itemCount: cubit.permissions.length,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    ));
  }

  @override
  void initState() {
    super.initState();

    final permissionCubit = BlocProvider.of<PermissionCubit>(context);
    if (widget.roleModel != null) {
      roleId = widget.roleModel!.roleId;
      _roleNameController.text = widget.roleModel!.name.substring(5);
      permissionCubit.updateAllPermissions(widget.roleModel!.permissions);
    } else {
      permissionCubit.updateAllPermissions([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, PermissionState>(
      builder: (context, state) {
        final permissionCubit = PermissionCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.roleModel != null ? "عدل الدور" : "انشأ الدور"),
            actions: [
              IconButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(
                          context,
                          RoleModel(
                              roleId: roleId,
                              name: _roleNameController.text,
                              permissions:
                                  permissionCubit.selectedPermissions));
                    }
                  },
                  icon: const Icon(Icons.done))
            ],
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: CustomEditText(
                        controller: _roleNameController,
                        hint: "اسم الدور بالانجليزية بدون مسافات",
                        maxLength: 50,
                        inputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp("[0-9a-zA-Z]")),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.required;
                          }

                          if (v.length > 50) {
                            return "اقصي عدد احرف 50";
                          }

                          if (v.length < 2) {
                            return "اقل عدد احرف 2";
                          }

                          return null;
                        },
                        inputType: TextInputType.text),

                  ),
                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("الموظفين")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    final currentPermission = Constants.employeesPermissions[index];
                    return CheckboxListTile(
                        value: permissionCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: permissionCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          permissionCubit
                              .updateSelectedPermissions(currentPermission);
                        });
                  }, childCount: Constants.employeesPermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("مشاهدة العملاء")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.leadsViewPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.leadsViewPermissions.length)),

                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("تعديل واضافة العملاء")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.leadsEditPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.leadsEditPermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("حذف العملاء")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.leadsDeletePermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.leadsDeletePermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات بداخل العملاء")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.leadsInsidePermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.leadsInsidePermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات اتخاذ اكشن والعملايات المجمعة")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.actionsAndBulkActionsPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.actionsAndBulkActionsPermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات الاحداث")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.eventsPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.eventsPermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات المشاريع")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.projectsPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.projectsPermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات المصادر")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.sourcesPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.sourcesPermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات انواع الوحدات")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.unitTypesPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.unitTypesPermissions.length)),

                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات المجموعات")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.groupsPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.groupsPermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات التقارير")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.reportsPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.reportsPermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات السجلات")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.logsPermissions[index];
                        return CheckboxListTile(
                            value: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: permissionCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              permissionCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.logsPermissions.length)),
                ],

              ),
            ),
          ),
          bottomNavigationBar: Row(
            children: [
              Expanded(
                child: DefaultButtonWidget(
                  onTap: () {
                    permissionCubit.updateAllPermissions([]);
                  },
                  text: "مسح الكل",
                ),
              ),

              Expanded(
                child: DefaultButtonWidget(
                  color: Colors.green,
                  onTap: () {
                    permissionCubit.updateAllPermissions(permissionCubit.permissions);
                  },
                  text: "تحديد الكل",
                ),
              ),
            ],
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.roleModel != null ? "عدل الدور" : "انشأ الدور"),
            actions: [
              IconButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(
                          context,
                          RoleModel(
                              roleId: roleId,
                              name: _roleNameController.text,
                              permissions:
                                  permissionCubit.selectedPermissions));
                    }
                  },
                  icon: const Icon(Icons.done))
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  CustomEditText(
                      controller: _roleNameController,
                      hint: "اسم الدور بالانجليزية بدون مسافات",
                      maxLength: 50,
                      inputFormatter: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z]")),
                      ],
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return AppStrings.required;
                        }

                        if (v.length > 50) {
                          return "اقصي عدد احرف 50";
                        }

                        if (v.length < 2) {
                          return "اقل عدد احرف 2";
                        }

                        return null;
                      },
                      inputType: TextInputType.text),
                  const DefaultHeightSizedBox(),
                  _buildListView(permissionCubit, state),
                ],
              ),
            ),
          ),

          // bottomNavigationBar: Row(
          //   children: [
          //     Expanded(
          //       child: DefaultButtonWidget(
          //         onTap: () {
          //           _roleNameController.clear();
          //           permissionCubit.updateAllPermissions([]);
          //         },
          //         text: "مسح الكل",
          //       ),
          //     ),
          //
          //     Expanded(
          //       child: DefaultButtonWidget(
          //         color: Colors.green,
          //         onTap: () {
          //           permissionCubit.updateAllPermissions(permissionCubit.permissions);
          //         },
          //         text: "تحديد الكل",
          //       ),
          //     ),
          //   ],
          // ),
        );
      },
    );
  }
}
