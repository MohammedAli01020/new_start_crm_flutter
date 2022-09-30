import 'dart:math';

import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:crm_flutter_project/features/pre_defined_roles/domain/use_cases/pre_defined_roles_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/waiting_item_widget.dart';
import '../../../employees/data/models/role_model.dart';
import '../../../permissions/presentation/cubit/permission_cubit.dart';
import '../cubit/pre_defined_roles_cubit.dart';

class ModifyPreDefinedRoleScreen extends StatefulWidget {
  final ModifyPreDefinedRoleArgs modifyPreDefinedRoleArgs;

  final _scrollController = ScrollController();
  static const _extraScrollSpeed = 80;

  ModifyPreDefinedRoleScreen({Key? key, required this.modifyPreDefinedRoleArgs})
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

  @override
  State<ModifyPreDefinedRoleScreen> createState() =>
      _ModifyPreDefinedRoleScreenState();
}

class _ModifyPreDefinedRoleScreenState
    extends State<ModifyPreDefinedRoleScreen> {
  final formKey = GlobalKey<FormState>();

  int? roleId;
  final _roleNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final preDefinedRolesCubit = BlocProvider.of<PreDefinedRolesCubit>(context);
    if (widget.modifyPreDefinedRoleArgs.roleModel != null) {
      roleId = widget.modifyPreDefinedRoleArgs.roleModel!.roleId;
      _roleNameController.text =
          widget.modifyPreDefinedRoleArgs.roleModel!.name.substring(5);
      preDefinedRolesCubit.updateAllPermissions(
          widget.modifyPreDefinedRoleArgs.roleModel!.permissions);
    } else {
      preDefinedRolesCubit.updateAllPermissions([]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget._scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreDefinedRolesCubit, PreDefinedRolesState>(
      listener: (context, state) {
        if (state is ModifyPredefinedRoleError) {
          Constants.showToast(msg: "ModifyPredefinedRoleError: " + state.msg, context: context);
        }

        if (state is EndModifyPredefinedRole) {
          // edit
          if (widget.modifyPreDefinedRoleArgs.roleModel != null) {
            Constants.showToast(
                msg: "تم تعديل الدور بنجاح",
                color: Colors.green,
                context: context);
          } else {
            Constants.showToast(
                msg: "تم أضافة الدور بنجاح",
                color: Colors.green,
                context: context);
          }

          Navigator.popUntil(context,
              ModalRoute.withName(widget.modifyPreDefinedRoleArgs.fromRoute));
        }
      },
      builder: (context, state) {

        if (state is StartModifyPredefinedRole) {
          return const WaitingItemWidget();
        }

        final preDefinedRolesCubit = PreDefinedRolesCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.modifyPreDefinedRoleArgs.roleModel != null
                ? "عدل الدور"
                : "انشأ الدور"),
            actions: [
              IconButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {


                      preDefinedRolesCubit.modifyPreDefinedRole(
                        ModifyRoleParam(
                            roleId: roleId,
                            name: _roleNameController.text,
                            permissionsIds: preDefinedRolesCubit.selectedPermissions.map((e) => e.permissionId).toList())
                      );

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
                controller: widget._scrollController,
                slivers: [
                   SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("ملحوظة احرص علي عدم تكرار هذا الاسم", style: TextStyle(fontSize: 14.0,
                      color: AppColors.hint),),
                    ),
                  ),
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
                    final currentPermission =
                        Constants.employeesPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
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
                    final currentPermission =
                        Constants.leadsViewPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
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
                    final currentPermission =
                        Constants.leadsEditPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
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
                    final currentPermission =
                        Constants.leadsDeletePermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
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
                    final currentPermission =
                        Constants.leadsInsidePermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
                              .updateSelectedPermissions(currentPermission);
                        });
                  }, childCount: Constants.leadsInsidePermissions.length)),
                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child:
                            const Text("اذونات اتخاذ اكشن والعملايات المجمعة")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    final currentPermission =
                        Constants.actionsAndBulkActionsPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
                              .updateSelectedPermissions(currentPermission);
                        });
                  },
                          childCount: Constants
                              .actionsAndBulkActionsPermissions.length)),
                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات الاحداث")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    final currentPermission =
                        Constants.eventsPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
                              .updateSelectedPermissions(currentPermission);
                        });
                  }, childCount: Constants.eventsPermissions.length)),
                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات المطورين")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    final currentPermission =
                        Constants.developersPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
                              .updateSelectedPermissions(currentPermission);
                        });
                  }, childCount: Constants.developersPermissions.length)),
                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات المشاريع")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    final currentPermission =
                        Constants.projectsPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
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
                    final currentPermission =
                        Constants.sourcesPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
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
                    final currentPermission =
                        Constants.unitTypesPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
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
                    final currentPermission =
                        Constants.groupsPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
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
                    final currentPermission =
                        Constants.reportsPermissions[index];
                    return CheckboxListTile(
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
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
                        value: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        title: Text(currentPermission.name),
                        selected: preDefinedRolesCubit.selectedPermissions
                            .contains(currentPermission),
                        onChanged: (val) {
                          preDefinedRolesCubit
                              .updateSelectedPermissions(currentPermission);
                        });
                  }, childCount: Constants.logsPermissions.length)),


                  SliverToBoxAdapter(
                    child: Container(
                        width: context.width,
                        padding: const EdgeInsets.all(16.0),
                        color: Colors.blueGrey[100],
                        child: const Text("اذونات الادوار والاذونات")),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final currentPermission = Constants.preDefinedRolesPermissions[index];
                        return CheckboxListTile(
                            value: preDefinedRolesCubit.selectedPermissions
                                .contains(currentPermission),
                            title: Text(currentPermission.name),
                            selected: preDefinedRolesCubit.selectedPermissions
                                .contains(currentPermission),
                            onChanged: (val) {
                              preDefinedRolesCubit
                                  .updateSelectedPermissions(currentPermission);
                            });
                      }, childCount: Constants.preDefinedRolesPermissions.length)),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Row(
            children: [
              Expanded(
                child: DefaultButtonWidget(
                  onTap: () {
                    BlocProvider.of<PermissionCubit>(context)
                        .updateAllPermissions([]);
                  },
                  text: "مسح الكل",
                ),
              ),
              Expanded(
                child: DefaultButtonWidget(
                  color: Colors.green,
                  onTap: () {
                    final preDefinedRolesCubit =
                        BlocProvider.of<PermissionCubit>(context);
                    preDefinedRolesCubit
                        .updateAllPermissions(preDefinedRolesCubit.permissions);
                  },
                  text: "تحديد الكل",
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ModifyPreDefinedRoleArgs {
  final RoleModel? roleModel;
  final PreDefinedRolesCubit preDefinedRolesCubit;
  final String fromRoute;

  ModifyPreDefinedRoleArgs(
      {this.roleModel,
      required this.preDefinedRolesCubit,
      required this.fromRoute});
}
