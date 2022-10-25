import 'package:crm_flutter_project/config/routes/app_routes.dart';
import 'package:crm_flutter_project/core/utils/enums.dart';
import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:crm_flutter_project/features/teams/data/models/team_model.dart';
import 'package:crm_flutter_project/features/teams/domain/use_cases/team_use_cases.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_cubit.dart';
import 'package:crm_flutter_project/features/teams/presentation/cubit/team_members/team_members_cubit.dart';
import 'package:crm_flutter_project/features/employees/presentation/screens/employee_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_button_widget.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../../../core/widgets/waiting_item_widget.dart';

class ModifyTeamScreen extends StatefulWidget {
  final ModifyTeamArgs modifyTeamArgs;
  const ModifyTeamScreen({Key? key, required this.modifyTeamArgs}) : super(key: key);

  @override
  State<ModifyTeamScreen> createState() => _ModifyTeamScreenState();
}

class _ModifyTeamScreenState extends State<ModifyTeamScreen> {
  final formKey = GlobalKey<FormState>();

  int? teamId;

  final  _titleController = TextEditingController();
  final  _descriptionController = TextEditingController();
  int? createdByEmployeeId;
  int createDateTime = DateTime.now().millisecondsSinceEpoch;
  int? teamLeaderId;

  EmployeeModel? teamLeader;

  @override
  void initState() {
    super.initState();

    if (widget.modifyTeamArgs.teamModel != null) {
      teamId = widget.modifyTeamArgs.teamModel!.teamId;

      _titleController.text = widget.modifyTeamArgs.teamModel!.title;
      _descriptionController.text = widget.modifyTeamArgs.teamModel!.description != null &&
          widget.modifyTeamArgs.teamModel!.description!.isNotEmpty
          ? widget.modifyTeamArgs.teamModel!.description!
          : "";

      createdByEmployeeId = widget.modifyTeamArgs.teamModel!.createdBy?.employeeId;
      createDateTime = widget.modifyTeamArgs.teamModel!.createDateTime;

      teamLeaderId = widget.modifyTeamArgs.teamModel!.teamLeader?.employeeId;
      teamLeader = widget.modifyTeamArgs.teamModel!.teamLeader;
    } else {
      createdByEmployeeId = Constants.currentEmployee!.employeeId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamCubit, TeamState>(
      listener: (context, state) {
        if (state is ModifyTeamError) {
          Constants.showToast(msg: "ModifyTeamError: " + state.msg, context: context);
        }

        if (state is EndModifyTeam) {
          // edit
          if (widget.modifyTeamArgs.teamModel != null) {
            Constants.showToast(
                msg: "تم تعديل التيم بنجاح", color: Colors.green, context: context);
          } else {
            Constants.showToast(
                msg: "تم أضافة التيم بنجاح", color: Colors.green, context: context);
          }

          Navigator.popUntil(
              context, ModalRoute.withName(widget.modifyTeamArgs.fromRoute));

        }
      },
      builder: (context, state) {
        final cubit = TeamCubit.get(context);

        if (state is StartModifyTeam) {
          return const WaitingItemWidget();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.modifyTeamArgs.teamModel != null
                ? "عدل التيم"
                : "أضف التيم"),
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
                    CustomEditText(
                        controller: _titleController,
                        hint: "اسم التيم",
                        maxLength: 50,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return AppStrings.required;
                          }


                          if (v.length > 50) {
                            return "اقصي عدد احرف 50";
                          }

                          return null;

                        },
                        inputType: TextInputType.text),
                    const DefaultHeightSizedBox(),
                    CustomEditText(
                        controller: _descriptionController,
                        hint: "الوصف",
                        validator: (v) {

                          if (v == null && v!.isNotEmpty) {
                            if (v.length > 5000) {
                              return "اقصي عدد احرف 5000";
                            }
                          }

                          return null;
                        },
                        inputType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 14,
                        maxLength: 5000
                    ),
                    const DefaultHeightSizedBox(),

                    TeamLeaderPicker(modifyTeamArgs: widget.modifyTeamArgs, teamLeader: teamLeader,
                      onSelectTeamLeaderCallback: (EmployeeModel leader) {
                      teamLeader = leader;
                      teamLeaderId = leader.employeeId;
                      }, onDeleteTeamLeaderCallback: () {
                        teamLeader = null;
                        teamLeaderId = null;
                      },),


                    const DefaultHeightSizedBox(),
                    const DefaultHeightSizedBox(),
                    DefaultButtonWidget(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            cubit.modifyTeam(ModifyTeamParam(
                                teamId: teamId,
                                title: _titleController.text,
                                description: _descriptionController.text,
                                createdByEmployeeId: createdByEmployeeId,
                                createDateTime: createDateTime,
                                teamLeaderId: teamLeaderId));
                          }
                        },
                        text: widget.modifyTeamArgs.teamModel != null
                            ? "عدل التيم"
                            : "أضف التيم")
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
  }
}

