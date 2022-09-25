import '../../../../core/utils/wrapper.dart';
import '../../domain/entities/customer_table_config.dart';

class CustomerTableConfigModel extends CustomerTableConfig {
  const CustomerTableConfigModel(
      {required bool showName,
      required bool showPhone,
      required bool showAssignedTo,
      required bool showLastAction,
      required bool showSources,
      required bool showUnitTypes,
        required bool showDevelopers,
        required bool showProjects,
      required bool showLastActionTime,
      required bool showLastComment,
      required bool showInsertDate,
      required bool showCreateBy,
      required bool showAssignedBy,
      required bool showReminderTime,
      required bool showDuplicateNumber})
      : super(
            showName: showName,
            showPhone: showPhone,
            showAssignedTo: showAssignedTo,
            showLastAction: showLastAction,
            showSources: showSources,
            showUnitTypes: showUnitTypes,
            showDevelopers: showDevelopers,
            showProjects: showProjects,
            showLastActionTime: showLastActionTime,
            showLastComment: showLastComment,
            showInsertDate: showInsertDate,
            showCreateBy: showCreateBy,
            showAssignedBy: showAssignedBy,
            showReminderTime: showReminderTime,
            showDuplicateNumber: showDuplicateNumber);

  factory CustomerTableConfigModel.fromJson(Map<String, dynamic> json) {
    return CustomerTableConfigModel(
        showName: json['showName'],
        showPhone: json['showPhone'],
        showAssignedTo: json['showAssignedTo'],
        showLastAction: json['showLastAction'],
        showSources: json['showSources'],
        showUnitTypes: json['showUnitTypes'],
        showDevelopers: json['showDevelopers'],
        showProjects: json['showProjects'],

        showLastActionTime: json['showLastActionTime'],
        showLastComment: json['showLastComment'],
        showInsertDate: json['showInsertDate'],
        showCreateBy: json['showCreateBy'],
        showAssignedBy: json['showAssignedBy'],
        showReminderTime: json['showReminderTime'],
        showDuplicateNumber: json['showDuplicateNumber']);
  }

  Map<String, dynamic> toJson() => {
        "showName": showName,
        "showPhone": showPhone,
        "showAssignedTo": showAssignedTo,
        "showLastAction": showLastAction,
        'showSources': showSources,
        "showUnitTypes": showUnitTypes,

    "showDevelopers": showDevelopers,
    "showProjects": showProjects,


    "showLastActionTime": showLastActionTime,
        "showLastComment": showLastComment,
        "showInsertDate": showInsertDate,
        "showCreateBy": showCreateBy,
        "showAssignedBy": showAssignedBy,
        "showReminderTime": showReminderTime,
        "showDuplicateNumber": showDuplicateNumber
      };

  CustomerTableConfigModel copyWith(
      {Wrapped<bool>? showName,
      Wrapped<bool>? showPhone,
      Wrapped<bool>? showAssignedTo,
      Wrapped<bool>? showLastAction,
      Wrapped<bool>? showSources,
      Wrapped<bool>? showUnitTypes,


        Wrapped<bool>? showDevelopers,
        Wrapped<bool>? showProjects,



        Wrapped<bool>? showLastActionTime,
      Wrapped<bool>? showLastComment,
      Wrapped<bool>? showInsertDate,
      Wrapped<bool>? showCreateBy,
      Wrapped<bool>? showAssignedBy,
      Wrapped<bool>? showReminderTime,
      Wrapped<bool>? showDuplicateNumber}) {
    return CustomerTableConfigModel(
        showName: showName != null ? showName.value : this.showName,
        showPhone: showPhone != null ? showPhone.value : this.showPhone,
        showAssignedTo:
            showAssignedTo != null ? showAssignedTo.value : this.showAssignedTo,
        showLastAction:
            showLastAction != null ? showLastAction.value : this.showLastAction,
        showSources: showSources != null ? showSources.value : this.showSources,

        showUnitTypes: showUnitTypes != null ? showUnitTypes.value : this.showUnitTypes,

        showDevelopers: showDevelopers != null ? showDevelopers.value : this.showDevelopers,
        showProjects: showProjects != null ? showProjects.value : this.showProjects,

        showLastActionTime: showLastActionTime != null
            ? showLastActionTime.value
            : this.showLastActionTime,
        showLastComment: showLastComment != null
            ? showLastComment.value
            : this.showLastComment,
        showInsertDate:
            showInsertDate != null ? showInsertDate.value : this.showInsertDate,
        showCreateBy:
            showCreateBy != null ? showCreateBy.value : this.showCreateBy,
        showAssignedBy:
            showAssignedBy != null ? showAssignedBy.value : this.showAssignedBy,
        showReminderTime: showReminderTime != null
            ? showReminderTime.value
            : this.showReminderTime,
        showDuplicateNumber: showDuplicateNumber != null
            ? showDuplicateNumber.value
            : this.showDuplicateNumber);
  }

  factory CustomerTableConfigModel.initial() {
    return const CustomerTableConfigModel(
        showName: true,
        showPhone: true,
        showAssignedTo: true,
        showLastAction: true,
        showSources: true,
        showUnitTypes: true,
        showDevelopers: true,
        showProjects: true,
        showLastActionTime: true,
        showLastComment: true,
        showInsertDate: true,
        showCreateBy: true,
        showAssignedBy: true,
        showReminderTime: true,
        showDuplicateNumber: true);
  }
}
