
import 'dart:io';

import 'package:crm_flutter_project/config/routes/app_routes.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/role_model.dart';
import 'package:crm_flutter_project/features/employees/domain/use_cases/employee_use_cases.dart';
import 'package:crm_flutter_project/features/employees/presentation/cubit/employee_cubit.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../../../core/widgets/waiting_item_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ModifyEmployeeScreen extends StatefulWidget {
  final ModifyEmployeeArgs modifyEmployeeArgs;
  const ModifyEmployeeScreen({Key? key, required this.modifyEmployeeArgs}) : super(key: key);

  @override
  State<ModifyEmployeeScreen> createState() => _ModifyEmployeeScreenState();
}

class _ModifyEmployeeScreenState extends State<ModifyEmployeeScreen> {

  final formKey = GlobalKey<FormState>();

  int? employeeId;

  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  String? imageUrl;
  File? toBeUploadedImageFile;
  String? toBeDeletedImage;

  int createDateTime = DateTime.now().millisecondsSinceEpoch;


  bool enabled = true;

  int? createdByEmployeeId = Constants.currentEmployee?.employeeId;

  @override
  void initState() {
    super.initState();

    final cubit = BlocProvider.of<EmployeeCubit>(context);

    if (widget.modifyEmployeeArgs.employeeModel != null) {
      employeeId = widget.modifyEmployeeArgs.employeeModel!.employeeId;
      imageUrl = widget.modifyEmployeeArgs.employeeModel!.imageUrl;
      createDateTime = widget.modifyEmployeeArgs.employeeModel!.createDateTime;
      enabled =  widget.modifyEmployeeArgs.employeeModel!.enabled;

      createdByEmployeeId = widget.modifyEmployeeArgs.employeeModel!.createdBy;

      _fullNameController.text = widget.modifyEmployeeArgs.employeeModel!.fullName;
      _usernameController.text = widget.modifyEmployeeArgs.employeeModel!.username;

      _phoneNumberController.text = widget.modifyEmployeeArgs.employeeModel!.phoneNumber;

      cubit.findRoleByEmployeeId(employeeId!);
    } else {
      cubit.updateRole(null);
    }

  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is ModifyEmployeeError) {
          Constants.showToast(msg: "ModifyEmployeeError: " + state.msg, context: context);
        }