class TeamLeaderPicker extends StatefulWidget {
  final ModifyTeamArgs modifyTeamArgs;
  final EmployeeModel? teamLeader;
  final Function onSelectTeamLeaderCallback;
  final VoidCallback onDeleteTeamLeaderCallback;

  const TeamLeaderPicker({Key? key, required this.modifyTeamArgs, this.teamLeader,
    required this.onSelectTeamLeaderCallback, required this.onDeleteTeamLeaderCallback}) : super(key: key);

  @override
  State<TeamLeaderPicker> createState() => _TeamLeaderPickerState();
}

class _TeamLeaderPickerState extends State<TeamLeaderPicker> {

  EmployeeModel? leader;
  @override
  void initState() {
    super.initState();
    leader  = widget.teamLeader;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [


        const Text("التيم ليدر"),
        const DefaultHeightSizedBox(),
        if (leader != null)
        Row(
          children: [
            Container(
              alignment: Alignment.center,
              child: ClipOval(
                  child: leader!.imageUrl != null
                      ? CachedNetworkImage(
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                    imageUrl: leader!.imageUrl!,
                    placeholder: (context, url) =>
                        Container(
                          decoration: BoxDecoration(
                            color:
                            AppColors.hint.withOpacity(0.2),
                          ),
                        ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  )
                      : CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 25.0,
                      child: Text(
                        leader!
                            .fullName.characters.first,
                        style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))),
              height: 50.0,
              width: 50.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10.0,),
            Text(leader!.fullName),
            const SizedBox(width: 10.0,),
            IconButton(
              onPressed: () {
                leader = null;
                setState(() {});
                widget.onDeleteTeamLeaderCallback();
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),

        OutlinedButton(
          onPressed: () {

            Navigator.pushNamed(context, Routes.employeePickerRoute,
                arguments: EmployeePickerArgs(
                  teamMembersCubit: widget.modifyTeamArgs.teamMembersCubit!,
                    employeePickerTypes: EmployeePickerTypes.SELECT_TEAM_LEADER.name,

                    excludeTeamLeader: widget.modifyTeamArgs.teamModel != null && widget.modifyTeamArgs.teamModel!.teamLeader != null ?
                    widget.modifyTeamArgs.teamModel!.teamLeader!.employeeId : null,
                    notInThisTeamId: widget.modifyTeamArgs.teamModel != null ?
                    widget.modifyTeamArgs.teamModel!.teamId : null

                )).then((value) {
              if (value != null && value is Map<String, dynamic>) {
                debugPrint(value.toString());
                EmployeeModel em = EmployeeModel.fromJson(value);
                leader = em;
              }

              setState(() {});

              widget.onSelectTeamLeaderCallback(leader);


            });
          },
          child: Text(leader == null ? "اختر تيم ليدير" : "غير التيم ليدير"),
        ),
      ],
    );
  }
}


class ModifyTeamArgs {
  final TeamModel? teamModel;
  final TeamCubit teamCubit;
  final TeamMembersCubit? teamMembersCubit;
  final String fromRoute;

  ModifyTeamArgs(
      {this.teamModel,
        required this.teamCubit,
        this.teamMembersCubit,
        required this.fromRoute});
}