        if (state is EndModifyEmployee) {
          // edit
          if (widget.modifyEmployeeArgs.employeeModel != null) {
            Constants.showToast(
                msg: "تم تعديل الموظف بنجاح",
                color: Colors.green,
                context: context);
          } else {
            Constants.showToast(
                msg: "تم أضافة الموظف بنجاح",
                color: Colors.green,
                context: context);
          }

          Navigator.popUntil(context,
              ModalRoute.withName(widget.modifyEmployeeArgs.fromRoute));
        }
      },
      builder: (context, state) {
        final cubit = EmployeeCubit.get(context);

        if (state is StartModifyEmployee) {
          return const WaitingItemWidget();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.modifyEmployeeArgs.employeeModel != null
                ? "عدل الموظف"
                : "أضف الموظف"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Visibility(
                        visible: imageUrl == null && toBeUploadedImageFile == null,
                        child: TextButton(onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                              type: FileType.image
                          );

                          if (result != null && result.files.single.path != null) {
                            toBeUploadedImageFile = File(result.files.single.path!);
                            setState(() {});
                          }

                        }, child: const Text("اضف صورة"))),


                    toBeUploadedImageFile != null?
                    Stack(
                      children: [
                        Image.file(
                          File(toBeUploadedImageFile!.path),
                          fit: BoxFit.cover,
                          height: 100.0,
                          width: 100.0,
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon:  Icon(
                                Icons.delete,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                toBeDeletedImage = imageUrl;
                                toBeUploadedImageFile = null;
                                imageUrl = null;
                                setState(() {});
                              },
                            )),
                      ],

                    ): imageUrl != null
                        ? Stack(
                      children: [
                        CachedNetworkImage(
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.cover,
                          imageUrl: imageUrl!,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              color: AppColors.hint.withOpacity(0.2),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                        Positioned(
                            top: 0,
                            left: 0,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon:  Icon(
                                Icons.delete,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                toBeDeletedImage = imageUrl;
                                toBeUploadedImageFile = null;
                                imageUrl = null;
                                setState(() {});
                              },
                            )),
                      ],
                    )
                        : const Text("لا يوجد صورة"),

                    const DefaultHeightSizedBox(),


                    CustomEditText(
                        controller: _fullNameController,
                        hint: "الاسم بالكامل",
                        maxLength: 50,
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
                    CustomEditText(
                        controller: _usernameController,
                        hint: "الايميل",
                        validator: (v) {

                          if (v!.isEmpty) {
                            return AppStrings.required;
                          }

                          if (Constants.validateEmail(v, context) != null &&
                              Constants.validateMobile(v) != null) {
                            return "ادخل ايميل صحيح";
                          }

                          return null;
                        },
                        inputType: TextInputType.emailAddress,

                    ),

                    const DefaultHeightSizedBox(),

                    CustomEditText(
                      maxLines: 1,
                      hint: widget.modifyEmployeeArgs.employeeModel != null ? "عدل كلمة السر او اتركها كما كانت":"كلمة السر",
                      // isPassword: !isVisible,
                      controller: _passwordController,
                      validator: (v) {
                        if (v!.isEmpty && widget.modifyEmployeeArgs.employeeModel == null) {
                          return AppStrings.required;
                        }

                        return null;
                      },
                      inputType: TextInputType.visiblePassword,
                    ),

                    const DefaultHeightSizedBox(),

                    CustomEditText(
                        controller: _phoneNumberController,
                        hint: "رقم الهاتف",
                        maxLength: 50,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.required;
                          }

                          if (v.length > 50) {
                            return "اقصي عدد احرف 50";
                          }

                          if (v != null && v.length < 11) {
                            return "اقل عدد احرف 11";
                          }

                          return null;
                        },
                        inputType: TextInputType.phone),

                    const DefaultHeightSizedBox(),



                     Visibility(
                       visible: state is! StartFindRoleByEmployeeId,
                       replacement: const Text("جاري تحميل االاذونات ..."),
                       child: Card(
                         child: ListTile(
                          title: Text(
                              cubit.currentRole != null ? "عدل الدور والاذونات":
                          "انشأ الدور والاذونات"),
                           subtitle: Text(cubit.currentRole != null ?
                           cubit.currentRole!.name : "لم يتم اختيار اي دور لهذا المستخدم",
                           maxLines: 1,
                               overflow: TextOverflow.ellipsis,),

                           onTap: () {

                            if (!Constants.currentEmployee!.permissions.contains(AppStrings.editEmployeeRole))  {
                              Constants.showToast(msg: "غير مصرح لك", context: context);
                              return;
                            }


                            if (state is StartFindRoleByEmployeeId) {
                              Constants.showToast(msg: "انتظر جاري تحميل الاذونات ...", context: context);
                              return;
                            }


                            Navigator.pushNamed(context, Routes.modifyRole,
                            arguments: cubit.currentRole).then((value) {

                              if (value != null && value is RoleModel) {
                                cubit.updateRole(value);
                              }

                            });
                           },
                    ),
                       ),
                     ),

                    const DefaultHeightSizedBox(),

                    EnabledWidget(
                      enabled: enabled,
                      onSelectCallback: (bool val) {
                        enabled = val;
                      },

                    ),

                    const DefaultHeightSizedBox(),
                    const DefaultHeightSizedBox(),

                    DefaultButtonWidget(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {

                            cubit.modifyEmployee(ModifyEmployeeParam(employeeId: employeeId,
                                fullName: _fullNameController.text,
                                imageUrl: imageUrl,
                                createDateTime: createDateTime,
                                phoneNumber: _phoneNumberController.text.trim(),
                                enabled: enabled,
                                username: _usernameController.text.trim(),
                                password: widget.modifyEmployeeArgs.employeeModel != null
                                    ? (_passwordController.text.isNotEmpty
                                    ? _passwordController.text
                                    : null)
                                    : _passwordController.text,
                                role: cubit.currentRole,
                                createdByEmployeeId: createdByEmployeeId),
                                toBeUploadedImageFile,
                                toBeDeletedImage);
                          }
                        },
                        text: widget.modifyEmployeeArgs.employeeModel != null
                            ? "عدل الموظف"
                            : "أضف الموظف")
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ModifyEmployeeArgs {
  final EmployeeModel? employeeModel;
  final EmployeeCubit employeeCubit;
  final String fromRoute;

  ModifyEmployeeArgs(
      {this.employeeModel,
        required this.employeeCubit,
        required this.fromRoute});
}

class EnabledWidget extends StatefulWidget {
  final bool enabled;
  final Function onSelectCallback;
  const EnabledWidget({Key? key, required this.enabled,
    required this.onSelectCallback}) : super(key: key);

  @override
  State<EnabledWidget> createState() => _EnabledWidgetState();
}

class _EnabledWidgetState extends State<EnabledWidget> {

  bool enabled = true;

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        subtitle: enabled ? const Text("نشط" ,style:  TextStyle(color: Colors.green)) : const Text("متوقف" ,style: TextStyle(color: Colors.red),),
        title: const Text("الحالة"),
        onChanged: (bool? value) {

          if (!Constants.currentEmployee!.permissions.contains(AppStrings.disableEmployee)) {
            Constants.showToast(msg: "غير مصرح لك", context: context);

            return;
          }

          if (value != null) {
            enabled = value;
            setState(() {});
            widget.onSelectCallback(value);
          }
        },
        value: enabled,
      ),
    );
  }
}
